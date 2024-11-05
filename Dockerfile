# Use the official Node.js 14 image as a base
FROM node:14

# Create and set the working directory
WORKDIR /app

# Copy the package.json and install dependencies
COPY package.json ./
RUN npm install

# Copy the rest of the application code
COPY . .

# Expose port 3000
EXPOSE 3000

# Start the Node.js application
CMD ["npm", "start"]
