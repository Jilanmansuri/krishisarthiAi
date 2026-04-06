# 🟡 Render Backend Deployment - Visual Guide

Complete step-by-step guide with exact button locations and screenshots descriptions.

---

## Prerequisites
- [ ] Backend code pushed to GitHub (in `backend/` folder)
- [ ] MongoDB connection string ready
- [ ] All API keys ready
- [ ] GitHub account with repository access
- [ ] Render account

---

## Step 1: Create Render Account

### 1.1 Go to Render
- URL: https://render.com
- Click **"Get Started"** or **"Sign Up"** (top right)

### 1.2 Sign Up with GitHub
- Click **"Sign up with GitHub"** button
- GitHub will ask for authorization
- Click **"Authorize render-oss"**
- You're redirected to Render dashboard

### 1.3 Accept Defaults
- Welcome message appears
- You can skip the tutorial
- Go to **"Dashboard"**

---

## Step 2: Connect GitHub Repository

### 2.1 Create Web Service
- On Dashboard, click **"New +"** button (top right)
- Select **"Web Service"** from dropdown

### 2.2 Select Repository
- Click **"Connect a repository"** button
- Search for: `krishisarthiAi`
- You should see your GitHub repo
- Click **"Connect"** button next to the repo

---

## Step 3: Configure Deployment Settings

### 3.1 Basic Settings
**Name:** 
- Enter: `krishisarthi-backend`
- (This becomes part of your URL)

**Region:**
- Select closest region to your users
- Options: Singapore, Japan, US, Europe, etc.
- Click dropdown to see all options

**Branch:**
- Should auto-fill: `main`
- If different, change to `main`

### 3.2 Build Command
- **Runtime:** Should default to `Node`
- **Build Command:** 
  ```
  npm install
  ```
- Leave as is (Render auto-detects)

### 3.3 Start Command
- This is IMPORTANT
- Enter: 
  ```
  node backend/server.js
  ```
- This tells Render where your main file is

---

## Step 4: Add Environment Variables

### 4.1 Scroll to Environment Section
- Look for **"Environment"** section (below Build/Start commands)
- Click **"Add Environment Variable"** button

### 4.2 Add Variables One by One

**Variable 1: NODE_ENV**
- Key: `NODE_ENV`
- Value: `production`
- Click **"Add"** or press Enter

**Variable 2: PORT**
- Key: `PORT`
- Value: `5000`
- Click **"Add"**

**Variable 3: MONGODB_URI**
- Key: `MONGODB_URI`
- Value: Your connection string from MongoDB Atlas
  ```
  mongodb+srv://krishisarthi:PASSWORD@cluster0.mongodb.net/krishiai?retryWrites=true&w=majority
  ```
- Make sure password is URL-encoded
- Click **"Add"**

**Variable 4: JWT_SECRET**
- Key: `JWT_SECRET`
- Value: Generate strong random string
  - Windows: Use online generator like https://www.random.org
  - Linux/Mac: Run `openssl rand -base64 32`
  - Example: `zB4xK9pL2mN5qR8sT1vW3xY6zAc4dEf7gHj0kLm9nO2p`
- Click **"Add"**

