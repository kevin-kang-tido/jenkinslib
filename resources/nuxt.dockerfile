# Stage 1: Build the Nuxt.js application
FROM node:lts-alpine AS build-stage

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code to the working directory
COPY . .

# Build the Nuxt.js application for production
RUN npm run build

# Stage 2: Serve the built application with NGINX
FROM nginx:alpine AS production-stage

# Copy the built app from the previous stage to the NGINX directory
COPY --from=build-stage /app/.nuxt/dist/client /usr/share/nginx/html

# Expose port 80 to the outside world
EXPOSE 80

# Command to run the NGINX server
CMD ["nginx", "-g", "daemon off;"]
