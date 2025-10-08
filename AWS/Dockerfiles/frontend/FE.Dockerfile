FROM node:20 AS builder

WORKDIR /app

COPY ./vite-project/ ./vite-project

WORKDIR /app/vite-project

RUN npm install
RUN npm run build

FROM node:20

WORKDIR /app

COPY ./nginx.conf .

COPY --from=builder /app/vite-project/dist ./dist

RUN npm install -g serve

EXPOSE 3000
EXPOSE 80

CMD ["serve", "-s", "dist", "-l", "3000"]
