# Запускаємо контейнер
$containerId = docker run -d -p 3000:3000 olegmukhin/expense-tracker:latest

# Перевіряємо, чи контейнер працює
$containerState = docker inspect -f '{{.State.Running}}' $containerId
if ($containerState -ne "true") {
    Write-Host "ERROR: Container failed to start."
    docker logs $containerId
    docker rm -f $containerId
    exit 1
}

Write-Host "Container is running successfully."

# Затримка для запуску сервісу
Start-Sleep -Seconds 1

# Перевіряємо доступність сервісу
Write-Host "Service returned:"
docker logs $containerId

Write-Host "Service is reachable"

# Зупиняємо контейнер
docker rm -f $containerId
