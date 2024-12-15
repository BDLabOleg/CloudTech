# Использование Windows Server Core как базового образа
FROM mcr.microsoft.com/windows/servercore:ltsc2022

# Установка Chocolatey (только один раз)
RUN powershell -Command \
    Set-ExecutionPolicy Bypass -Scope Process -Force; \
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12; \
    Invoke-WebRequest https://chocolatey.org/install.ps1 -OutFile install.ps1; \
    powershell -NoProfile -ExecutionPolicy Bypass -File install.ps1; \
    Remove-Item -Force install.ps1

# Установка Node.js через Chocolatey
RUN choco install nodejs-lts -y

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
# CMD ["npm", "start"]
CMD ["node", "server.js"]

