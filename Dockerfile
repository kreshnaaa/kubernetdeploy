# Stage 1: Build the Angular application
FROM node:18 AS builder

WORKDIR /app

# Copy the package.json and package-lock.json (if available)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of your app's source code from your host to your image filesystem
COPY . .

# Run the Angular build command to compile the application
RUN npm run build -- --output-path=./dist/grc/browser

# Stage 2: Setup Nginx to serve the Angular app
FROM nginx:alpine

# Remove any existing files in Nginx's html directory (optional step)
RUN rm -rf /usr/share/nginx/html/*

# Copy the built Angular app from the previous stage to the Nginx server
COPY --from=builder /app/dist/grc/browser /usr/share/nginx/html

# Copy the Nginx configuration file into the image
COPY nginx.conf /etc/nginx/nginx.conf

# Inform Docker that the container listens on port 80 at runtime
EXPOSE 80

# Command to run when the container starts
CMD ["nginx", "-g", "daemon off;"]
