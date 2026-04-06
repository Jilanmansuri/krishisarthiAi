# 🏗️ KrishiSarthi Deployment Architecture

## System Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                         INTERNET / USERS                         │
└──────────────────────────┬──────────────────────────────────────┘
                           │
                    HTTP/HTTPS Request
                           │
                           ▼
        ┌──────────────────────────────────────┐
        │   Nginx Reverse Proxy (Port 80/443)  │
        │   - SSL/TLS Termination              │
        │   - Gzip Compression                 │
        │   - Rate Limiting                    │
        │   - Static File Caching              │
        └──────────┬─────────────────┬─────────┘
                   │                 │
         ┌─────────┴────────┐   ┌────┴──────────────┐
         │                  │   │                   │
         ▼                  ▼   ▼                   ▼
    ┌──────────┐    ┌──────────────┐       ┌──────────┐
    │ Frontend │    │   Backend    │       │  Static  │
    │ React    │    │   Node.js    │       │  Files   │
    │(Port3000)│    │  (Port 5000) │       │  Cache   │
    └──────────┘    └──┬───────────┘       └──────────┘
         │             │
         │      ┌──────┴───────────┐
         │      │                  │
         │      ▼                  ▼
         │  ┌─────────────┐   ┌─────────┐
         │  │  JWT Auth   │   │   API   │
         │  │  Validation │   │ Routes  │
         │  └─────────────┘   └────┬────┘
         │                         │
         └────────────┬────────────┘
                      │
                      ▼
          ┌───────────────────────┐
          │   MongoDB Database    │
          │   (Port 27017)        │
          │   - Authentication    │
          │   - Data Persistence  │
          │   - Replication Ready │
          └───────────────────────┘
                      │
                      ▼
          ┌───────────────────────┐
          │   Persistent Volume   │
          │   - Data Storage      │
          │   - Backups           │
          └───────────────────────┘
```

---

## Docker Compose Stack

```
                         docker-compose.yml
┌──────────────────────────────────────────────────────────────┐
│                    Krishna Sarthi Network                    │
│  ┌──────────────────────────────────────────────────────┐   │
│  │                 Container Services                    │   │
│  │                                                       │   │
│  │  ┌─────────────────────────────────────────────┐    │   │
│  │  │  MongoDB Container                          │    │   │
│  │  │  - Image: mongo:7                           │    │   │
│  │  │  - Port: 27017                              │    │   │
│  │  │  - Volume: mongodb_data (persistent)        │    │   │
│  │  │  - Health Check: mongosh ping               │    │   │
│  │  └─────────────────────────────────────────────┘    │   │
│  │                     ▲                                 │   │
│  │                     │                                 │   │
│  │  ┌──────────────────┴──────────────────────────┐    │   │
│  │  │  Backend Container (Node.js)                │    │   │
│  │  │  - Build: ./backend/Dockerfile              │    │   │
│  │  │  - Port: 5000                               │    │   │
│  │  │  - Env: NODE_ENV, MONGODB_URI, API Keys     │    │   │
│  │  │  - Health Check: GET /api/health            │    │   │
│  │  │  - Volume: ./backend:/app (dev mode)        │    │   │
│  │  └──────────────────┬──────────────────────────┘    │   │
│  │                     ▲                                 │   │
│  │  ┌──────────────────┴──────────────────────────┐    │   │
│  │  │  Frontend Container (React)                 │    │   │
│  │  │  - Build: ./frontend/Dockerfile             │    │   │
│  │  │  - Port: 3000                               │    │   │
│  │  │  - Env: REACT_APP_API_URL                   │    │   │
│  │  │  - Health Check: GET /                      │    │   │
│  │  │  - Serve: Production build                  │    │   │
│  │  └──────────────────┬──────────────────────────┘    │   │
│  │                     ▲                                 │   │
│  │  ┌──────────────────┴──────────────────────────┐    │   │
│  │  │  Nginx Container                            │    │   │
│  │  │  - Image: nginx:alpine                      │    │   │
│  │  │  - Port: 80 (HTTP), 443 (HTTPS)             │    │   │
│  │  │  - Config: ./nginx.conf                     │    │   │
│  │  │  - Reverse Proxy: Routes /api to backend    │    │   │
│  │  │                    Routes / to frontend      │    │   │
│  │  └──────────────────────────────────────────────┘    │   │
│  │                                                       │   │
│  └──────────────────────────────────────────────────────┘   │
│                                                              │
│  Volumes:                                                    │
│  - mongodb_data (MongoDB data persistence)                  │
│  - mongodb_config (MongoDB configuration)                   │
│                                                              │
│  Networks:                                                   │
│  - krishisarthi_network (Bridge network for inter-service)  │
└──────────────────────────────────────────────────────────────┘
```

---

## Deployment Environments

### Local Development
```
Your Machine
    ↓
