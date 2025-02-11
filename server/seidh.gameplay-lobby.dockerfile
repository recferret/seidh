FROM node:lts-bullseye-slim as builder

WORKDIR /app

COPY .env ./
COPY tsconfig.json ./
COPY nest-cli.json ./
COPY package.json package-lock.json ./
COPY ./libs/ ./libs
COPY ./apps/ ./apps

RUN npm i

CMD npm run start:gameplay-lobby:prod