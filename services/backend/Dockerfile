# Creating multi-stage build for production
FROM node:18-buster as build

RUN apt-get update && apt-get install -y build-essential libvips-dev

ENV NODE_ENV=production
ENV SHARP_IGNORE_GLOBAL_LIBVIPS=1

WORKDIR /opt/
COPY package.json yarn.lock ./
RUN yarn install --production

COPY . .
RUN yarn build

# Creating final production image
FROM node:18-buster
RUN apt-get update && apt-get install -y libvips-dev
WORKDIR /opt/
COPY --from=build /opt/node_modules ./node_modules
WORKDIR /opt/app
COPY --from=build /opt/app ./
ENV NODE_ENV=production
RUN chown -R node:node /opt/app
USER node
EXPOSE 1337
CMD ["yarn", "start"]
