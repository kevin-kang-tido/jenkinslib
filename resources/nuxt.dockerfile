# Stage 1: Build Stage
FROM node:18-alpine AS builder

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json (or yarn.lock) to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application source code
COPY . .

# Build the application
RUN npm run build

# Stage 2: Production Stage
FROM node:18-alpine

# Set the working directory
WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install --only=production

# Copy only the necessary files from the build stage
COPY --from=builder /app/.nuxt ./.nuxt
COPY --from=builder /app/package.json ./

# Conditionally copy the nuxt.config.js file if it exists
COPY --from=builder /app/nuxt.config.js ./nuxt.config.js || true

# Conditionally copy the static directory if it exists
COPY --from=builder /app/static ./static || true

# Expose the port the app runs on
EXPOSE 3000

# Define the default command to run the application
CMD ["npm", "start"]
