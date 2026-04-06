# KrishiSarthi Deployment Quick Reference

## 🚀 Deploy Locally (5 minutes)

```bash
# 1. Setup environment
cp .env.example .env
nano .env  # Add API keys

# 2. Start services
docker-compose up -d

# 3. Access
open http://localhost
```

**Services:**
- Frontend: http://localhost (React)
- Backend: http://localhost:5000/api
- MongoDB: localhost:27017
- Nginx: Reverse proxy (serves both)

---

## 🌐 Deploy to Heroku

```bash
heroku login
heroku create krishisarthi-prod

# Add MongoDB Atlas
heroku config:set MONGODB_URI=mongodb+srv://...

# Add API keys
heroku config:set GOOGLE_GENAI_API_KEY=...
heroku config:set OPENAI_API_KEY=...
heroku config:set GROK_API_KEY=...

# Deploy
git push heroku main
```

---

## AWS Deployment

### Option 1: ECS Fargate (Recommended)
- Elastic Container Service
- Pay only for running time
- Auto-scaling built-in

### Option 2: EC2 + Docker
- More control
- Better for high-traffic
- Manage your own infrastructure

### Option 3: Elastic Beanstalk
- AWS's PaaS
- Auto-deployment from Git
- Recommended for beginners

---

## DigitalOcean Deployment

### Option 1: App Platform (Easiest)
```bash
# 1. Connect GitHub repo
# 2. Auto-deploy on push
# 3. $5-12/month
```

### Option 2: Droplet + Docker
```bash
# SSH to droplet
ssh root@ip

# Install Docker
curl -fsSL https://get.docker.com | sh

# Clone and deploy
git clone https://github.com/...
cd krishisarthi
docker-compose up -d
```

---

## Production Pre-Checks

- [ ] All API keys set (not empty)
- [ ] NODE_ENV=production
- [ ] Strong JWT_SECRET (32+ chars)
- [ ] Update CORS_ORIGIN to your domain
- [ ] MongoDB backups enabled
- [ ] SSL/HTTPS configured
- [ ] Health check endpoints working
- [ ] Error logs being monitored

---

## Useful Commands

```bash
# View logs
docker-compose logs -f backend

# Restart services
docker-compose restart backend

# Stop all
docker-compose down

# Database backup
docker-compose exec mongodb mongodump --out /data/backup

# Health check
./health-check.sh
```

---

## File Structure

```
.
├── docker-compose.yml      # All services config
├── Dockerfile              # Main app container
├── backend/
│   ├── Dockerfile          # Node.js backend
│   ├── server.js           # Express app
│   ├── package.json        # Dependencies
│   └── config/
│       └── db.js           # MongoDB connection
├── frontend/
│   ├── Dockerfile          # React app
│   ├── package.json        # Dependencies
│   └── src/
│       └── App.jsx         # React component
├── nginx.conf              # Reverse proxy config
├── .env.example            # Environment template
├── DEPLOYMENT.md           # Full deployment guide
└── DOCKER_GUIDE.md         # Docker detailed guide
```

---

## Performance Tips

1. **Enable Compression** (already in nginx.conf)
2. **Use CDN** for static files (CloudFlare, CloudFront)
3. **Cache API responses** with Redis
4. **Optimize database** queries and indexes
5. **Monitor** with DataDog or New Relic

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Port 5000 in use | `docker-compose stop backend && docker-compose up -d backend` |
| MongoDB connection error | Check `.env` MONGODB_URI, wait 10s |
| CORS errors | Update CORS_ORIGIN in .env |
| Out of memory | Allocate more RAM to Docker |
| SSL certificate error | Renew cert: `certbot renew` |

---

## Contact & Support

- GitHub Issues: [krishisarthi/issues](https://github.com/krishisarthi/issues)
- Documentation: [DEPLOYMENT.md](./DEPLOYMENT.md)
- Email: support@krishisarthi.com

---

**Last Updated:** $(date)
**Version:** 1.0.0
