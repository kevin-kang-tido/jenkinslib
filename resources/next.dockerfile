# Build stage
FROM node:lts-alpine as build

WORKDIR /app

# Copy package.json and package-lock.json first to leverage Docker's layer caching
COPY package*.json ./

# Install dependencies
RUN npm install --only=production && npm cache clean --force

# Copy the rest of the application code
COPY . .

# Build the application
RUN npm run build

# Production stage
FROM node:lts-alpine

WORKDIR /app

# Copy built files from the previous stage
COPY --from=build /app ./

# Install serve globally
RUN npm install -g serve --only=production && npm cache clean --force

EXPOSE 3000

# Serve the built application
CMD ["serve", "-s", "build"]
