# Production Environment Setup Guide

Complete guide to setting up production environment variables for KrishiSarthi deployment.

## Obtaining API Keys

### 1. Google Generative AI (Gemini)
- Website: https://ai.google.dev
- Steps:
  1. Sign in with Google account
  2. Click "Get API Key"
  3. Create new project
  4. Copy the API key
  5. Add to `.env`: `GOOGLE_GENAI_API_KEY=your-key`
- Pricing: Free tier + paid plan

### 2. OpenAI API
- Website: https://platform.openai.com/account/api-keys
- Steps:
  1. Create ChatGPT account
  2. Go to API section
  3. Create API key
  4. Set billing method
  5. Add to `.env`: `OPENAI_API_KEY=your-key`
- Pricing: Pay-as-you-go ($0.002-0.03 per 1K tokens)

### 3. Grok API (XAI)
- Website: https://api.x.ai
- Steps:
  1. Sign up for xAI account
  2. Request API access
  3. Create API key
  4. Add to `.env`: `GROK_API_KEY=your-key`
- Pricing: Contact for pricing

### 4. MongoDB Connection

#### Option A: MongoDB Atlas (Cloud - Recommended)
1. Go to: https://www.mongodb.com/cloud/atlas
2. Create free cluster
3. Create database user
4. Get connection string: `mongodb+srv://user:password@cluster.mongodb.net/krishiai`
5. Add to `.env`: `MONGODB_URI=your-connection-string`

#### Option B: Self-hosted MongoDB
1. Install MongoDB locally or on server
2. Create database: `krishiai`
3. Create user with strong password
4. Connection string: `mongodb://user:password@host:27017/krishiai`

### 5. Domain & SSL Certificate

#### Free SSL with Let's Encrypt
```bash
# Install Certbot
sudo apt-get install certbot python3-certbot-nginx

# Generate certificate
sudo certbot certonly --nginx -d yourdomain.com

# Certificate location
/etc/letsencrypt/live/yourdomain.com/

# Auto-renewal
sudo systemctl enable certbot.timer
```

#### Steps to Setup Domain
1. Register domain (GoDaddy, Namecheap, etc.)
2. Point DNS to your server IP
3. Install SSL certificate
4. Update CORS_ORIGIN in .env

---

## Full Production .env Template

```env
# ===========================
# ENVIRONMENT
# ===========================
NODE_ENV=production
BACKEND_PORT=5000
FRONTEND_PORT=3000

# ===========================
# DATABASE
# ===========================
# MongoDB Atlas example:
MONGODB_URI=mongodb+srv://username:password@cluster0.mongodb.net/krishiai?retryWrites=true&w=majority

# Or self-hosted:
# MONGODB_URI=mongodb://username:strong-password@mongo.yourdomain.com:27017/krishiai

MONGO_ROOT_USER=admin
MONGO_ROOT_PASSWORD=your-super-strong-password-here
MONGO_PORT=27017

# ===========================
# SECURITY
# ===========================
# Generate with: openssl rand -base64 32
JWT_SECRET=your-32-character-random-secret-key-here

# ===========================
# CORS & DOMAIN
# ===========================
CORS_ORIGIN=https://yourdomain.com
REACT_APP_API_URL=https://api.yourdomain.com

# ===========================
# AI SERVICE KEYS
# ===========================
# Google Generative AI
GOOGLE_GENAI_API_KEY=AIzaSy...

# OpenAI (GPT models)
OPENAI_API_KEY=sk-...

# Grok (XAI)
GROK_API_KEY=xai-...

# ===========================
# NGINX CONFIGURATION
# ===========================
DOMAIN_NAME=yourdomain.com
ALLOWED_HOSTS=yourdomain.com,api.yourdomain.com,www.yourdomain.com

# ===========================
# LOGGING & MONITORING
# ===========================
LOG_LEVEL=info

# Sentry (optional error tracking)
SENTRY_DSN=https://...

# DataDog (optional monitoring)
DATADOG_API_KEY=

# ===========================
# THIRD-PARTY SERVICES
# ===========================
# Weather API (optional)
WEATHER_API_KEY=your-weather-api-key

# Email notifications (optional)
EMAIL_SERVICE=gmail
EMAIL_USER=your-email@gmail.com
EMAIL_PASSWORD=your-app-password

# SMS service (optional)
SMS_PROVIDER=twilio
SMS_API_KEY=
SMS_ACCOUNT_SID=

# ===========================
# DEPLOYMENT
# ===========================
# For Docker deployments
COMPOSE_PROJECT_NAME=krishisarthi-prod

# For load balancing
BACKEND_REPLICAS=3
FRONTEND_REPLICAS=2

# For auto-scaling thresholds
CPU_THRESHOLD=70
MEMORY_THRESHOLD=80
```

---

## Environment Setup by Platform

### ✅ Heroku

