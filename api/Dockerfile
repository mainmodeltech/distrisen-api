FROM node:20-alpine

WORKDIR /app

# Dépendances en premier (cache Docker)
COPY package*.json ./
RUN npm ci --omit=dev

# Code source + données
COPY . .

EXPOSE 3000

CMD ["node", "server.js"]
