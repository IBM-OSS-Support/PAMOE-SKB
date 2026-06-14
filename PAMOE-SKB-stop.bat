@echo off
docker-compose down --volumes
rmdir /s /q repos

echo ✓ Stopped PAMOE services and cleaned up repositories.
pause
