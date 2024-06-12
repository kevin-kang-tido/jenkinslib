# Stage 1: Base image
FROM node:lts-alpine AS base

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Stage 2: Development stage
FROM base AS development

# Expose the port that the development server will run on
EXPOSE 3000

# Command to start the development server
CMD ["npm", "run", "dev"]

# Stage 3: Build stage
FROM base AS build

# Build the Nuxt.js application for production
RUN npm run build

# Stage 4: Production stage
FROM nginx:alpine AS production

# Copy built files from the previous stage to NGINX directory
COPY --from=build /app/dist /usr/share/nginx/html

# Expose port 80 to the outside world
EXPOSE 80

# Command to start NGINX
CMD ["nginx", "-g", "daemon off;"]
