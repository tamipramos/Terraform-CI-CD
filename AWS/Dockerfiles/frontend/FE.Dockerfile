FROM node:20 AS builder

WORKDIR /app

COPY ./nginx.conf /app/nginx.conf

COPY ./vite-project/ ./vite-project


WORKDIR /app/vite-project

RUN npm install
RUN npm run build

FROM node:20

WORKDIR /app

RUN apt-get update && apt-get install -y nginx

COPY --from=builder /app/vite-project/dist ./dist
COPY --from=builder /app/nginx.conf /etc/nginx/sites-available/default
RUN ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
RUN nginx -t
RUN nginx -s reload

RUN npm install -g serve

EXPOSE 3000
EXPOSE 80

CMD ["serve", "-s", "dist", "-l", "3000"]
