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
RUN rm -r /etc/nginx/sites-available/default
COPY --from=builder /app/nginx.conf /etc/nginx/sites-available/default
RUN nginx -t

RUN npm install -g serve

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
