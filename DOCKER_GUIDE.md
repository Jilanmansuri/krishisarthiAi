# 🐳 Docker and Docker Compose Guide

## Prerequisites

### Windows
1. Install [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop)
2. Enable WSL 2 backend (required for Docker Desktop)
3. Allocate at least 4GB RAM to Docker

### macOS
1. Install [Docker Desktop for macOS](https://www.docker.com/products/docker-desktop)
2. Allocate at least 4GB RAM to Docker

### Linux
```bash
# Ubuntu/Debian
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
```

---

## Quick Start

### 1. Setup Environment
```bash
# Copy example environment
cp .env.example .env

# Generate secure keys
./setup-env.sh  # Linux/macOS
# or
setup-env.bat   # Windows
```

### 2. Build Services
```bash
docker-compose build
```

### 3. Start Services
```bash
# Start in background
docker-compose up -d

# Or with logs visible
docker-compose up
```

### 4. Check Status
```bash
docker-compose ps

# View logs
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f mongodb
```

### 5. Access Application
- Frontend: http://localhost
- Backend API: http://localhost/api
- Health Check: http://localhost/health

---

## Service Management

### View Service Logs
```bash
# All services
docker-compose logs

# Specific service
docker-compose logs -f backend

# Last 100 lines
docker-compose logs --tail=100
```

### Execute Commands in Container
```bash
# Backend
docker-compose exec backend npm list

# Frontend
docker-compose exec frontend ls -la

# MongoDB
docker-compose exec mongodb mongosh
```

### Stop Services
```bash
# Stop running services
docker-compose stop

# Remove containers
docker-compose down

# Remove everything including volumes
docker-compose down -v
```

### Restart Services
```bash
# Restart all
docker-compose restart

# Restart specific service
docker-compose restart backend
```

---

## Data Persistence

### MongoDB Data Directory
- Volume: `mongodb_data`
- Location: Docker volume storage
- Backup:
```bash
# Backup MongoDB
docker-compose exec mongodb mongodump --out /data/backup

# Extract from container
docker cp krishisarthi_mongodb:/data/backup ./mongo_backup
```

### Restore Data
```bash
# Restore MongoDB
docker-compose exec mongodb mongorestore /data/backup
```

---

## Performance Tuning

### Memory & CPU
Edit `docker-compose.yml`:
```yaml
services:
  backend:
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 512M
        reservations:
          cpus: '0.25'
          memory: 256M
```

### Database Optimization
```bash
# Create indexes
docker-compose exec mongodb mongosh < create-indexes.js

# Check performance
docker-compose exec mongodb mongosh --eval "db.collection.aggregate([{$indexStats:{}}])"
```

---

## Troubleshooting

### Container Won't Start
```bash
# Check logs
docker-compose logs backend

# Verify environment
docker-compose config

# Rebuild
docker-compose build --no-cache backend
docker-compose up -d backend
```

### Port Already in Use
```bash
# Find process using port
netstat -lntp | grep 5000

# Kill process
kill -9 <PID>

# Or use different port
PORT=8000 docker-compose up
```

### Memory Issues
```bash
# Check Docker resources
docker stats

# Allocate more memory to Docker Desktop
# Settings > Resources > Memory = 4GB+
```

### Network Issues
```bash
# Test connectivity
docker-compose exec backend curl http://mongodb:27017

# Inspect network
docker network inspect krishisarthi_network
```

---

## Environment Variables

Edit `.env`:
```bash
NODE_ENV=production          # environment
MONGODB_URI=mongodb://...   # database connection
JWT_SECRET=your-secret      # security key
GOOGLE_GENAI_API_KEY=...   # AI service
OPENAI_API_KEY=...         # AI service
GROK_API_KEY=...           # AI service
CORS_ORIGIN=http://...     # frontend URL
REACT_APP_API_URL=http://... # backend URL for frontend
```

---

## Production Deployment

### Before Going Live
1. [ ] Change all API keys from dummy values
2. [ ] Generate strong JWT_SECRET
3. [ ] Set NODE_ENV=production
4. [ ] Enable HTTPS/SSL
5. [ ] Setup database backups
6. [ ] Configure monitoring
7. [ ] Test disaster recovery

### Deploy with SSL
```bash
# Copy SSL certificates
mkdir -p ssl
cp /path/to/cert.pem ssl/cert.pem
cp /path/to/key.pem ssl/key.pem

# Update nginx.conf to enable HTTPS
# Uncomment the server block with SSL

docker-compose up -d
```

---

## Advanced Usage

### Build Specific Container
```bash
docker-compose build backend
docker-compose build frontend
docker-compose build mongodb
```

### Push to Registry
```bash
docker tag krishisarthi_backend:latest your-registry/backend:latest
docker push your-registry/backend:latest
```

### View Resource Usage
```bash
docker stats --no-stream
```

### Create Database Backup
```bash
docker-compose exec mongodb mongodump \
  --uri "mongodb://admin:password@mongodb:27017/krishiai?authSource=admin" \
  --out ./backup
```

### Scale Services
```bash
# Not directly in docker-compose, but options:
# 1. Create multiple containers manually
# 2. Use Kubernetes/Docker Swarm
# 3. Use container orchestration platform
```

---

## Health Checks

### Backend Health
```bash
curl http://localhost:5000/api/health
```

### Frontend Health
```bash
curl http://localhost/health
```

### Database Health
```bash
docker-compose exec mongodb mongosh --eval "db.adminCommand('ping')"
```

---

## Cleanup

### Remove Unused Images
```bash
docker image prune
```

### Remove All Krishna Sarthi Containers
```bash
docker-compose down -v
```

### Clean Docker System
```bash
docker system prune -a
```

---

## Support

For issues, check:
- `docker-compose logs`
- `.env` configuration
- Docker Desktop memory allocation
- Firewall rules
- Port availability

---

Last Updated: $(date)