docker-compose up -d
    ↓
Docker Desktop
    ↓
Containers: MongoDB, Backend, Frontend, Nginx
    ↓
Access: http://localhost
```

### Staging
```
Staging Server
    ↓
docker-compose -f docker-compose.staging.yml up -d
    ↓
Separate databases & ports
    ↓
Full integration testing
```

### Production
```
Production Server / Cloud Platform
    ↓
docker-compose up -d (with .env configured)
    ↓
Monitored, backed up, scaled
    ↓
SSL/TLS encryption
    ↓
Accessible via domain.com
```

---

## Data Flow

### User Request Flow
```
User Browser
    │
    │ HTTP GET /
    ├─────────────────────────────────────┐
    │                                     │
    ▼ HTTP GET /api/health               ▼ HTTP GET /static/css/main.css
  Nginx                                 Nginx
    │                                     │
    │ Proxy to                            │ Serve from cache
    ▼                                     ▼
Backend (Node/Express)                Frontend Build Files
    │                                     │
    │ Connect to                          │ Return CSS
    ▼                                     ▼
MongoDB                               Browser Renders UI
    │                                     │
    │ Query/Insert/Update                 │ User sees page
    ▼                                     ▼
Return health status                   Page Ready
    │
    ▼ Send JSON
Browser receives API response
    │
    ▼
JavaScript processes & updates UI
```

### Authentication Flow
```
User Login
    │
    ▼
POST /api/auth/login {email, password}
    │
    ▼ Backend
Receive credentials
    │
    ▼
Query MongoDB for user
    │
    ▼
Compare passwords (bcryptjs)
    │
    ├─ Match → Generate JWT token
    └─ No Match → Return 401 Unauthorized
    │
    ▼
Send JWT token to frontend
    │
    ▼
Frontend stores token (localStorage)
    │
    ▼
Include token in Authorization header for API requests
    │
    ▼
Backend validates JWT
    │
    ├─ Valid → Process request
    └─ Invalid → Return 401 Unauthorized
```

---

## Scaling Architecture

### Phase 1: Single Instance (MVP)
```
┌──────────────────────────────┐
│   Docker Container           │
│   ├─ Backend (1 instance)    │
│   ├─ Frontend (1 instance)   │
│   ├─ Nginx                   │
│   └─ MongoDB                 │
└──────────────────────────────┘
     ├─ Cost: Low ($5-20/mo)
     ├─ Scalability: Limited
     └─ Best for: MVP, small projects
```

### Phase 2: Multiple Instances + LB (Growth)
```
                         Load Balancer
                              │
            ┌─────────────────┼─────────────────┐
            ▼                 ▼                 ▼
        Instance 1        Instance 2       Instance 3
        ┌──────────┐      ┌──────────┐     ┌──────────┐
        │Backend 1 │      │Backend 2 │     │Backend 3 │
        └──────────┘      └──────────┘     └──────────┘
             │                 │                │
             └─────────────────┼────────────────┘
                               ▼
                        Shared MongoDB
                        
     ├─ Cost: Medium ($20-50/mo)
     ├─ Scalability: Good
     └─ Best for: Growing applications
