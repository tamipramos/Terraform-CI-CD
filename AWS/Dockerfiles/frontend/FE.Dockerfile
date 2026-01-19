FROM node:20 AS builder
WORKDIR /app

COPY ./vite-project/package*.json ./vite-project/
WORKDIR /app/vite-project
RUN npm ci

COPY ./vite-project/ .
RUN npm run build


FROM nginx:alpine
RUN rm /etc/nginx/conf.d/default.conf

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/vite-project/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