```bash
# Set environment variables
heroku config:set NODE_ENV=production
heroku config:set MONGODB_URI=mongodb+srv://...
heroku config:set JWT_SECRET=$(openssl rand -base64 32)
heroku config:set GOOGLE_GENAI_API_KEY=AIzaSy...
heroku config:set OPENAI_API_KEY=sk-...
heroku config:set CORS_ORIGIN=https://yourdomain.com

# Verify
heroku config
```

### ✅ AWS EC2 / DigitalOcean Droplet

```bash
# SSH into server
ssh user@server-ip

# Create .env file
nano /opt/krishisarthi/.env

# Paste the production template above
# Edit values accordingly

# Set file permissions
chmod 600 /opt/krishisarthi/.env

# Start Docker Compose
cd /opt/krishisarthi
docker-compose up -d
```

### ✅ Docker Compose (Local/VPS)

```bash
# Create .env from template
cp .env.example .env

# Edit with production values
nano .env

# Verify environment
docker-compose config

# Deploy
docker-compose build
docker-compose up -d

# Verify
docker-compose ps
curl http://localhost/api/health
```

### ✅ Kubernetes

```bash
# Create namespace
kubectl create namespace krishisarthi

# Create secrets
kubectl create secret generic app-secrets \
  --from-literal=MONGODB_URI=mongodb+srv://... \
  --from-literal=JWT_SECRET=... \
  --from-literal=GOOGLE_GENAI_API_KEY=... \
  -n krishisarthi

# Apply manifest
kubectl apply -f k8s-deployment.yml

# Verify
kubectl get all -n krishisarthi
```

---

## Security Hardening Checklist

### Secrets Management ✅
- [ ] Never commit `.env` to git
- [ ] Use `.env.example` as template
- [ ] Rotate API keys every 90 days
- [ ] Use strong JWT_SECRET (32+ chars)
- [ ] Store secrets in proper vault (AWS Secrets Manager, Vault)

### Access Control ✅
- [ ] Enable HTTPS/SSL everywhere
- [ ] Use strong database passwords
- [ ] Enable MongoDB authentication
- [ ] Setup VPN/bastion for database access
- [ ] Limit SSH access by IP

### Monitoring & Alerts ✅
- [ ] Setup error tracking (Sentry)
- [ ] Enable CloudWatch/DataDog monitoring
- [ ] Configure alerts for high CPU/memory
- [ ] Monitor for security breaches
- [ ] Track failed login attempts

### Network Security ✅
- [ ] Setup firewall rules
- [ ] Use WAF (Web Application Firewall)
- [ ] Enable rate limiting
- [ ] CORS configured correctly
- [ ] DDoS protection enabled

---

## Validation

### Test Environment Variables

```bash
# Docker Compose
docker-compose config | grep -A5 "environment:"

# Node.js
node -e "console.log(process.env.JWT_SECRET.length > 0 ? 'OK' : 'MISSING')"

# API Test
curl http://localhost:5000/api/health

# Database Test
docker-compose exec backend mongosh --eval "db.adminCommand('ping')"
```

### Pre-Deployment Tests

```bash
# Check all required variables
./validate-env.sh

# Test API endpoints
./test-api.sh

# Run health checks
./health-check.sh

# Check logs for errors
docker-compose logs --tail=50
```

---

## Common Errors & Solutions

### Error: "MONGODB_URI is not set"
```bash
# Solution: Add to .env
MONGODB_URI=mongodb+srv://user:password@cluster.mongodb.net/krishiai
```

### Error: "API key invalid" (Google/OpenAI)
```bash
# Solution: Verify key in API dashboard
# Regenerate if necessary
# Check expiration date
```

### Error: "CORS error in browser"
```bash
# Solution: Update CORS_ORIGIN
CORS_ORIGIN=https://yourdomain.com
# Restart backend
docker-compose restart backend
```

### Error: "Connection timeout"
```bash
# Solution: Check firewall rules
# Verify database is accessible
# Check MONGODB_URI format
```

---

## Environment Variables Change Log

When you update environment variables:

1. Document the change
2. Test in staging first
3. Deploy to production
4. Monitor logs for errors
5. Keep backup of old values

Example log:
```
2024-01-15 - Updated MONGODB_URI to new cluster
2024-01-15 - Added SENTRY_DSN for error tracking
2024-01-10 - Rotated JWT_SECRET (annual rotation)
```

---

## Backup & Recovery

### Backup Environment
```bash
# Export current configuration (without secrets)
docker-compose config > config-backup.yml

# Backup .env (KEEP SECURE!)
gpg --encrypt .env
```

### Recovery
```bash
# Restore from backup
cp .env.backup .env
docker-compose up -d
```

---

## Emergency: Disable API Key

If API key is compromised:

```bash
# Immediately disable old key in service dashboard
# Generate new key
# Update .env:
# GOOGLE_GENAI_API_KEY=new-key

# Restart services
docker-compose restart backend

# Monitor logs for issues
docker-compose logs -f
```

---

**Last Updated:** 2024
**Version:** 1.0
