# Stage 1: Build the Next.js application
FROM node:alpine AS build

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package.json package-lock.json ./

# Install dependencies
RUN npm ci --quiet

# Copy the rest of the application code
COPY . .

# Build the Next.js application
RUN npm run build

# Stage 2: Use Nginx to serve the built Next.js application
FROM nginx:alpine

# Copy the built Next.js application from the previous stage to Nginx directory
COPY --from=build /app/.next /usr/share/nginx/html

# Expose the port Nginx listens on
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