**Variable 5: GOOGLE_GENAI_API_KEY**
- Key: `GOOGLE_GENAI_API_KEY`
- Value: Your Google GenAI key (from https://ai.google.dev)
- Click **"Add"**

**Variable 6: OPENAI_API_KEY**
- Key: `OPENAI_API_KEY`
- Value: Your OpenAI key (from https://platform.openai.com)
- Click **"Add"**

**Variable 7: GROK_API_KEY**
- Key: `GROK_API_KEY`
- Value: Your Grok key (from https://api.x.ai)
- Click **"Add"**

**Variable 8: CORS_ORIGIN**
- Key: `CORS_ORIGIN`
- Value: `*` (for now, we'll update this after Vercel deployment)
- Or: `https://localhost:3000` (for testing)
- Click **"Add"**

### 4.3 Verify All Variables
- Scroll through Environment section
- Verify all 8 variables are there
- Check none are hidden/marked as error

---

## Step 5: Deploy

### 5.1 Review Summary
- Scroll to bottom
- Review settings:
  - Name: `krishisarthi-backend` ✓
  - Region: Your chosen region ✓
  - Build Command: `npm install` ✓
  - Start Command: `node backend/server.js` ✓
  - Environment variables: All 8 added ✓

### 5.2 Click Deploy
- Click **"Create Web Service"** button (blue, bottom right)

### 5.3 Wait for Deployment
- Shows: "Creating Service..."
- Progress bar fills up
- Log appears showing build steps
- Wait 3-5 minutes

### 5.4 Deployment Complete
- Green checkmark appears
- Shows: "Your service is live"
- URL displays: `https://krishisarthi-backend.onrender.com`

**📝 SAVE THIS URL!** You'll need it for Vercel.

---

## Step 6: Verify Backend is Running

### 6.1 Test Health Endpoint
Open in browser or using curl:
```bash
curl https://krishisarthi-backend.onrender.com/api/health
```

Should return:
```json
{"status":"Server is running","timestamp":"2024-01-15T10:30:45.123Z"}
```

### 6.2 Check Logs
If health check fails:
1. Go to Render Dashboard
2. Click on `krishisarthi-backend` service
3. Click **"Logs"** tab
4. Look for error messages
5. Common errors:
   - "Cannot find module": Missing dependency
   - "MongoNetworkError": MongoDB connection issue
   - "ENOENT": File path issue

### 6.3 Troubleshoot Issues

**If you see MongoDB error:**
- Check MONGODB_URI is correct
- Check password is URL-encoded
- Verify MongoDB Atlas network access is open

**If you see "Cannot find module":**
- Check `backend/package.json` has all dependencies
- Run `npm install` locally to verify
- Push to GitHub if you added dependencies

**If you see port error:**
- Check Start Command is: `node backend/server.js`
- Check server.js correctly uses PORT env variable
- Look in code: `const PORT = process.env.PORT || 5000`

---

## Step 7: Update Backend CORS (Later)

After you deploy frontend on Vercel, you'll return here to:
1. Click on service
2. Go to "Environment"
3. Edit `CORS_ORIGIN`
4. Change value to: `https://your-vercel-url.vercel.app`
5. Click "Save"
6. Service auto-redeploys

---

## 🎯 Verification Checklist

- [ ] Service name: `krishisarthi-backend`
- [ ] Region: Selected
- [ ] Build Command: `npm install`
- [ ] Start Command: `node backend/server.js`
- [ ] Environment variables: All 8 present
- [ ] Deployment complete (green checkmark)
- [ ] Health endpoint works
- [ ] Logs show no errors
- [ ] Backend URL saved: `https://krishisarthi-backend.onrender.com`

---

## Common Issues & Fixes

### Issue: "Failed to build"
**Check:**
- `backend/package.json` exists
- All dependencies listed
- No syntax errors in code
- Node version requirement in package.json

**Fix:**
1. Check logs for specific error
2. Fix error in code
3. Push to GitHub
4. Render auto-redeploys

### Issue: "Service keeps crashing"
**Likely causes:**
- MongoDB connection fails
- Missing environment variable
- Port already in use
- Unhandled exception

**Fix:**
1. Check logs: `tail -f logs.txt`
2. Verify MONGODB_URI format
3. Verify all required env vars exist
4. Check code for errors

### Issue: "Health endpoint returns 404"
**Fix:**
- Verify start command: `node backend/server.js`
- Check server.js has `/api/health` route
- Restart service (click Restart button)

### Issue: "MongoNetworkError: connection timeout"
**Fix steps:**
1. Go to MongoDB Atlas
2. Check Network Access includes 0.0.0.0/0
3. Verify connection string format
4. Verify username and password
5. Check cluster is "Available" (not paused)

---

## Next Steps

1. **Save your backend URL** ← Important!
2. Go to: **DEPLOY_VERCEL_GUIDE.md** 
3. Deploy frontend on Vercel
4. Return here to update CORS_ORIGIN

---

**Deployment time: 5-10 minutes**
**Cost: FREE (Render free tier)**
