# 🚀 Render + Vercel Deployment - Quick Start

Deploy KrishiSarthi with Backend on Render and Frontend on Vercel in 45 minutes.

---

## 📋 Complete Roadmap

```
Step 1: MongoDB Atlas Setup (10 min)
        ↓
Step 2: GitHub Preparation (5 min)
        ↓
Step 3: Render Backend Deployment (10 min)
        ↓
Step 4: Vercel Frontend Deployment (10 min)
        ↓
Step 5: Update CORS & Test (5 min)
        ↓
✅ DONE! Your app is live!
```

---

## 🎯 Quick Navigation

| Step | Task | File | Time |
|------|------|------|------|
| 1️⃣ | Setup MongoDB | [MONGODB_ATLAS_SETUP.md](./MONGODB_ATLAS_SETUP.md) | 10 min |
| 2️⃣ | Prepare Code | [DEPLOY_RENDER_VERCEL.md](./DEPLOY_RENDER_VERCEL.md) - Part 2 | 5 min |
| 3️⃣ | Deploy Backend | [RENDER_DEPLOYMENT_GUIDE.md](./RENDER_DEPLOYMENT_GUIDE.md) | 10 min |
| 4️⃣ | Deploy Frontend | [VERCEL_DEPLOYMENT_GUIDE.md](./VERCEL_DEPLOYMENT_GUIDE.md) | 10 min |
| 5️⃣ | Final Config | [DEPLOY_RENDER_VERCEL.md](./DEPLOY_RENDER_VERCEL.md) - Part 5 | 5 min |

---

## ⚡ 45-Minute Deployment Guide

### ✅ Step 1: MongoDB Atlas (10 minutes)
**Follow:** [MONGODB_ATLAS_SETUP.md](./MONGODB_ATLAS_SETUP.md)

**Checklist:**
- [ ] Create MongoDB Atlas account
- [ ] Create free cluster (M0)
- [ ] Create user: `krishisarthi`
- [ ] Save password
- [ ] Allow network access (0.0.0.0/0)
- [ ] Get connection string: `mongodb+srv://krishisarthi:PASSWORD@...`

**Result:** You have MongoDB connection string saved

---

### ✅ Step 2: Prepare Your Code (5 minutes)
**Follow:** [DEPLOY_RENDER_VERCEL.md](./DEPLOY_RENDER_VERCEL.md) - Part 2

**Checklist:**
- [ ] Code pushed to GitHub (main branch)
- [ ] Backend: `backend/package.json` has start script
- [ ] Frontend: `frontend/package.json` exists
- [ ] `.env.example` files exist (optional but recommended)

**Result:** Code is ready for deployment

---

### ✅ Step 3: Deploy Backend on Render (10 minutes)
**Follow:** [RENDER_DEPLOYMENT_GUIDE.md](./RENDER_DEPLOYMENT_GUIDE.md)

**Quick Summary:**
1. Go to https://render.com → Sign up with GitHub
2. Click "New +" → "Web Service"
3. Select your GitHub repo
4. **Settings:**
   - Name: `krishisarthi-backend`
   - Build: `npm install`
   - Start: `node backend/server.js`
5. **Add Environment Variables:**
   - `NODE_ENV`: `production`
   - `PORT`: `5000`
   - `MONGODB_URI`: Your connection string
   - `JWT_SECRET`: Random 32-char key
   - `GOOGLE_GENAI_API_KEY`: Your key
   - `OPENAI_API_KEY`: Your key
   - `GROK_API_KEY`: Your key
   - `CORS_ORIGIN`: `*` (update later)
6. Click "Create Web Service"
7. Wait 3-5 minutes for deployment
8. **Save your URL:** `https://krishisarthi-backend.onrender.com`

**Verify:** Open in browser:
```
https://krishisarthi-backend.onrender.com/api/health
```
Should show: `{"status":"Server is running",...}`

**Result:** Backend is live! 🟢

---

### ✅ Step 4: Deploy Frontend on Vercel (10 minutes)
**Follow:** [VERCEL_DEPLOYMENT_GUIDE.md](./VERCEL_DEPLOYMENT_GUIDE.md)

**Quick Summary:**
1. Go to https://vercel.com → Sign up with GitHub
2. Click "New Project" → "Import Git Repository"
3. Select your GitHub repo
4. **Settings:**
   - Framework: React (auto-detected)
   - Root Directory: `./frontend`
   - Build: `npm run build` (auto-filled)
5. **Add Environment Variable:**
   - `REACT_APP_API_URL`: Your Render backend URL
   - Example: `https://krishisarthi-backend.onrender.com`
   - ⚠️ NO trailing slash, NO /api
6. Click "Deploy"
7. Wait 2-3 minutes
8. **Save your URL:** `https://krishisarthi-frontend.vercel.app`

**Verify:** Open in browser:
```
https://krishisarthi-frontend.vercel.app
```
Your React app should load

**Result:** Frontend is live! 🔵

---

### ✅ Step 5: Final Configuration (5 minutes)

#### Update Backend CORS
1. Go to Render dashboard
2. Click `krishisarthi-backend` service
3. Go to "Environment"
4. Find `CORS_ORIGIN` variable
5. Click edit icon
6. Change value to: `https://krishisarthi-frontend.vercel.app`
7. Click "Save"
8. Service auto-redeploys (1-2 minutes)

