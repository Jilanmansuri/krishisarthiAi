# 📋 Render + Vercel Deployment - Reference Card

Quick reference for all URLs, credentials, and commands.

---

## 🔑 Critical Information to Keep

**SAVE THIS INFORMATION SECURELY:**

### MongoDB
```
Database Name: krishiai
Username: krishisarthi
Password: [YOUR PASSWORD - SAVE THIS]
Connection String: mongodb+srv://krishisarthi:PASSWORD@cluster0.mongodb.net/krishiai?retryWrites=true&w=majority
```

### GitHub
```
Repository: krishisarthiAi
Branch: main (usually, or your default)
GitHub URL: https://github.com/[YOUR_USERNAME]/krishisarthiAi
```

### Render Backend
```
Service Name: [YOU CHOOSE]
Backend URL: https://[SERVICE-NAME].onrender.com
Health Check: https://[SERVICE-NAME].onrender.com/api/health
API Base: https://[SERVICE-NAME].onrender.com/api
Environment: Production
```

### Vercel Frontend
```
Project Name: [YOU CHOOSE]
Frontend URL: https://[PROJECT-NAME].vercel.app
Environment: Production
Region: Auto-selected by Vercel
```

---

## 🔐 Environment Variables Checklist

### Render Backend - Must Set These

```
PORT=5000
MONGODB_URI=mongodb+srv://krishisarthi:PASSWORD@cluster0.mongodb.net/krishiai?retryWrites=true&w=majority
JWT_SECRET=your-secret-key-here-make-this-long-and-random
CORS_ORIGIN=https://[YOUR-VERCEL-URL].vercel.app
NODE_ENV=production
```

**URLs Copy:**
- Get Vercel URL after deploying → use in CORS_ORIGIN


### Vercel Frontend - Must Set These

```
REACT_APP_API_URL=https://[YOUR-RENDER-URL].onrender.com
```

**URLs Copy:**
- Get Render URL after deploying → use in REACT_APP_API_URL


---

## 🚀 Quick Command Reference

### GitHub
```bash
# Push changes (triggers auto-deploy on both services)
git add .
git commit -m "Update application"
git push origin main
```

### MongoDB Atlas - Test Connection
```bash
# Local testing
mongosh "mongodb+srv://krishisarthi:PASSWORD@cluster0.mongodb.net/krishiai"

# List all databases
show dbs

# Use krishiai database
use krishiai

# List collections
show collections

# Exit
exit
```

### Render Backend - Manual Redeploy
```
Render Dashboard → Backend Service → Settings → Redeploy
```

### Vercel Frontend - Manual Redeploy
```
Vercel Dashboard → Project → Deployments → Click Latest → Redeploy
```

### Test Health Check
```bash
# Backend health
curl https://[YOUR-RENDER-URL].onrender.com/api/health

# Should return: {"status":"ok","message":"Server is running"}
```

---

## 📱 Dashboard Quick Links

Keep these bookmarked:

| Service | URL |
|---------|-----|
| Render Dashboard | https://dashboard.render.com |
| Vercel Dashboard | https://vercel.com/dashboard |
| MongoDB Atlas | https://cloud.mongodb.com |
| GitHub | https://github.com |

---

## 📍 Important File Locations

### In Your Local Repo

```
krishisarthiAi/
├── backend/
│   ├── server.js              ← Main backend file
│   ├── package.json           ← Dependencies
│   ├── config/db.js           ← Database config
│   └── routes/                ← API endpoints
├── frontend/
│   ├── package.json           ← Dependencies
│   ├── src/
│   │   ├── App.jsx            ← Main app
│   │   ├── services/          ← API calls
│   │   └── pages/             ← Page components
│   └── public/
└── .env                        ← Local env variables
```

### Environment Files

```
LOCAL: .env (your machine only)
RENDER: Settings → Environment Variables (backend)
VERCEL: Settings → Environment Variables (frontend)
```

---

## ⏰ Typical Deployment Times

| Step | Expected Time | Max Time | Notes |
|------|---|---|---|
| MongoDB Setup | 5 min | 10 min | One-time setup |
| GitHub Push | 1 min | 2 min | Just pushing code |
| Render Build | 3-5 min | 15 min | First deployment slower |
| Vercel Build | 2-4 min | 10 min | First deployment slower |
| **Total First Time** | **20 min** | **45 min** | |
| **Total Redeploy** | **5 min** | **15 min** | Subsequent pushes |

---

## 🔍 Log Access Quick Guide

### Render Logs
```
https://dashboard.render.com
→ Click service name
→ Click "Logs" tab
→ Scroll bottom for latest
```

### Vercel Logs
```
https://vercel.com/dashboard
→ Click project name
→ Click "Deployments"
→ Click deployment name
→ Scroll for full logs
```

### Browser Console
```
Ctrl/Cmd + Shift + I
→ Console tab
→ Red errors show API issues
```

---

## ✅ Pre-Deployment Checklist

### Before "npm push"

