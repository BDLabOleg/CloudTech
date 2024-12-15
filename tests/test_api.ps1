# Запускаємо контейнер
$containerId = docker run -d -p 3000:3000 olegmukhin/expense-tracker:latest

# Затримка для запуску сервісу
Start-Sleep -Seconds 10  # Збільшуємо час очікування

$response = Invoke-WebRequest -Uri "http://localhost:3000/api/healthcheck" -UseBasicParsing

# Тестуємо API
docker logs $containerId

# Зупиняємо контейнер
docker rm -f $containerId