#### Test Connection
1. Go to https://krishisarthi-frontend.vercel.app
2. Try using app features
3. Open browser console (F12)
4. Look for CORS errors (should be none)
5. Try API calls (login, fetch data, etc.)

**Result:** Everything works together! 🎉

---

## 📝 All Required API Keys

### 1. Google Generative AI
- Website: https://ai.google.dev
- Free tier: Yes
- Get key: Click "Get API Key"
- Key format: `AIzaSy...`

### 2. OpenAI
- Website: https://platform.openai.com
- Free tier: $5 credit
- Get key: Platform → API Keys → Create new
- Key format: `sk-...`

### 3. Grok (XAI)
- Website: https://api.x.ai
- Free tier: Check website
- Get key: Request API access
- Key format: `xai-...`

### 4. MongoDB Atlas
- Website: https://www.mongodb.com/cloud/atlas
- Free tier: 512MB
- Connection string from Step 1

---

## ✅ Post-Deployment Checklist

### Security
- [ ] Strong JWT_SECRET set (32+ chars)
- [ ] All API keys are valid
- [ ] No API keys in GitHub code
- [ ] MongoDB user has role restriction (or admin is fine for now)
- [ ] Network access configured

### Functionality
- [ ] Backend health check works
- [ ] Frontend loads without errors
- [ ] API calls work (no CORS errors)
- [ ] Database connection established
- [ ] Can log in (if auth implemented)
- [ ] Can fetch data (if data endpoints exist)

### Monitoring
- [ ] Check Render logs occasionally
- [ ] Check Vercel deployments
- [ ] Monitor MongoDB usage
- [ ] Set up uptime alerts (optional)

---

## 🔄 Future Updates

### When You Update Backend
```bash
# Make changes in backend/
git add backend/
git commit -m "Update backend: description"
git push origin main

# Render automatically redeploys (30 seconds - 2 minutes)
# No manual action needed!
```

### When You Update Frontend
```bash
# Make changes in frontend/
git add frontend/
git commit -m "Update frontend: description"
git push origin main

# Vercel automatically redeploys (1-3 minutes)
# No manual action needed!
```

---

## 🆘 Quick Troubleshooting

### Backend Won't Deploy
**Check:**
1. `backend/package.json` exists
2. Start command is: `node backend/server.js`
3. Check Render logs for errors
4. All env vars are set

### Frontend Won't Deploy
**Check:**
1. `frontend/package.json` exists
2. Root directory is: `./frontend`
3. `REACT_APP_API_URL` is set correctly
4. Check Vercel logs

### CORS Errors
**Fix:**
1. Update `CORS_ORIGIN` on Render to match Vercel URL
2. Restart backend service
3. Clear browser cache (Ctrl+Shift+Delete)
4. Reload page

### API Calls Fail
**Check:**
1. Render backend is running (check health endpoint)
2. `REACT_APP_API_URL` is correct (no trailing slash)
3. Backend environment variables are all set
4. MongoDB is accessible

### Database Won't Connect
**Check:**
1. MongoDB connection string is correct
2. Username and password are correct
3. Network access includes 0.0.0.0/0
4. MongoDB cluster is "Available" (not paused)

---

## 📊 Your Final Setup

| Component | Platform | URL |
|-----------|----------|-----|
| **Backend API** | Render | `https://krishisarthi-backend.onrender.com` |
| **Frontend App** | Vercel | `https://krishisarthi-frontend.vercel.app` |
| **Database** | MongoDB Atlas | Cloud hosted (Free 512MB) |
| **Cost** | All FREE | (Free tier all services) |

---

## 📞 Support Resources

| Issue | Reference |
|-------|-----------|
| MongoDB questions | [MONGODB_ATLAS_SETUP.md](./MONGODB_ATLAS_SETUP.md) |
| Backend deployment | [RENDER_DEPLOYMENT_GUIDE.md](./RENDER_DEPLOYMENT_GUIDE.md) |
| Frontend deployment | [VERCEL_DEPLOYMENT_GUIDE.md](./VERCEL_DEPLOYMENT_GUIDE.md) |
| Full guide | [DEPLOY_RENDER_VERCEL.md](./DEPLOY_RENDER_VERCEL.md) |
| Docker alternative | [DEPLOYMENT.md](./DEPLOYMENT.md) |

---

## 🎉 Summary

### What You Get
✅ Backend running on Render  
✅ Frontend running on Vercel  
✅ Database on MongoDB Atlas  
✅ Automatic GitHub deployments  
✅ Custom domains (optional)  
✅ FREE hosting (all services)  

### Total Time
Total: **45 minutes**
- MongoDB: 10 min
- GitHub prep: 5 min
- Backend (Render): 10 min
- Frontend (Vercel): 10 min
- Final config: 5 min

### Next Steps
1. Start with Step 1: [MONGODB_ATLAS_SETUP.md](./MONGODB_ATLAS_SETUP.md)
2. Follow the roadmap
3. Test your app
4. Share with friends! 🚀

---

**Status:** ✅ Ready to Deploy  
**Difficulty:** Easy  
**Cost:** FREE  
**Time:** 45 minutes  

**Start now with [MONGODB_ATLAS_SETUP.md](./MONGODB_ATLAS_SETUP.md)** ⏱️
