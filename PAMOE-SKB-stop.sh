#!/bin/bash
docker-compose down --volumes
rm -rf repos
echo "✅ Stopped PAMOE services and cleaned up repositories."
