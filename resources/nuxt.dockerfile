# Stage 1: Build Stage
FROM node:18-alpine AS builder

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json (or yarn.lock) to the working directory
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy the rest of the application source code
COPY . .

# Build the application
RUN npm run build

# Stage 2: Production Stage with Nginx
FROM nginx:alpine

# Copy the build output to Nginx's html directory
COPY --from=builder /app/.nuxt /usr/share/nginx/html/.nuxt
# COPY --from=builder /app/static /usr/share/nginx/html/static
COPY --from=builder /app/nuxt.config.js /usr/share/nginx/html/nuxt.config.js
COPY --from=builder /app/package.json /usr/share/nginx/html/package.json

# Copy Nginx configuration file
COPY nginx.conf /etc/nginx/nginx.conf

# Expose the port Nginx will run on
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
