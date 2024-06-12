# Use Node.js LTS version as base image
FROM node:lts-alpine as build

# Set environment variable to disable telemetry
ENV NEXT_TELEMETRY_DISABLED=1

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json to leverage Docker's layer caching
COPY package*.json ./

# Install dependencies
RUN npm install --only=production && npm cache clean --force

# Copy the rest of the application code
COPY . .

# Resolve TailwindCSS issue if applicable
# RUN npm install tailwindcss

# Build the application
RUN npm run build

# Production stage
FROM node:lts-alpine

# Set working directory
WORKDIR /app

# Copy built files from the previous stage
COPY --from=build /app ./

# Install serve globally to serve the application
RUN npm install -g serve --only=production && npm cache clean --force

# Expose port 3000
EXPOSE 3000

# Serve the built application
CMD ["serve", "-s", "build"]
