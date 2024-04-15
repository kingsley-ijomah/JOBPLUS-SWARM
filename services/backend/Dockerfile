# Creating multi-stage build for production
FROM node:18-buster as build

# Update and install required packages
RUN apt-get update && apt-get install -y build-essential libvips-dev

# Set environment variables for the build stage
ENV NODE_ENV=production
ENV SHARP_IGNORE_GLOBAL_LIBVIPS=1

# Install project dependencies
WORKDIR /opt/
COPY package.json yarn.lock ./
RUN yarn install --production

# Build the application
WORKDIR /opt/app
COPY . .
RUN yarn build

# Creating final production image
FROM node:18-buster

# Install runtime dependencies
RUN apt-get update && apt-get install -y libvips-dev

# Set up the application directory
WORKDIR /opt/

# Copy node modules from build stage
COPY --from=build /opt/node_modules ./node_modules

# Set up and copy the application code from the build stage
WORKDIR /opt/app
COPY --from=build /opt/app ./

# Set production environment variable
ENV NODE_ENV=production

# Change ownership of the application files to the 'node' user
RUN chown -R node:node /opt/app

# Use 'node' user for better security
USER node

# Expose the application port
EXPOSE 1337

# Command to run the application
CMD ["yarn", "start"]
