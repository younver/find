FROM node:lts-alpine3.19
WORKDIR /app

RUN apk --no-cache add openjdk11-jre
RUN npm install -g firebase-tools

RUN firebase setup:emulators:database
RUN firebase setup:emulators:ui

COPY . .
CMD ["firebase", "emulators:start", "--project", "find"]