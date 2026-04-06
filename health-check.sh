#!/bin/bash

# Production Health Check & Monitoring Script
# Usage: ./health-check.sh

set -e

echo "🏥 KrishiSarthi Health Check"
echo "======================================"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check Docker
echo "📦 Checking Docker..."
if command -v docker &> /dev/null; then
    echo -e "${GREEN}✓${NC} Docker installed: $(docker --version)"
else
    echo -e "${RED}✗${NC} Docker not found"
    exit 1
fi

# Check Docker Compose
echo "📦 Checking Docker Compose..."
if command -v docker-compose &> /dev/null; then
    echo -e "${GREEN}✓${NC} Docker Compose installed: $(docker-compose --version)"
else
    echo -e "${RED}✗${NC} Docker Compose not found"
    exit 1
fi

# Check containers running
echo ""
echo "🐳 Checking Containers..."
if docker-compose ps | grep -q "Up"; then
    echo -e "${GREEN}✓${NC} Containers are running:"
    docker-compose ps
else
    echo -e "${YELLOW}⚠${NC} Some containers are not running"
    docker-compose ps
fi

# Check MongoDB
echo ""
echo "🗄️  Checking MongoDB..."
MONGO_STATUS=$(docker-compose exec -T mongodb mongosh --eval "db.adminCommand('ping')" 2>/dev/null || echo "failed")
if echo "$MONGO_STATUS" | grep -q "ok"; then
    echo -e "${GREEN}✓${NC} MongoDB is healthy"
else
    echo -e "${RED}✗${NC} MongoDB connection failed"
fi

# Check Backend API
echo ""
echo "🔌 Checking Backend API..."
BACKEND_HEALTH=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:5000/api/health || echo "000")
if [ "$BACKEND_HEALTH" = "200" ]; then
    echo -e "${GREEN}✓${NC} Backend API is healthy (HTTP $BACKEND_HEALTH)"
else
    echo -e "${RED}✗${NC} Backend API is not responding (HTTP $BACKEND_HEALTH)"
fi

# Check Frontend
echo ""
echo "🌐 Checking Frontend..."
FRONTEND_HEALTH=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/ || echo "000")
if [ "$FRONTEND_HEALTH" = "200" ]; then
    echo -e "${GREEN}✓${NC} Frontend is healthy (HTTP $FRONTEND_HEALTH)"
else
    echo -e "${RED}✗${NC} Frontend is not responding (HTTP $FRONTEND_HEALTH)"
fi

# Check Nginx
echo ""
echo "🚀 Checking Nginx..."
NGINX_HEALTH=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/health || echo "000")
if [ "$NGINX_HEALTH" = "200" ]; then
    echo -e "${GREEN}✓${NC} Nginx is healthy (HTTP $NGINX_HEALTH)"
else
    echo -e "${RED}✗${NC} Nginx is not responding (HTTP $NGINX_HEALTH)"
fi

# Check Resources
echo ""
echo "💾 System Resources:"
docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}" | head -10

# Check Logs for Errors
echo ""
echo "📋 Recent Errors in Logs:"
echo "Backend:"
docker-compose logs backend 2>/dev/null | tail -5 | grep -i "error" || echo "  No recent errors"
echo ""
echo "Frontend:"
docker-compose logs frontend 2>/dev/null | tail -5 | grep -i "error" || echo "  No recent errors"

echo ""
echo "======================================"
echo "✅ Health check completed"
echo ""
