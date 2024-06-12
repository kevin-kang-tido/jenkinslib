# Use Node.js LTS (Long Term Support) Alpine as the base image
FROM node:lts-alpine AS development

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code to the working directory
COPY . .

# Expose the port that the development server will run on
EXPOSE 3000

# Command to start the development server
CMD ["npm", "run", "dev"]
