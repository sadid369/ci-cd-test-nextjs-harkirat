# Stage 1: Build the application
FROM node:20-slim AS builder
WORKDIR /app

# Copy package files first for better caching
COPY package*.json ./
COPY prisma ./prisma/

# Install production dependencies only (no devDependencies)
RUN npm ci --omit=dev

# Copy all source files
COPY . .

# Build the application
RUN npm run build

# Stage 2: Production image
FROM node:20-slim
WORKDIR /app

# Copy necessary files from builder stage
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
# COPY --from=builder /app/prisma ./prisma

# Install production dependencies again for security (optional)
RUN npm ci --omit=dev

# Generate Prisma client
# RUN npx prisma generate

# Expose port 3000
EXPOSE 3000

# Start the production server
CMD ["npm", "start"]