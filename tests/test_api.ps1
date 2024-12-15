# Запускаємо контейнер
$containerId = docker run -d -p 3000:3000 olegmukhin/expense-tracker:latest

# Затримка для запуску сервісу
Start-Sleep -Seconds 20  # Збільшуємо час очікування

# Тестуємо API
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/healthcheck" -UseBasicParsing
    if ($response.StatusCode -ne 200) {
        Write-Host "ERROR: API healthcheck failed with status code $($response.StatusCode). Response: $($response.Content)"
        docker logs $containerId
        docker rm -f $containerId
        exit 1
    }

    if (-not $response.Content.Contains("ok")) {
        Write-Host "ERROR: API healthcheck failed. Response: $($response.Content)"
        docker logs $containerId
        docker rm -f $containerId
        exit 1
    }
    Write-Host "API healthcheck passed. Response: $($response.Content)"
} catch {
    Write-Host "ERROR: Failed to connect to API. $_"
    docker logs $containerId
    docker rm -f $containerId
    exit 1
}

# Зупиняємо контейнер
docker rm -f $containerId

