FROM node:lts-bullseye-slim as builder

WORKDIR /app

COPY tsconfig.json ./
COPY nest-cli.json ./
COPY package.json ./
COPY index.hbs ./
COPY cert.pem ./
COPY key.pem ./

COPY ./libs/ ./libs
COPY ./apps/ ./apps

RUN npm i

CMD npm run start:client:prod