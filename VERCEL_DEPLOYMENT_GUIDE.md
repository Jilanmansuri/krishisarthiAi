# 🔵 Vercel Frontend Deployment - Visual Guide

Complete step-by-step guide with exact button locations and screenshots descriptions.

---

## Prerequisites
- [ ] Frontend code pushed to GitHub (in `frontend/` folder)
- [ ] Backend URL from Render deployment
- [ ] GitHub account with repository access
- [ ] Vercel account

---

## Step 1: Create Vercel Account

### 1.1 Go to Vercel
- URL: https://vercel.com
- Click **"Sign Up"** (top right)

### 1.2 Sign Up with GitHub
- Click **"Continue with GitHub"** button
- GitHub asks for authorization
- Click **"Authorize vercel"**
- You're redirected to Vercel dashboard

### 1.3 Skip Tutorial (Optional)
- Tutorial popup may appear
- Click **"Skip"** or follow through
- Go to **"Dashboard"**

---

## Step 2: Import Project

### 2.1 Import from Git
- On Dashboard, click **"New Project"** button (top right)
- Select **"Import Git Repository"**

### 2.2 Search for Repository
- Search box appears
- Type: `krishisarthiAi`
- Your repository appears in results
- Click **"Select"** button next to it
- Or just click on repo name

