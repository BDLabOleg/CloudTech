# Запускаємо контейнер
$containerId = docker run -d -p 8080:80 olegmukhin/expense-tracker:latest

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
Start-Sleep -Seconds 5

# Перевіряємо доступність сервісу
$responseCode = (Invoke-WebRequest -Uri "http://localhost:8080" -UseBasicParsing).StatusCode
if ($responseCode -ne 200) {
    Write-Host "ERROR: Service returned status code $responseCode"
    docker logs $containerId
    docker rm -f $containerId
    exit 1
}

Write-Host "Service is reachable and returned status code 200."

# Зупиняємо контейнер
docker rm -f $containerId
