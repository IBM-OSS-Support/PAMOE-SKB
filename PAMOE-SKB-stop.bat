@echo off
docker compose down
rmdir /s /q repos

echo ✓ Stopped PAMOE services and cleaned up repositories.
pause
