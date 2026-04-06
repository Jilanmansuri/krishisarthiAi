# 🚀 Deploy Backend on Render + Frontend on Vercel

Complete step-by-step guide to deploy KrishiSarthi with backend on Render and frontend on Vercel.

---

## 📋 Prerequisites

### What You Need
- [ ] GitHub account (for connecting repositories)
- [ ] Render account (https://render.com - free)
- [ ] Vercel account (https://vercel.com - free)
- [ ] MongoDB Atlas account (https://www.mongodb.com/cloud/atlas - free 512MB)
- [ ] All API keys:
  - Google GenAI API key
  - OpenAI API key
  - Grok API key

### Time Required
- Setup: 30 minutes
- Total deployment: 45 minutes

---

## 🔄 Part 1: Setup MongoDB Atlas

### Step 1: Create MongoDB Atlas Account
1. Go to https://www.mongodb.com/cloud/atlas
2. Click "Start free"
3. Sign up with GitHub or email
4. Create organization and project

### Step 2: Create Database Cluster
1. Click "Create a deployment"
2. Choose **FREE** tier (M0)
3. Select your preferred region (choose closest to you)
4. Click "Create cluster"
5. Wait 5-10 minutes for cluster to initialize

### Step 3: Create Database User
1. Go to "Database Access" section
2. Click "Add new database user"
3. Username: `krishisarthi`
4. Password: Create a **strong password** (save it! 🔐)
5. Click "Add user"

### Step 4: Setup Network Access
1. Go to "Network Access"
2. Click "Add IP Address"
3. Click "Allow access from anywhere"
   - This allows connections from any IP (needed for Render)
4. Click "Confirm"

### Step 5: Get Connection String
1. Go back to "Databases"
2. Click "Connect" button on your cluster
3. Select "Drivers"
4. Copy the connection string that looks like:
```
mongodb+srv://krishisarthi:PASSWORD@cluster.mongodb.net/krishiai?retryWrites=true&w=majority
```
5. **Replace `<password>` with your actual password**
6. **Save this string - you'll need it!** 📝

### Example Connection String
```
mongodb+srv://krishisarthi:mySecurePassword123@cluster0.mongodb.net/krishiai?retryWrites=true&w=majority
```

---

## 🎯 Part 2: Prepare Your Code on GitHub

### Step 1: Push Code to GitHub
If not already done:
```bash
cd /path/to/krishisarthiAi
git add .
git commit -m "Prepare for Render and Vercel deployment"
git push origin main
```

### Step 2: Create `.env.example` Files

#### For Backend (`backend/.env.example`)
```env
NODE_ENV=production
PORT=5000
MONGODB_URI=mongodb+srv://krishisarthi:PASSWORD@cluster.mongodb.net/krishiai?retryWrites=true&w=majority
JWT_SECRET=your-super-secret-32-character-random-key-here
GOOGLE_GENAI_API_KEY=your-google-genai-key
OPENAI_API_KEY=your-openai-key
GROK_API_KEY=your-grok-key
CORS_ORIGIN=https://yourdomain.vercel.app
```

#### For Frontend (`frontend/.env.example`)
```env
REACT_APP_API_URL=https://your-backend.render.com
```

### Step 3: Update Backend `package.json`

Make sure your `backend/package.json` has these scripts:
```json
{
  "scripts": {
    "start": "node server.js",
    "dev": "nodemon server.js",
    "build": "echo 'No build step needed for Node.js'"
  },
  "engines": {
    "node": ">=18.0.0"
  }
}
```

### Step 4: Commit and Push
```bash
git add .
git commit -m "Add environment configuration files"
git push origin main
```

---

## 🟡 Part 3: Deploy Backend on Render

### Step 1: Connect GitHub to Render
1. Go to https://render.com
2. Click "Sign up" (use GitHub for easy connection)
3. Authorize Render to access your GitHub account

### Step 2: Create New Web Service
1. Go to "Dashboard"
2. Click "New +"
3. Select "Web Service"
4. Click "Connect a repository"
5. Search for `krishisarthiAi`
6. Click "Connect" next to your repository

### Step 3: Configure Web Service
1. **Name:** `krishisarthi-backend`
2. **Region:** Choose your closest region
3. **Branch:** `main`
4. **Runtime:** Node
5. **Build Command:** `npm install`
6. **Start Command:** `node backend/server.js`

### Step 4: Add Environment Variables
1. Scroll down to "Environment" section
2. Click "Add Environment Variable"
3. Add each variable:

| Key | Value |
|-----|-------|
| `NODE_ENV` | `production` |
| `PORT` | `5000` |
| `MONGODB_URI` | Your MongoDB connection string (from Part 1, Step 5) |
| `JWT_SECRET` | Generate a random 32-char string: `openssl rand -base64 32` |
| `GOOGLE_GENAI_API_KEY` | Your Google API key |
| `OPENAI_API_KEY` | Your OpenAI API key |
| `GROK_API_KEY` | Your Grok API key |
| `CORS_ORIGIN` | `https://yourname.vercel.app` (we'll update this later) |

### Step 5: Deploy
1. Scroll to bottom
2. Click "Create Web Service"
3. Wait for deployment (usually 3-5 minutes)
4. You'll see a live URL like: `https://krishisarthi-backend.onrender.com`

### Step 6: Verify Backend is Running
```bash
curl https://krishisarthi-backend.onrender.com/api/health
```

You should see a response like:
```json
{"status":"Server is running","timestamp":"2024-01-15T..."}
```

**📝 Save your backend URL!** You'll need it for the frontend.

---

## 🔵 Part 4: Deploy Frontend on Vercel

### Step 1: Connect GitHub to Vercel
1. Go to https://vercel.com
2. Click "Sign up" (use GitHub)
3. Authorize Vercel to access your GitHub

### Step 2: Import Project
1. Go to Dashboard
2. Click "New Project"
3. Click "Import Git Repository"
4. Search for `krishisarthiAi`
5. Click "Import"

### Step 3: Configure Project
1. **Project Name:** `krishisarthi-frontend`
2. **Framework Preset:** React
3. **Root Directory:** `./frontend`

### Step 4: Add Environment Variables
1. Click "Environment Variables"
2. Add variable:

| Key | Value |
|-----|-------|
| `REACT_APP_API_URL` | Your backend URL from Part 3 (e.g., `https://krishisarthi-backend.onrender.com`) |

### Step 5: Deploy
1. Click "Deploy"
2. Wait for deployment (usually 2-3 minutes)
3. You'll get a URL like: `https://krishisarthi-frontend.vercel.app`

### Step 6: Verify Frontend is Running
- Visit your Vercel URL in browser
- You should see your React app loading
- Check browser console for any API errors

**🎉 Your frontend is now live!**

---

## 🔗 Part 5: Final Configuration (Update CORS)

### Step 1: Get Your Vercel Frontend URL
From Part 4, you have a URL like: `https://krishisarthi-frontend.vercel.app`

### Step 2: Update Backend CORS on Render
1. Go to https://render.com dashboard
2. Click on `krishisarthi-backend` service
3. Go to "Environment"
4. Find `CORS_ORIGIN` variable
5. Click edit icon
6. Change value to your Vercel URL: `https://krishisarthi-frontend.vercel.app`
7. Click "Save"

### Step 3: Redeploy Backend
1. The service will automatically redeploy (takes 1-2 minutes)
2. You'll see "Redeployed" notification

### Step 4: Test the Connection
1. Go to your Vercel app
2. Try to use a feature that calls the backend API
3. Check if it works (no CORS errors)

---

## ✅ Testing Checklist

### Backend Health Checks
- [ ] API health endpoint works: `https://your-backend.onrender.com/api/health`
- [ ] Can connect to MongoDB (check Render logs)
- [ ] No authentication errors in logs
- [ ] CORS allows your Vercel domain

### Frontend Checks
- [ ] App loads at your Vercel URL
- [ ] No 404 errors
- [ ] Browser console shows no errors
- [ ] API calls work (test login, recommendations, etc.)

### Integration Tests
- [ ] Login works
- [ ] Can fetch data from API
- [ ] No "blocked by CORS" errors
- [ ] Images load properly
- [ ] Forms submit successfully

---

## 🔍 Common Issues & Fixes

### Issue 1: CORS Errors in Frontend Console
**Error:** `Access to XMLHttpRequest blocked by CORS`

**Solution:**
1. Make sure `REACT_APP_API_URL` is correctly set in Vercel
2. Make sure `CORS_ORIGIN` on Render includes your Vercel domain
3. Redeploy both services
4. Clear browser cache

### Issue 2: Backend Service Won't Deploy
**Error:** `Build failed`

**Solution:**
1. Check Render logs for errors
2. Make sure `backend/package.json` exists
3. Make sure all dependencies are installed
4. Check Node.js version (should be 18+)

### Issue 3: MongoDB Connection Error
**Error:** `MongoNetworkError` or `connection timeout`

**Solution:**
1. Verify MongoDB connection string is correct (from Part 1, Step 5)
2. Check Render environment variable: `MONGODB_URI`
3. On MongoDB Atlas, verify:
   - Network access includes "Allow access from anywhere"
   - Database user password is correct
   - Cluster is running (not paused)

### Issue 4: API Calls Return 401 Unauthorized
**Error:** Invalid authentication

**Solution:**
1. Make sure `JWT_SECRET` is set on Render
2. Check authentication route works: `POST /api/auth/login`
3. Verify database has user data

### Issue 5: Frontend Shows Blank Page
**Error:** White page with no content

**Solution:**
1. Check browser console for JavaScript errors
2. Check Vercel deployment logs
3. Make sure `REACT_APP_API_URL` doesn't have trailing slash
4. Try clearing build cache in Vercel

---

## 🔄 Updating Your Code

### When You Update Backend Code
```bash
# Make changes
git add backend/
git commit -m "Update backend code"
git push origin main

# Render will automatically redeploy (within seconds)
# Check status at: https://render.com/dashboard
```

### When You Update Frontend Code
```bash
# Make changes
git add frontend/
git commit -m "Update frontend code"
git push origin main

# Vercel will automatically redeploy (within seconds)
# Check status at: https://vercel.com/dashboard
```

---

## 📊 Monitoring & Logs

### View Backend Logs (Render)
1. Go to https://render.com/dashboard
2. Click `krishisarthi-backend`
3. Click "Logs" tab
4. See real-time logs

### View Frontend Logs (Vercel)
1. Go to https://vercel.com/dashboard
2. Click project name
3. Click "Deployments"
4. See deployment logs

### Debug Backend Issues
```bash
# SSH into Render shell (if available in paid plan)
# Or check logs for errors
# Common issues:
# - Database connection: Check MONGODB_URI
# - API key missing: Check environment variables
# - Port issues: Should use PORT env variable
```

---

## 🚀 Production Tips

### 1. Database Backups
- MongoDB Atlas free tier: automatic backups
- Recommended: Enable backup notifications

### 2. Rate Limiting
Add to your backend before deployment:
```javascript
const rateLimit = require('express-rate-limit');
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100 // limit each IP to 100 requests per windowMs
});
app.use('/api/', limiter);
```

### 3. Security Headers
Already configured with Helmet.js in your code ✅

### 4. Monitoring
Consider adding:
- Error tracking: Sentry
- Uptime monitoring: UptimeRobot
- Performance: New Relic or Datadog

### 5. Custom Domain (Optional)
**For Backend (Render):**
1. Buy domain (GoDaddy, Namecheap, etc.)
2. Go to Render service settings
3. Add custom domain
4. Update DNS records

**For Frontend (Vercel):**
1. Go to project settings
2. Click "Domains"
3. Add your domain
4. Point DNS to Vercel

---

## 📝 Quick Reference

### Key URLs After Deployment
- Frontend: `https://krishisarthi-frontend.vercel.app`
- Backend: `https://krishisarthi-backend.onrender.com`
- Backend API Health: `https://krishisarthi-backend.onrender.com/api/health`
- MongoDB Atlas: `https://cloud.mongodb.com`

### Important Environment Variables
```
Backend (Render):
- MONGODB_URI
- JWT_SECRET
- GOOGLE_GENAI_API_KEY
- OPENAI_API_KEY
- GROK_API_KEY
- CORS_ORIGIN (your Vercel URL)

Frontend (Vercel):
- REACT_APP_API_URL (your Render URL)
```

---

## ✅ Final Checklist

- [ ] MongoDB Atlas cluster created
- [ ] MongoDB user created
- [ ] Network access configured
- [ ] Connection string saved
- [ ] Backend pushed to GitHub
- [ ] Frontend pushed to GitHub
- [ ] Backend deployed on Render
- [ ] Backend environment variables set
- [ ] Backend redeploy triggered (for CORS)
- [ ] Frontend deployed on Vercel
- [ ] Frontend environment variables set
- [ ] CORS_ORIGIN updated on backend
- [ ] Backend URL set in frontend
- [ ] API health endpoint works
- [ ] Frontend can call API
- [ ] No CORS errors
- [ ] Login works
- [ ] Data fetching works
- [ ] App is fully functional

---

## 🎉 Done!

Your application is now live with:
- **Backend:** Running on Render
- **Frontend:** Running on Vercel
- **Database:** MongoDB Atlas

Both services will automatically redeploy when you push to GitHub. Enjoy!

---

**Estimated time to complete: 45 minutes**
**Deployment cost: FREE (for both Render and Vercel free tiers)**