```

### Phase 3: Kubernetes + Auto-scaling (Enterprise)
```
                    Kubernetes Cluster
    
    ┌─────────────────────────────────────────────────┐
    │  Ingress Controller (Entry Point)               │
    │  - SSL/TLS Termination                          │
    │  - Routing                                      │
    └────────────────┬────────────────────────────────┘
                     │
    ┌────────────────┴────────────────┐
    │                                 │
    ▼                                 ▼
Backend Service                   Frontend Service
(HPA: 2-10 replicas)             (HPA: 2-5 replicas)
    │                                 │
    ├─ Replica 1                      ├─ Replica 1
    ├─ Replica 2                      ├─ Replica 2
    └─ Replica N                      └─ Replica N
    
    Shared MongoDB / DocumentDB
    
    ├─ Cost: High ($50-200+/mo)
    ├─ Scalability: Unlimited
    └─ Best for: Enterprise, high-traffic
```

---

## Database Architecture

### MongoDB Structure
```
MongoDB Instance
    │
    ├─ Database: krishiai
    │   │
    │   ├─ Collection: users
    │   │   ├─ userId
    │   │   ├─ email
    │   │   ├─ password (hashed)
    │   │   └─ profile
    │   │
    │   ├─ Collection: recommendations
    │   │   ├─ recommendationId
    │   │   ├─ crop
    │   │   ├─ soil
    │   │   ├─ weather
    │   │   └─ suggestion
    │   │
    │   ├─ Collection: soilReports
    │   │   ├─ reportId
    │   │   ├─ testData
    │   │   ├─ analysis
    │   │   └─ recommendations
    │   │
    │   └─ Collection: schemes
    │       ├─ schemeId
    │       ├─ name
    │       ├─ benefits
    │       └─ eligibility
    │
    └─ Indexes (Performance)
        ├─ userId (users)
        ├─ email (users)
        ├─ timestamp (recommendations)
        └─ state (schemes)
```

---

## Security Layers

```
┌────────────────────────────────────────────────────┐
│  Layer 1: HTTP/HTTPS (Transport)                  │
│  - SSL/TLS Encryption                             │
│  - HSTS Headers                                   │
└────────────────────────────────────────────────────┘
                         ↓
┌────────────────────────────────────────────────────┐
│  Layer 2: Nginx (Application Entry)               │
│  - Rate Limiting                                  │
│  - IP Whitelisting (optional)                     │
│  - DDoS Protection                                │
│  - WAF Rules (optional)                           │
└────────────────────────────────────────────────────┘
                         ↓
┌────────────────────────────────────────────────────┐
│  Layer 3: Express Middleware                      │
│  - Helmet.js (Security Headers)                   │
│  - CORS Validation                                │
│  - Body Parser Limits                             │
│  - Input Sanitization                             │
└────────────────────────────────────────────────────┘
                         ↓
┌────────────────────────────────────────────────────┐
│  Layer 4: Authentication (JWT)                    │
│  - Token Verification                             │
│  - Role-Based Access Control (RBAC)               │
│  - Session Management                             │
└────────────────────────────────────────────────────┘
                         ↓
┌────────────────────────────────────────────────────┐
│  Layer 5: Database (MongoDB)                      │
│  - User Authentication                            │
│  - Query Authorization                            │
│  - Data Encryption (optional)                     │
│  - Access Logs                                    │
└────────────────────────────────────────────────────┘
```

---

## Monitoring & Logging Flow

```
Application Services
    │
    ├─ Logs
    │   ├─ stdout/stderr
    │   ├─ App logs
    │   └─ Request logs
    │
    ├─ Metrics
    │   ├─ CPU usage
    │   ├─ Memory usage
    │   ├─ Request count
    │   └─ Response time
    │
    └─ Health Checks
        ├─ GET /api/health
        ├─ GET /health
        └─ Database connectivity
        
        ↓
        
