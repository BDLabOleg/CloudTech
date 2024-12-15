# Запускаємо контейнер
$containerId = docker run -d -p 3000:3000 olegmukhin/expense-tracker:latest

# Затримка для запуску сервісу
Start-Sleep -Seconds 10  # Збільшуємо час очікування

# Тестуємо API
docker logs $containerId

# Зупиняємо контейнер
docker rm -f $containerId

