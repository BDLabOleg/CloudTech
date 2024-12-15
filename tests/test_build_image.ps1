# Перевіряємо наявність Dockerfile
if (-not (Test-Path -Path ".\Dockerfile")) {
    Write-Host "ERROR: Dockerfile not found!"
    exit 1
}

# Спробуємо зібрати Docker-образ
docker build -t olegmukhin/expense-tracker:latest .
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to build Docker image."
    exit 1
}

Write-Host "Docker image built successfully."