Aggregation Layer (Optional: ELK, DataDog)
    ├─ Log Storage
    ├─ Metrics DB
    ├─ Alerting
    └─ Dashboards
    
        ↓
        
Monitoring & Analytics
    ├─ Performance metrics
    ├─ Error tracking
    ├─ User analytics
    └─ Alerts & notifications
    
        ↓
        
Operations/DevOps Team
    ├─ Dashboard review
    ├─ Alert response
    ├─ Scaling decisions
    └─ Optimization
```

---

## Deployment Pipeline

```
1. Developer Push
   └─ git push origin main
   
        ↓
        
2. GitHub Actions Triggered
   ├─ Checkout code
   ├─ Install dependencies
   ├─ Run tests
   ├─ Security scanning
   └─ Build Docker images
   
        ↓
        
3. Images Built & Pushed
   ├─ Backend image → Registry
   ├─ Frontend image → Registry
   └─ Nginx config → Registry
   
        ↓
        
4. Production Deployment
   ├─ SSH to server
   ├─ Pull latest images
   ├─ docker-compose pull
   ├─ docker-compose up -d
   └─ Verify health checks
   
        ↓
        
5. Running Production
   ├─ Monitor logs
   ├─ Check metrics
   ├─ Respond to alerts
   └─ Auto-restart on failure
   
        ↓
        
6. Continuous Monitoring
   ├─ Response time
   ├─ Error rate
   ├─ Resource usage
   └─ User feedback
```

---

## Network Communication

```
Internet
    │
    ├─ DNS Query (krishisarthi.com)
    └─ Resolves to: Server IP
    
        ↓
        
Server IP (Public)
    │
    ├─ Port 80 (HTTP)
    ├─ Port 443 (HTTPS)
    └─ Other ports blocked
    
        ↓
        
Nginx (Port 80/443)
    │
    ├─ Route 1: /api/* → Backend (port 5000)
    ├─ Route 2: / → Frontend (port 3000)
    └─ Route 3: /static/* → Cache
    
        ↓
        
Internal Docker Network (krishisarthi_network)
    │
    ├─ Backend (port 5000)
    │   └─ MongoDB (port 27017)
    │
    └─ Frontend (port 3000)
        └─ Static assets
        
Internal Network Communication (Service names)
    ├─ backend:5000
    ├─ frontend:3000
    └─ mongodb:27017
    
No external access to internal services
```

---

## File System Architecture

```
Docker Host Storage
│
├─ Docker Volumes
│   ├─ mongodb_data/
│   │   └─ Raw MongoDB data files
│   │
│   └─ mongodb_config/
│       └─ MongoDB configuration
│
├─ Container Layers
│   ├─ Backend Container
│   │   ├─ Base: node:18-alpine
│   │   ├─ Code: /app/{server.js, routes, models, etc}
│   │   ├─ Modules: /app/node_modules
│   │   └─ Working Directory: /app
│   │
│   ├─ Frontend Container
│   │   ├─ Base: node:18-alpine
│   │   ├─ Build Output: /app/build
│   │   └─ Working Directory: /app
│   │
│   └─ Nginx Container
│       ├─ Base: nginx:alpine
│       ├─ Config: /etc/nginx/nginx.conf
│       └─ Log: /var/log/nginx
│
└─ Bind Mounts (Development Mode)
    ├─ ./backend → /app (hot reload)
    ├─ ./frontend → /app (hot reload)
    └─ ./nginx.conf → /etc/nginx/nginx.conf
```

---

## Summary

This architecture provides:
- ✅ **Scalability** - From single instance to Kubernetes
- ✅ **Reliability** - Health checks, auto-restart, backups
- ✅ **Security** - Multiple security layers
- ✅ **Performance** - Caching, compression, optimization
- ✅ **Observability** - Logging, monitoring, metrics
- ✅ **Flexibility** - Multiple deployment options

For more details, see specific documentation files.
