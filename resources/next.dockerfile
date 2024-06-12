# Stage 1: Build the Next.js application
FROM node:lts as build

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm ci --quiet --no-optional --unsafe-perm

# Copy the rest of the application code
COPY . .

# Build the Next.js application
RUN npm run build

# Stage 2: Production stage
FROM node:lts-slim

# Set the working directory in the container
WORKDIR /app

# Copy the built Next.js application from the previous stage to the current stage
COPY --from=build /app ./

# Install serve globally for serving the Next.js application
RUN npm install -g serve && npm cache clean --force

# Expose the port Next.js runs on
EXPOSE 3000

# Start the Next.js application
CMD ["serve", "-s", ".", "-p", "3000"]
