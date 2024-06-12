# Stage 1: Build the Vue.js application
FROM node:16.14-alpine AS build

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json for dependency installation
COPY package*.json ./

# Install all dependencies (including dev dependencies)
RUN npm ci

# Copy the rest of the application source code
COPY . .

# Build the application
RUN npm run build

# Stage 2: Prepare the production environment
FROM node:16.14-alpine AS production-env

# Set the working directory
WORKDIR /app

# Copy only the package.json and package-lock.json
COPY package*.json ./

# Install only production dependencies
RUN npm ci --only=production

# Stage 3: Serve the built application with Nginx
FROM nginx:1.21-alpine

# Copy the built files from the build stage
COPY --from=build /app/dist /usr/share/nginx/html

# Copy the production node_modules (if needed by the application, though typically not needed for purely static sites)
COPY --from=production-env /app/node_modules /app/node_modules

# Add a minimal Nginx configuration
# RUN echo 'server { \
#     listen 80; \
#     server_name localhost; \
#     location / { \
#         root /usr/share/nginx/html; \
#         try_files $uri $uri/ /index.html; \
#     } \
#     error_page 500 502 503 504 /50x.html; \
#     location = /50x.html { \
#         root /usr/share/nginx/html; \
#     } \
# }' > /etc/nginx/conf.d/default.conf

# Expose the port the app runs on
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
