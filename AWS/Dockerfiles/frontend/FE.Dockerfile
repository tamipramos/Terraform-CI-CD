FROM node:20 AS builder

WORKDIR /app

COPY ./vite-project/ ./vite-project

COPY ./nginx.conf ./nginx.conf

WORKDIR /app/vite-project

RUN npm install
RUN npm run build

FROM node:20

WORKDIR /app

COPY --from=builder /app/vite-project/dist ./dist
COPY --from=builder /app/nginx.conf /etc/nginx/sites-available/default

RUN npm install -g serve

EXPOSE 3000
EXPOSE 80

#CMD ["serve", "-s", "dist", "-l", "3000"]
