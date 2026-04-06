# 🚀 DEPLOYMENT GUIDE

This guide helps you deploy the KrishiSarthi Agricultural Application to production using Docker.

## Table of Contents
- [Local Docker Deployment](#local-docker-deployment)
- [Heroku Deployment](#heroku-deployment)
- [AWS Deployment](#aws-deployment)
- [DigitalOcean Deployment](#digitalocean-deployment)
- [Production Checklist](#production-checklist)

---

## Local Docker Deployment

### Prerequisites
- Docker and Docker Compose installed
- Git
- 4GB+ RAM available

### Steps

1. **Clone and Setup**
```bash
git clone https://github.com/yourusername/krishisarthi.git
cd krishisarthi
```

2. **Configure Environment**
```bash
# Copy the example environment file
cp .env.example .env

# Edit with your configuration
nano .env
# Update:
# - GOOGLE_GENAI_API_KEY
# - OPENAI_API_KEY
# - GROK_API_KEY
# - JWT_SECRET (generate a strong random key)
# - MONGO_ROOT_PASSWORD
```

3. **Build and Run**
```bash
# Build images
docker-compose build

# Start services
docker-compose up -d

# Check logs
docker-compose logs -f backend

# Check if services are healthy
docker-compose ps
```

4. **Access Application**
- Frontend: `http://localhost`
- Backend API: `http://localhost/api`
- MongoDB: `mongodb://admin:password@localhost:27017`

5. **Stop Services**
```bash
docker-compose down
```

---

## Heroku Deployment

### Prerequisites
- Heroku Account with attached payment method
- Heroku CLI installed
- MongoDB Atlas account (free tier available)

### Steps

1. **Create Heroku App**
```bash
heroku login
heroku create krishisarthi-app
```

2. **Add MongoDB Atlas**
- Create cluster at https://www.mongodb.com/cloud/atlas
- Get connection string
```bash
heroku config:set MONGODB_URI="mongodb+srv://user:password@cluster.mongodb.net/krishiai"
```

3. **Set Environment Variables**
```bash
heroku config:set NODE_ENV=production
heroku config:set JWT_SECRET=$(openssl rand -base64 32)
heroku config:set GOOGLE_GENAI_API_KEY=your-key
heroku config:set OPENAI_API_KEY=your-key
heroku config:set GROK_API_KEY=your-key
```

4. **Deploy**
```bash
git push heroku main
```

5. **View Logs**
```bash
heroku logs --tail
```

---

## AWS Deployment (ECS + RDS)

### Prerequisites
- AWS Account with active billing
- AWS CLI configured
- ECR registry created

### Architecture
- **Frontend**: CloudFront + S3
- **Backend**: ECS Fargate
- **Database**: RDS MongoDB (or DocumentDB)
- **Load Balancer**: Application Load Balancer

### Steps

1. **Create RDS Database**
```bash
# Use AWS Console or:
aws rds create-db-instance \
  --db-instance-identifier krishisarthi-db \
  --db-instance-class db.t3.micro \
  --engine mongo \
  --master-username admin \
  --master-user-password your-password
```

2. **Push Docker Image to ECR**
```bash
# Create repository
aws ecr create-repository --repository-name krishisarthi-backend

# Build and push
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 123456789.dkr.ecr.us-east-1.amazonaws.com
docker build -t krishisarthi-backend:latest backend/
docker tag krishisarthi-backend:latest 123456789.dkr.ecr.us-east-1.amazonaws.com/krishisarthi-backend:latest
docker push 123456789.dkr.ecr.us-east-1.amazonaws.com/krishisarthi-backend:latest
```

3. **Deploy Frontend to S3 + CloudFront**
```bash
# Build frontend
cd frontend && npm run build

# Upload to S3
aws s3 sync build/ s3://krishisarthi-frontend/

# Create CloudFront distribution (via Console)
```

4. **Create ECS Task Definition**
- Use ECR image
- Set environment variables
- Allocate 512 MB memory, 256 CPU units
- Set log group to CloudWatch

5. **Create ECS Service**
- Use ALB for load balancing
- Auto-scale based on CPU/Memory
- Set desired count to 2+

6. **Update DNS**
- Point domain to CloudFront (frontend) and ALB (backend)

---

## DigitalOcean Deployment

### Prerequisites
- DigitalOcean Account
- SSH Key configured
- Domain name

### Using App Platform (Easiest)

1. **Connect Repository**
- Go to App Platform
- New App
- Connect GitHub repo

2. **Configure App**
```yaml
name: krishisarthi
services:
  - name: backend
    dockerfile_path: backend/Dockerfile
    source_dir: backend
    envs:
      - key: NODE_ENV
        value: production
      - key: MONGODB_URI
        value: ${mongo.connection_string}
    http_port: 5000
  
  - name: frontend
    dockerfile_path: frontend/Dockerfile
    source_dir: frontend
```

3. **Deploy**
- Click "Deploy"
- Monitor logs

### Using Droplets + Docker

1. **Create Droplet** (Ubuntu 22.04 LTS, 2GB+)
```bash
# SSH into droplet
ssh root@your_droplet_ip

# Update system
apt update && apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/download/v2.15.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```

2. **Clone and Deploy**
```bash
cd /opt
git clone https://github.com/yourusername/krishisarthi.git
cd krishisarthi

# Create .env
nano .env

# Start services
docker-compose up -d

# Setup Nginx reverse proxy (optional)
# Configure SSL certificate with Let's Encrypt
```

---

## Production Checklist

### Security
- [ ] Change all default passwords
- [ ] Generate strong JWT_SECRET
- [ ] Set NODE_ENV=production
- [ ] Enable HTTPS/SSL
- [ ] Setup firewall rules
- [ ] Configure CORS properly
- [ ] Enable rate limiting
- [ ] Setup API authentication tokens

### Performance
- [ ] Enable gzip compression
- [ ] Setup CDN for static files
- [ ] Enable Redis caching (optional)
- [ ] Setup database backups
- [ ] Configure auto-scaling
- [ ] Monitor server resources

### Monitoring & Logging
- [ ] Setup centralized logging (ELK Stack or AWS CloudWatch)
- [ ] Setup monitoring/alerting (Datadog, New Relic)
- [ ] Enable application error tracking (Sentry)
- [ ] Setup health check endpoints
- [ ] Configure database backups

### Database
- [ ] Enable MongoDB authentication
- [ ] Setup automatic backups
- [ ] Configure replication
- [ ] Monitor database performance
- [ ] Set resource limits

### Domain & SSL
- [ ] Purchase and configure domain
- [ ] Setup SSL certificate (Let's Encrypt)
- [ ] Configure DNS records
- [ ] Setup email alerts for certificate renewal

### Backup & Disaster Recovery
- [ ] Setup automated backups
- [ ] Test restore process
- [ ] Document recovery procedures
- [ ] Setup disaster recovery plan

---

## Environment Variables Reference

### Backend Required
```
NODE_ENV=production
MONGODB_URI=mongodb+srv://...
JWT_SECRET=strong-random-key
PORT=5000
```

### API Keys
```
GOOGLE_GENAI_API_KEY=...
OPENAI_API_KEY=...
GROK_API_KEY=...
```

### Frontend
```
REACT_APP_API_URL=https://api.yourdomain.com
```

---

## Common Issues & Solutions

### MongoDB Connection Error
```
Error: connect ECONNREFUSED 127.0.0.1:27017
Solution: Ensure MongoDB container is running and healthy
docker-compose logs mongodb
```

### Port Already in Use
```
docker-compose down
# or kill process using port 5000/3000
```

### CORS Issues
```
Update CORS_ORIGIN=https://yourdomain.com
Restart backend
```

### Out of Memory
```
Increase Docker memory allocation
Reduce worker processes
Enable compression
```

---

## Support & Documentation

- Issue Tracker: GitHub Issues
- Documentation: See README.md
- API Docs: /api/docs (if available)
- Contact: support@example.com
