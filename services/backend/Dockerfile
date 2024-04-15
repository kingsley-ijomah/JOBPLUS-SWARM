# Creating multi-stage build for production
FROM node:18-buster as build

# Update system and install dependencies
RUN apt-get update && apt-get install -y build-essential libvips-dev

# Set environment variables
ENV NODE_ENV=production
ENV SHARP_IGNORE_GLOBAL_LIBVIPS=1

# Set up working directory
WORKDIR /opt/

# Install project dependencies
COPY package.json yarn.lock ./
RUN yarn install

# Set PATH to ensure local node modules are executable
ENV PATH /opt/node_modules/.bin:$PATH

# Copy project files
WORKDIR /opt/app
COPY . .

# Build the project using Strapi
RUN npx strapi build

# Creating final production image
FROM node:18-buster

# Install runtime dependencies
RUN apt-get update && apt-get install -y libvips-dev

# Set up application directory
WORKDIR /opt/

# Copy node modules from build stage
COPY --from=build /opt/node_modules ./node_modules

# Set up and copy the built application from the build stage
WORKDIR /opt/app
COPY --from=build /opt/app ./

# Set production environment variable
ENV NODE_ENV=production

# Change ownership of the application files to the 'node' user for security
RUN chown -R node:node /opt/app

# Use 'node' user to run the application
USER node

# Expose the application port
EXPOSE 1337

# Command to run the application
CMD ["yarn", "start"]
