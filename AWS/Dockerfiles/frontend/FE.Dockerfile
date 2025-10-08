FROM node:20-slim

WORKDIR /app

COPY AWS/Dockerfiles/frontend/package*.json ./

RUN npm install

COPY AWS/Dockerfiles/frontend/* .

RUN npm run build

RUN npm install -g serve

EXPOSE 3000

CMD ["serve", "-s", "build", "-l", "3000"]