- [ ] Code works locally (`npm start` in both directories)
- [ ] No console errors locally
- [ ] `.env` file has all required variables
- [ ] `.env` file is in `.gitignore` (NOT pushed to GitHub)
- [ ] All changes committed: `git add . && git commit -m "..."`
- [ ] Ready to push: `git push origin main`

### Before Checking Dashboard

- [ ] Waited 30 seconds after push
- [ ] Dashboard shows new deployment started
- [ ] Build is in progress (not showing errors yet)

### After Deployment Complete

- [ ] Dashboard shows green checkmark (no red X)
- [ ] Health endpoint returns 200: `curl https://...onrender.com/api/health`
- [ ] Frontend loads in browser
- [ ] Backend URL is correct in frontend
- [ ] CORS_ORIGIN matches frontend URL exactly

---

## 🆘 Quick Troubleshooting - 30 Second Fixes

```
❌ API calls fail with CORS error
→ Check CORS_ORIGIN on Render exactly matches Vercel URL
→ Hard refresh browser (Ctrl+Shift+R)
→ Restart Render service (Settings → Restart)

❌ Page loads but API returns 500
→ Check Render logs for error message
→ Verify MongoDB connection string in RENDER env vars
→ Verify MONGODB_URI doesn't have @ symbol issues

❌ Files didn't update after push
→ Wait 2-3 minutes (deployment still in progress)
→ Check dashboard shows new deployment
→ Hard refresh browser

❌ MongoDB connection timeout
→ Check Network Access on MongoDB Atlas is 0.0.0.0/0
→ Check cluster shows "Available" (not paused)
→ Verify password is correct and URL-encoded

❌ Deployment fails with "build error"
→ Check logs show exact error
→ Verify all dependencies in package.json
→ Run locally: npm install && npm start
```

---

## 📞 Error Message Decoder

| Error | Meaning | Fix |
|-------|---------|-----|
| CORS error | Backend URL wrong | Update CORS_ORIGIN on Render |
| 404 Not Found | Endpoint doesn't exist | Check route in backend code |
| 500 Internal Error | Backend code crashed | Check Render logs |
| MongoNetworkError | Can't reach DB | Check Network Access (0.0.0.0/0) |
| ECONNREFUSED | Service not up | Wait 2-3 min for deployment |
| ENOENT | File not found | Check file path in start command |
| Cannot find module | Missing dependency | Add to package.json & redeploy |
| INVALID_CORS_ORIGIN | CORS format wrong | Use full URL with https:// |

---

## 🔐 Security Reminders

✅ **DO:**
- Keep .env file local (in .gitignore)
- Use strong JWT_SECRET
- Never commit sensitive data
- Use environment variables for secrets
- Rotate JWT_SECRET occasionally

❌ **DON'T:**
- Commit .env to GitHub
- Use weak passwords
- Share dashboard passwords
- Use same JWT_SECRET everywhere
- Expose API keys in frontend code

---

## 📈 Post-Deployment Tasks

### Monitor in First 24 Hours
- [ ] Check Render logs periodically for errors
- [ ] Test all main API endpoints
- [ ] Verify database is saving data
- [ ] Check logs show no warnings

### Weekly Maintenance
- [ ] Review Render/Vercel logs for patterns
- [ ] Check MongoDB storage usage (near limit?)
- [ ] Verify automated backups if needed
- [ ] Review any new errors

### Monthly Maintenance
- [ ] Rotate JWT_SECRET (if needed)
- [ ] Review and update dependencies
- [ ] Check MongoDB Atlas for updates
- [ ] Review cost/usage on all services

---

## 📚 Complete Documentation Links

| Document | Purpose |
|----------|---------|
| [RENDER_VERCEL_QUICK_START.md](./RENDER_VERCEL_QUICK_START.md) | Start here - quick roadmap |
| [MONGODB_ATLAS_SETUP.md](./MONGODB_ATLAS_SETUP.md) | Detailed MongoDB guide |
| [RENDER_DEPLOYMENT_GUIDE.md](./RENDER_DEPLOYMENT_GUIDE.md) | Detailed Render backend guide |
| [VERCEL_DEPLOYMENT_GUIDE.md](./VERCEL_DEPLOYMENT_GUIDE.md) | Detailed Vercel frontend guide |
| [DEPLOY_RENDER_VERCEL.md](./DEPLOY_RENDER_VERCEL.md) | Complete integration guide |
| [RENDER_VERCEL_TROUBLESHOOTING.md](./RENDER_VERCEL_TROUBLESHOOTING.md) | Full troubleshooting guide |

---

## 🎯 Your Personal Notes Space

Add your specific information here:

```
My MongoDB Connection String:
_________________________________________

My Render Backend URL:
_________________________________________

My Vercel Frontend URL:
_________________________________________

My GitHub Repository:
_________________________________________

Important Notes:
_________________________________________
_________________________________________
_________________________________________
```

---

**Last Updated:** 2024
**Status:** ✅ Complete & Ready to Deploy
**Total Guides Available:** 6 comprehensive documents
**Total Time to Deploy:** ~45 minutes (first time)
