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

# Install only production dependencies
COPY package*.json ./
RUN npm install --only=production

# Copy necessary files from the build stage
COPY --from=builder /app/.nuxt ./.nuxt
COPY --from=builder /app/package.json ./
COPY --from=builder /app/nuxt.config.js ./nuxt.config.js
COPY --from=builder /app/static ./static

# Ensure optional files are handled appropriately
RUN if [ ! -f ./nuxt.config.js ]; then echo "nuxt.config.js not found, skipping..."; fi \
    && if [ ! -d ./static ]; then echo "static directory not found, skipping..."; fi

# Expose the port the app runs on
EXPOSE 3000

# Define the default command to run the application
CMD ["npm", "start"]
