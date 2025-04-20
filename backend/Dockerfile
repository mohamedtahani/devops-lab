# Use an official Node.js base image
FROM node:18

# Set the working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the app
COPY . .

# Expose the backend port
EXPOSE 5000

# Start the app
CMD ["node", "server.js"]
