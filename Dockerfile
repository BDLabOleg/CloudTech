# Использование Ubuntu как базового образа
FROM --platform=linux/amd64 ubuntu:20.04 

# Установка необходимых зависимостей и Node.js
RUN apt-get update && apt-get install -y \
    curl \
    gnupg2 \
    lsb-release \
    ca-certificates \
    && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean

# Установка рабочего каталога
WORKDIR /usr/src/app

# Копирование файлов package.json и package-lock.json
COPY app/package*.json ./

# Установка зависимостей
RUN npm install

# Копирование всех остальных файлов проекта
COPY . .

# Открытие порта 3000 (если ваше приложение работает на этом порту)
EXPOSE 3000

# Запуск приложения
CMD ["npm", "start"]
