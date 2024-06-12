# Use Node.js LTS Alpine as the base image for both stages
FROM node:lts-alpine AS build-stage

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy the rest of the application code to the working directory
COPY . .

# Build the Nuxt.js application for production
RUN npm run build

# Use a smaller base image for the production stage
FROM node:lts-alpine AS production-stage

# Set the working directory in the container
WORKDIR /app

# Copy the built app from the build stage
COPY --from=build-stage /app .

# Expose port 3000 to the outside world
EXPOSE 3000

# Command to run the Nuxt.js server
CMD ["node", ".output/server/index.mjs"]
