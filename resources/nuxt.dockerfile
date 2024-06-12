# Use a lightweight Node.js image as the base
FROM node:lts-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json (if using)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application files (excluding node_modules)
COPY . . .npm

# Cache node_modules to speed up future builds
RUN npm cache ci --force

# Switch to a smaller runtime image for the final container
FROM node:lts-alpine AS runner

# Set working directory
WORKDIR /app

# Copy only the production-ready files from the build stage
COPY --from=builder /app/.nuxt/dist/process.env ./
COPY --from=builder /app/.nuxt/dist/client /app

# Expose the default Nuxt port (3000)
EXPOSE 3000

# Start the Nuxt server in production mode
CMD [ "npm", "start" ]
