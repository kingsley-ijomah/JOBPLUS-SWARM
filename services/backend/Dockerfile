# Creating multi-stage build for production
FROM node:18-buster as build

# Update and install dependencies for building native addons
RUN apk update && apk add --no-cache \
    build-base \
    gcc \
    autoconf \
    automake \
    zlib-dev \
    libpng-dev \
    vips-dev \
    git \
    python3 \
    make \
    g++

# Set environment variables
ENV NODE_ENV=production
ENV SHARP_IGNORE_GLOBAL_LIBVIPS=1

# Prepare the working directory
WORKDIR /opt/
COPY package.json yarn.lock ./

# Install dependencies
RUN yarn install --production

# Copy the project files
COPY . .

# Build the application
RUN yarn build

# Creating final production image
FROM node:18
RUN apk add --no-cache vips-dev
WORKDIR /opt/
COPY --from=build /opt/node_modules ./node_modules
WORKDIR /opt/app
COPY --from=build /opt/app ./
ENV NODE_ENV=production
RUN chown -R node:node /opt/app
USER node
EXPOSE 1337
CMD ["yarn", "start"]