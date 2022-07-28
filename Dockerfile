FROM node:slim


RUN apt-get update
RUN apt-get install -y openssl libssl-dev libc6

RUN mkdir -p /usr/src/app
ENV PORT 3000
ARG DATABASE_URL
ENV DATABASE_URL $DATABASE_URL

WORKDIR /usr/src/app

COPY package.json /usr/src/app
COPY yarn.lock /usr/src/app
COPY prisma/schema.prisma /usr/src/app

RUN yarn

COPY . /usr/src/app

RUN yarn build

EXPOSE 3000

CMD [ "yarn", "start" ]