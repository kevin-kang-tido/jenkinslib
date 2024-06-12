# Stage 1: Build the Angular application
FROM node:18-alpine AS build

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install --silent

# Copy the rest of the application code
COPY . .

# Build the Angular application
RUN npm run build --prod

# Stage 2: Serve the application with NGINX
FROM nginx:stable-alpine

# Set the working directory
WORKDIR /usr/share/nginx/html

# Copy the built Angular files from the previous stage
ARG PROJECT_NAME
COPY --from=build /app/dist/${PROJECT_NAME}/browser .

# Optional: Copy custom NGINX configuration file
# COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]
