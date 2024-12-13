 FROM mcr.microsoft.com/windows/servercore:ltsc2022

   WORKDIR /usr/src/app

   COPY package*.json ./
   RUN npm install

   COPY . .

   EXPOSE 3000
   CMD [ "node", "server.js" ]
