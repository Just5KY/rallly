FROM node:lts as build

RUN apt-get update
RUN apt-get install -y openssl libssl-dev libc6

WORKDIR /app

COPY package.json .
COPY yarn.lock .
COPY prisma/schema.prisma .

RUN yarn install --network-timeout 100000

RUN yarn --frozen-lockfile --no-cache --production

COPY . .

RUN yarn build

FROM node:lts

ENV PORT 3000
EXPOSE 3000

WORKDIR /usr/src/app

COPY --from=build /app .
COPY docker_start.sh .

ENTRYPOINT [ "./docker_start.sh" ]
