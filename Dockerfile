# Multi-stage build for Node.js backend and React frontend

# Stage 1: Build React Frontend
FROM node:18-alpine AS frontend-builder

WORKDIR /app/frontend

COPY frontend/package*.json ./
RUN npm ci

COPY frontend/ .
RUN npm run build

# Stage 2: Build Backend
FROM node:18-alpine AS backend-builder

WORKDIR /app/backend

COPY backend/package*.json ./
RUN npm ci --only=production

# Stage 3: Final Image with Nginx serving Frontend + Node Backend
FROM node:18-alpine

# Install Nginx
RUN apk add --no-cache nginx

WORKDIR /app

# Copy backend from builder
COPY --from=backend-builder /app/backend/node_modules ./backend/node_modules
COPY backend/ ./backend

# Copy frontend build from builder
COPY --from=frontend-builder /app/frontend/build ./frontend/build

# Copy Nginx config
COPY nginx.conf /etc/nginx/nginx.conf

# Copy start script
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Expose ports
EXPOSE 80 5000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:5000/api/health', (r) => {if (r.statusCode !== 200) throw new Error(r.statusCode)});"

# Start both Nginx (frontend) and Node (backend)
CMD ["/app/start.sh"]
