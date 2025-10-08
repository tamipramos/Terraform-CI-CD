FROM node:20-slim

WORKDIR /

COPY AWS/Dockerfiles/frontend/package*.json /

COPY AWS/Dockerfiles/frontend/* /

RUN npm run build

RUN npm install -g serve

EXPOSE 3000

CMD ["serve", "-s", "build", "-l", "3000"]
