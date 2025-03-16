FROM node:20-slim

WORKDIR /app

# Copy package files first for better caching
COPY . .

# Install dependencies (including devDependencies for development)
RUN npm install

RUN npm run build
# Expose port 3000


# Run development server with host binding
CMD ["npm", "run", "dev"]