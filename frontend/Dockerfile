# Step 1: Build the React app
FROM node:18 AS build

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Step 2: Serve with NGINX
FROM nginx:alpine

# Copy the built React app to the NGINX html folder
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 3000 (for consistency — or 80)
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
