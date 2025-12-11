# BAMOE MCP Web App - Quick Start Guide

This guide will help you quickly set up and run the BAMOE MCP Web App using pre-built Docker images.


https://github.ibm.com/user-attachments/assets/4b698a6c-31cb-46d5-9222-6cf1e1bc49fd


## For End Users (Running the Application)

### What You Need

To run the BAMOE MCP Web App, you only need:
1. **docker-compose.yml** - The Docker Compose file
2. **.env.example** - Environment variable template (optional)
3. **Docker and Docker Compose** installed on your machine
4. **kubectl** configured with access to a Kubernetes cluster with BAMOE deployments

**Note:** Ollama with the granite3.3:8b model is now included in the Docker Compose setup - no manual installation required!

### Quick Start

#### Step 1: (Optional) Configure Environment Variables

```bash
# On macOS/Linux:
cp .env.example .env

# On Windows (PowerShell):
Copy-Item .env.example .env

# Edit .env to customize (optional):
# - PORT (default: 3000)
# - OLLAMA_MODEL (default: granite3.3:8b)
# - K8S_NAMESPACE (default: local-kie-sandbox-dev-deployments)
```

#### Step 2: Start the Application

```bash
docker-compose up -d
```

This single command will:
- Automatically create a Docker-specific kubeconfig at `~/.kube/config.docker` (transforms `127.0.0.1` to `host.docker.internal`)
- Start the Ollama container with granite3.3:8b model pre-loaded
- Start the BAMOE MCP Web Application

**Note:** The setup preserves your original `~/.kube/config` file untouched.

#### Step 3: Access the Application

Open your browser to: **http://localhost:3000**

1. The UI will show available BAMOE deployments from your Kubernetes cluster
2. Select a deployment from the dropdown
3. The MCP server will automatically deploy for the selected deployment
4. Start chatting with the AI!

#### Step 4: Stop the Application

```bash
docker-compose down
```

### How It Works

The distribution setup maintains all the functionality of the original application:

1. **Automatic Setup**: Creates Docker-specific kubeconfig automatically on first run
2. **Ollama Container**: Provides LLM capabilities with granite3.3:8b model pre-loaded
3. **Web App Container**: Runs the Express server and serves the UI (from pre-built image)
4. **Dynamic MCP Server Deployment**: The web app automatically deploys MCP server containers on-demand when you select a deployment
5. **Kubernetes Integration**: Fetches available BAMOE deployments from your cluster

### Prerequisites Details

#### 1. Docker and Docker Compose
Install from: https://docs.docker.com/get-docker/

Verify installation:
```bash
docker --version
docker-compose --version
```

#### 2. Kubernetes Access
Ensure you have kubectl configured with access to your Kubernetes cluster:
```bash
kubectl get services -n local-kie-sandbox-dev-deployments
```

### Troubleshooting

#### No deployments showing in UI?

1. Verify kubectl can access your cluster:
```bash
kubectl get services -n local-kie-sandbox-dev-deployments
```

2. Check the Docker-specific kubeconfig:
```bash
# On macOS/Linux:
grep "server:" ~/.kube/config.docker

# On Windows (PowerShell):
Select-String "server:" $HOME\.kube\config.docker

# Should show: server: https://host.docker.internal:<PORT>
```

3. Test the kubeconfig:
```bash
# On macOS/Linux:
kubectl --kubeconfig ~/.kube/config.docker get services -n local-kie-sandbox-dev-deployments --insecure-skip-tls-verify

# On Windows (PowerShell):
kubectl --kubeconfig $HOME\.kube\config.docker get services -n local-kie-sandbox-dev-deployments --insecure-skip-tls-verify
```

#### Ollama container issues?

1. Verify Ollama container is running:
```bash
docker ps | grep bamoe-ollama
```

2. Check Ollama container logs:
```bash
docker logs bamoe-ollama
```

3. Test Ollama API from within the network:
```bash
docker exec bamoe-mcp-web-app curl http://ollama:11434/api/tags
```

#### View application logs?

```bash
docker-compose logs -f
```

#### Port conflicts?

If port 3000 is in use, create a `.env` file:
```bash
# On macOS/Linux:
echo "PORT=3001" > .env

# On Windows (PowerShell):
"PORT=3001" | Out-File -FilePath .env -Encoding utf8
```

Then restart:
```bash
docker-compose down
docker-compose up -d
```

### Clean Up

To completely remove all containers and networks:

```bash
# Stop and remove containers
docker-compose down

# Also stop any dynamically created MCP servers
docker stop $(docker ps -q --filter "name=bamoe-mcp-server") 2>/dev/null || true
docker rm $(docker ps -aq --filter "name=bamoe-mcp-server") 2>/dev/null || true
```

### Configuration Reference

#### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `PORT` | Web application port | `3000` |
| `OLLAMA_MODEL` | Ollama model to use | `granite3.3:8b` |
| `OLLAMA_HOST` | Ollama API endpoint (containerized) | `http://ollama:11434` |
| `BAMOE_HOST` | BAMOE server host | `host.docker.internal` |
| `K8S_NAMESPACE` | Kubernetes namespace for BAMOE deployments | `local-kie-sandbox-dev-deployments` |

### Distribution Package

For easy distribution to users, provide these files:
- `docker-compose.yml` - Main deployment file (includes Ollama container)
- `.env.example` - Environment template
- `README.md` - This file (setup instructions)

Users only need these files plus Docker and kubectl configured - Ollama is now containerized!

### Support

For issues or questions:
- Check the troubleshooting section above
- Review the main README.md for detailed architecture information
- Check Docker logs: `docker-compose logs -f`
