# Запускаємо контейнер
$containerId = docker run -d -p 8080:80 olegmukhin/expense-tracker:latest

# Затримка для запуску сервісу
Start-Sleep -Seconds 1

# Тестуємо API
$response = Invoke-WebRequest -Uri "http://localhost:3000/api/healthcheck" -UseBasicParsing
if (-not $response.Content.Contains("ok")) {
    Write-Host "ERROR: API healthcheck failed. Response: $($response.Content)"
    docker logs $containerId
    docker rm -f $containerId
    exit 1
}

Write-Host "API healthcheck passed. Response: $($response.Content)"

# Зупиняємо контейнер
docker rm -f $containerId