### 2.3 Configure Import
- Dashboard shows your repo name
- Vercel auto-detects React project
- Shows "Framework Preset: React"
- Root Directory shows: `./frontend` (or verify it's correct)

---

## Step 3: Configure Build Settings

### 3.1 Framework Preset
- Should already show: **"React"**
- If not, click dropdown and select React

### 3.2 Root Directory
- Shows: `./frontend`
- This is correct ✓
- If different, click and change to `./frontend`

### 3.3 Build and Output Settings
- **Build Command:** `npm run build`
  - (Vercel auto-fills this)
- **Output Directory:** `build`
  - (Should auto-fill)
- Leave these as default

### 3.4 Environment Variables

**IMPORTANT:** Add before deploying!

Click **"Environment Variables"** section

#### Add Variable 1: REACT_APP_API_URL
- **Name:** `REACT_APP_API_URL`
- **Value:** Your Render backend URL
  - Example: `https://krishisarthi-backend.onrender.com`
  - ⚠️ DO NOT include trailing slash
  - ⚠️ DO NOT include `/api` at end
- Click **"Add"** button

**Verify the URL:**
- No trailing slash: ❌ `https://krishisarthi-backend.onrender.com/`
- No /api: ❌ `https://krishisarthi-backend.onrender.com/api`
- Correct: ✅ `https://krishisarthi-backend.onrender.com`

### 3.5 Production/Preview/Development
- Shows three environment settings
- For "Production": Select "All" or specific deployments
- Keep defaults (usually "All")

---

## Step 4: Deploy

### 4.1 Review Settings
- Scroll to bottom
- Verify all settings:
  - Project name ✓
  - Framework: React ✓
  - Root directory: `./frontend` ✓
  - Environment variable added: ✓

### 4.2 Click Deploy
- Click **"Deploy"** button (blue, bottom right)
- Shows: "Creating deployment..."

### 4.3 Wait for Deployment
- Progress shows:
  - ✓ Building
  - ✓ Installing dependencies
  - ✓ Creating build
  - ✓ Uploading builds
- Deployment takes 2-3 minutes

### 4.4 Deployment Complete
- Shows: "Congratulations!"
- "Your project has been successfully deployed"
- Displays your frontend URL: `https://krishisarthi-frontend.vercel.app`

**📝 SAVE THIS URL!** You need it for updating backend CORS.

---

## Step 5: Verify Frontend is Deployed

### 5.1 Visit Your App
- Click **"Visit"** button on success screen
- Or manually visit: `https://krishisarthi-frontend.vercel.app`
- Your React app loads

### 5.2 Check for Errors

**In Browser:**
1. Open browser DevTools (F12)
2. Click **"Console"** tab
3. Look for errors (red messages)

**Common errors:**
- CORS errors: `Access to XMLHttpRequest blocked by CORS`
  - Means backend URL might be wrong
  - Or backend not yet deployed
- 404 errors: API endpoints not found
  - Check backend URL in environment variable
  - Check backend is running

### 5.3 Test App Functionality
- Try clicking around app
- Try a feature that calls the API
- If app loads but API fails:
  - Check REACT_APP_API_URL in Vercel
  - Check backend service is running
  - Check CORS_ORIGIN on backend

---

## Step 6: Update Frontend Environment (If Needed)

If you need to change the backend URL:

### 6.1 Go to Settings
- Dashboard → Click project name
- Click **"Settings"** in top menu
- Left sidebar → **"Environment Variables"**

### 6.2 Edit Variable
- Find `REACT_APP_API_URL`
- Click edit icon (pencil)
- Update value
- Click **"Save"**

### 6.3 Redeploy
- Dashboard shows banner: "Environment variable changed"
- Click **"Redeploy"** or go to Deployments tab
- click **"Redeploy"** on latest deployment
- Vercel rebuilds and redeploys

---

## Step 7: Test Frontend-Backend Connection

### 7.1 Use App Features
1. Go to your Vercel URL
2. Try login (if available)
3. Try fetching data (recommendations, soil info, etc.)
4. Check console for errors

### 7.2 If API Calls Fail

**Check 1: Backend is Running**
```bash
curl https://krishisarthi-backend.onrender.com/api/health
```
Should return JSON response

**Check 2: Backend URL is Correct**
- Vercel Settings → Environment Variables
- Verify `REACT_APP_API_URL` matches your backend URL
- No extra slashes or typos

**Check 3: CORS is Configured**
- Render dashboard → backend service → Environment
- Check `CORS_ORIGIN=https://krishisarthi-frontend.vercel.app`
- If not, update it and restart backend

**Check 4: API Routes Exist**
- Check backend has the API route you're calling
- Example: `/api/recommendations/get`
- Visit: `https://your-backend.com/api/recommendations/get`

---

## Step 8: Setup Auto-Deployment

Vercel automatically redeploys when you push to GitHub! 

### 8.1 Verify Auto-Deployment
- Go to **"Deployments"** tab
- Each push to GitHub triggers new deployment
- Watch as it builds and deploys

### 8.2 Disable Auto-Deployment (Optional)
If you want manual control:
1. Click **"Settings"**
2. Left sidebar → **"Git"**
3. Turn off **"Automatic Deployments"**
4. Now only deploy when you click "Redeploy"

---

## 🎯 Verification Checklist

- [ ] Project imported from GitHub
- [ ] Framework: React detected
- [ ] Root directory: `./frontend`
- [ ] Environment variable added: `REACT_APP_API_URL`
- [ ] Backend URL in env variable (no trailing slash, no /api)
- [ ] Deployment completed successfully
- [ ] Frontend URL: `https://krishisarthi-frontend.vercel.app`
- [ ] App loads in browser
- [ ] No 404 errors in console
- [ ] API calls work (minimal errors)

---

## Common Issues & Fixes

### Issue: "Deployment failed"
**Check:**
- Build command: `npm run build`
- All dependencies installed on backend
- No syntax errors
- `frontend/package.json` exists

**Fix:**
1. Check build logs (shows in Vercel)
2. Look for specific error message
3. Fix in code locally
4. Push to GitHub
5. Vercel auto-redeploys

### Issue: "Blank white screen"
**Causes:**
- Build failed
- React not loading
- Console errors

**Fix:**
1. Check browser console (F12 → Console)
2. Look for JavaScript errors
3. Check Vercel logs
4. May need to rebuild

### Issue: "Cannot GET /"
**Cause:** React build not configured

**Fix:**
- Check Vercel detected React framework
- Verify root directory: `./frontend`
- Check `frontend/public/index.html` exists
- Rebuild if needed

### Issue: "CORS error in console"
```
Access to XMLHttpRequest blocked by CORS
```

**Fix steps:**
1. **Verify backend URL:**
   - Render service → Environment
   - Check `CORS_ORIGIN=https://krishisarthi-frontend.vercel.app`
   - Must match exactly (with https://)
   - No trailing slash

2. **Restart backend:**
   - Render service → Settings
   - Click "Restart service"
   - Wait 1-2 minutes

3. **Verify frontend URL:**
   - Vercel → Environment Variables
   - Check `REACT_APP_API_URL` is correct backend URL
   - Rebuild: Deployments → Redeploy

4. **Clear browser cache:**
   - Open DevTools (F12)
   - Right-click refresh button
   - Click "Empty cache and hard refresh"

### Issue: "API returns 500 error"
**Causes:**
- Backend error
- Missing environment variable
- Database issue

**Fix:**
1. Check Render service logs
2. Check MongoDB is accessible
3. Verify all API keys are set
4. Restart backend service

### Issue: "Cannot connect to database"
**Fix:**
- Render Environment → Check MONGODB_URI
- MongoDB Atlas → Verify network access (0.0.0.0/0)
- Check credentials in connection string
- Verify cluster is "Available"

---

## Next Steps

1. **Frontend is now live!** 🎉
2. Go back to: **RENDER_DEPLOYMENT_GUIDE.md** → **Step 7**
3. Update backend CORS_ORIGIN with your Vercel URL
4. Test that frontend-backend communication works

---

## Automatic Deployments

### What Happens Next
Every time you push to GitHub:
```bash
git add frontend/
git commit -m "Update frontend"
git push origin main
```

Vercel automatically:
1. Detects the push
2. Builds the project
3. Runs tests (if configured)
4. Deploys new version
5. Available within 2-3 minutes

---

## Viewing Deployments

### Check Deployment Status
1. Dashboard → Your project
2. Click **"Deployments"** tab
3. See all deployments with timestamps
4. Green checkmark = successful
5. Click deployment to see details

---

## Custom Domain (Optional)

### Add Your Own Domain
1. Settings → **"Domains"**
2. Click **"Add Domain"**
3. Enter your domain
4. Follow DNS setup instructions
5. Usually works within 48 hours

---

**Deployment time: 3-5 minutes**
**Cost: FREE (Vercel free tier)**

---

**Congratulations! Your app is now fully deployed!** 🚀
