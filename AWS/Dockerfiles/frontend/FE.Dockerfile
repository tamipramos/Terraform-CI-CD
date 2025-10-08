FROM node:20

WORKDIR /app

COPY . .

RUN npm install

WORKDIR /app/vite-project

RUN npm install

RUN npm install -g serve

RUN npm run build

EXPOSE 3000

CMD ["serve", "-s", "dist", "-l", "3000"]
