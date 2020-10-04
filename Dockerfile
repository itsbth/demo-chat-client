FROM node:14 AS builder
RUN mkdir /build
WORKDIR /build
COPY package.json yarn.lock /build/
RUN yarn install --frozen-lockfile
COPY ./ /build/
RUN yarn build

FROM node:14-alpine
RUN mkdir /app
WORKDIR /app
COPY package.json yarn.lock /app/
RUN yarn install --frozen-lockfile --prod
COPY --from=builder /build/__sapper__/ /app/__sapper__/
COPY ./static/ /app/static/

CMD ["node", "./__sapper__/build/index.js"]
