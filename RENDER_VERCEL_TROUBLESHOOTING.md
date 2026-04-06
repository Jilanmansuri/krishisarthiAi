# 🔧 Render + Vercel Deployment - Troubleshooting & FAQ

Complete troubleshooting guide with solutions for common issues.

---

## 🚨 Emergency Troubleshooting

### My App is Completely Down

**Step 1: Check Service Status**
```
Render: https://render.com/dashboard
Vercel: https://vercel.com/dashboard
```
- Green checkmark = service running
- Red X = service down or deploying

**Step 2: Check Logs**
**Render:**
1. Click service name
2. Click "Logs" tab
3. Look for red error messages

**Vercel:**
1. Click project name
2. Go to "Deployments"
3. Click latest deployment
4. Scroll down to see build logs

**Step 3: Common Quick Fixes**
- Restart service (Render: Settings → Restart)
- Redeploy (Vercel: Deployments → Redeploy)
- Check environment variables are set
- Check MongoDB is accessible

---

## ❌ "Backend Service Failed to Deploy"

### Error: Build failed

**Solutions by Error Type:**

#### "npm: command not found"
- Node.js not installed in container
- Render should handle this automatically
- Check Node version in package.json

**Fix:**
```json
{
  "engines": {
    "node": ">=18.0.0"
  }
}
```

#### "Cannot find module 'express'"
- Missing dependencies
- package.json might be incomplete

**Check:**
1. `backend/package.json` has all dependencies
2. Run locally: `npm install`
3. If new packages added, commit and push
4. Render will auto-rebuild

#### "ENOENT: no such file or directory"
- File path is wrong in start command
- Start command: `node backend/server.js`
- Only use this exact path

**Verify:**
- Backend code is in `backend/` folder
- `server.js` exists in `backend/` folder
- Path in start command matches exactly

### Error: Port already in use
- Make sure code uses PORT env variable
- In your server.js:
```javascript
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {...});
```

---

## ❌ "Frontend Deployment Failed"

### Error: Build failed

#### "Module not found"
- React dependency missing
- Or incorrect import path

**Check:**
1. `frontend/package.json` has React
2. All imports use correct paths
3. No circular dependencies

**Fix:**
```bash
cd frontend
npm install
# Check for errors
npm run build
```

#### "Cannot find build output"
- Build directory doesn't exist
- build command didn't run

**Fix:**
- Make sure build command: `npm run build`
- React build creates `build/` folder
- Vercel deploys contents of build folder

#### "Out of memory during build"
- Large frontend build

**Fix:**
- Optimize images
- Remove unused dependencies
- Split code into smaller chunks

---

## 🔴 "API Calls Return Error"

### Browser Console: "CORS error"
```
Access to XMLHttpRequest blocked by CORS
```

**7-Step Fix:**

**Step 1:** Verify Backend URL in Frontend
- Vercel → Project Settings → Environment Variables
- Check `REACT_APP_API_URL` is correct
- Example: `https://krishisarthi-backend.onrender.com`
- ⚠️ NO trailing slash: ❌ `...onrender.com/`
- ⚠️ NO /api path: ❌ `...onrender.com/api`

**Step 2:** Check Backend CORS Config
- Render → Backend service → Environment
- Find `CORS_ORIGIN`
- Should be: `https://krishisarthi-frontend.vercel.app`
- ⚠️ Must include full URL with https://

**Step 3:** Restart Backend Service
- Render → Backend service → Settings
- Click "Restart service"
- Wait 1-2 minutes

**Step 4:** Clear Browser Cache
- DevTools (F12) → Settings (gear icon)
- Check "Disable cache (while DevTools open)"
- Refresh page (Ctrl+R or Cmd+R)

**Step 5:** Check Actual Backend Response
Open in browser:
```
https://krishisarthi-backend.onrender.com/api/health
```
Should show JSON response (no errors)

**Step 6:** Check Network requests
- DevTools → Network tab
- Make API request from Frontend
- Look at request:
  - URL correct?
  - Method correct (GET/POST)?
  - Headers included?
- Look at response:
  - Status code (200 = good, 5xx = server error)
  - Response body shows error message?

**Step 7:** Verify Environment Variables
Both services need correct vars:

**Render Backend:**
- MONGODB_URI ✓
- JWT_SECRET ✓
- All API keys ✓
- CORS_ORIGIN ✓

**Vercel Frontend:**
- REACT_APP_API_URL ✓

---

### API Returns "500 Internal Server Error"

**Causes:**
- Backend code error
- Database connection issue
- Missing environment variable
- Exception in request handler

**Debug:**

**Step 1:** Check Render Logs
```
Render → Backend service → Logs
```
Look for error message at time of request

**Step 2:** Check Database Connection
- Verify MONGODB_URI is correct
- Check MongoDB Atlas:
  - Cluster is "Available" (not paused)
  - Network access includes 0.0.0.0/0
  - User `krishisarthi` exists
  - Password in connection string is correct

**Step 3:** Test with cURL
```bash
curl https://krishisarthi-backend.onrender.com/api/health
```
If this works, API is responding

**Step 4:** Check Specific Endpoint
```bash
curl https://krishisarthi-backend.onrender.com/api/recommendations/get
```
If returns 500, endpoint has error

**Step 5:** Look at Code
Search for console.log statements in logs
May show what's failing

---

### API Returns "404 Not Found"

**Cause:** Endpoint doesn't exist

**Solutions:**

**Check Endpoint in Backend:**
1. Make sure route exists in `backend/routes/`
2. Route is registered in `server.js`
3. Example:
```javascript
app.use('/api/recommendations', recommendationRoute);
```

**Verify Endpoint Name:**
Frontend requesting: `GET /api/recommendations/get`
Backend providing: Same exact path?

**Test Endpoint:**
```bash
curl https://krishisarthi-backend.onrender.com/api/recommendations/get
```

---

### API Returns "401 Unauthorized"

**Cause:** Authentication failed

**Solutions:**

**Check JWT Token:**
- Is token being sent?
- Is token valid?
- Did JWT_SECRET change?

**Regenerate JWT:**
On Render:
1. Backend service → Environment
2. Edit `JWT_SECRET`
3. Save (service redeploys)
4. Users will need to login again

---

## 🔴 "MongoDB Connection Error"

### MongoNetworkError: connection timeout

**Root Causes:**
1. Wrong connection string
2. Wrong username/password
3. Network access not configured
4. Cluster paused
5. Render IP not whitelisted

**Fix in Order:**

**Step 1:** Verify Connection String Format
```
mongodb+srv://krishisarthi:PASSWORD@cluster0.mongodb.net/krishiai?retryWrites=true&w=majority
```

- [ ] `krishisarthi` is correct username
- [ ] `PASSWORD` is your actual password (URL-encoded if special chars)
- [ ] `cluster0` matches your cluster name (check MongoDB Atlas)
- [ ] No typos in `mongodb.net`

**Step 2:** Check MongoDB Atlas Network Access
1. MongoDB Atlas → Network Access
2. Should show "Allow access from anywhere" (0.0.0.0/0)
3. Status: "Active"
4. If missing, click "Add IP Address" → "Allow access from anywhere"

**Step 3:** Verify Cluster is Running
1. MongoDB Atlas → Databases
2. Your cluster shows "Available" (green checkmark)
3. If paused, click "Resume"

**Step 4:** Test Connection Locally
```bash
mongosh "mongodb+srv://krishisarthi:PASSWORD@cluster0.mongodb.net/krishiai"
```
If works locally, issue is with Render IP

**Step 5:** Restart Backend Service
- Render → Settings → Restart service
- Sometimes helps with connection pool issues

**Step 6:** Check Password
- Verify exact password used
- If unsure, reset in MongoDB Atlas:
  1. Database Access → Edit user
  2. Update password
  3. Update in Render environment variables
  4. Restart backend

---

### "Authentication failed" Error

**Causes:**
1. Wrong username
2. Wrong password
3. Special characters in password not URL-encoded
4. Cluster requires IP whitelist

**URL Encoding Special Characters:**
```
@ → %40
# → %23
$ → %24
% → %25
& → %26
: → %3A
/ → %2F
```

**Example:**
```
Password: my$pass@word
URL-encoded: my%24pass%40word

Connection string:
mongodb+srv://krishisarthi:my%24pass%40word@cluster0.mongodb.net/krishiai
```

---

## 🟠 "Service Keeps Restarting"

### Backend keeps crashing

**Causes:**
- Unhandled exception
- Out of memory
- Port issue
- Database crash

**Fix:**

**Step 1:** Check Logs
- Render → Logs
- Look for crash message

**Step 2:** If memory issue
- Render free tier has 512MB RAM
- Check if app uses less memory
- Upgrade to paid plan if needed

**Step 3:** If port issue
- Make sure code uses PORT env var
- Don't hardcode port 5000

**Step 4:** Check for infinite loops
- Search code for `while(true)` or similar
- Look for recursive calls without exit

---

## 🟡 "Page Loads But API Calls Fail"

**Scenario:** Frontend works, but can't fetch data

**Step 1:** Verify You're Calling Correct Endpoint
Check frontend code:
```javascript
fetch(process.env.REACT_APP_API_URL + '/api/recommendations')
```

Verify endpoint exists on backend

**Step 2:** Check Environment Variable
- Vercel → Environment Variables
- `REACT_APP_API_URL` must be set
- Must be URL (no trailing slash)
- If changed, redeploy needed

**Step 3:** Check Network Tab
- DevTools → Network tab
- Click on failing API request
- Check:
  - URL: Is it correct?
  - Headers: Any auth token?
  - Response: What's the error?

**Step 4:** Test Endpoint Directly
```bash
curl https://krishisarthi-backend.onrender.com/api/endpoint-name
```

---

## 🟡 "Files Not Updating After Push"

### Changes to code don't appear

**Frontend (Vercel):**
1. Check git push was successful
2. Go to Vercel → Deployments
3. See if new deployment started
4. Check build logs
5. Wait for deployment to complete (2-3 min)
6. Hard refresh browser (Ctrl+Shift+R)
7. Check browser console

**Backend (Render):**
1. Check git push was successful
2. Go to Render → Dashboard
3. Click service → Logs
4. See if new deployment started
5. Check for build errors
6. Wait for deployment complete (1-2 min)

**If Still Not Working:**
- Clear browser cache completely
- Update environment variables if needed
- Manually trigger redeploy (Vercel or Render dashboard)

---

## ✅ Verification Checklist

### Before Saying "It's Broken"

- [ ] I can see the service in dashboard (Render/Vercel)
- [ ] Deployment completed (no red X)
- [ ] I waited 2-3 minutes after push
- [ ] I cleared browser cache (Ctrl+Shift+Delete)
- [ ] I checked environment variables are set
- [ ] I checked logs for error messages
- [ ] I tested with curl: `curl https://...`
- [ ] I verified URLs in code are correct
- [ ] I checked MongoDB Atlas is accessible

---

## 🆘 Still Broken? Debug Checklist

### 1. Isolate the Issue
**Is it Frontend?**
- Can you see the React app in browser?
- Does page load?

**Is it Backend?**
- Can you curl the health endpoint?
- Does it respond?

**Is it Database?**
- Can you connect locally with same connection string?
- Is MongoDB Atlas cluster running?

### 2. Gather Information
- [ ] Error message (full text if possible)
- [ ] URL where error happens
- [ ] Logs from Render/Vercel
- [ ] Browser console errors
- [ ] Network tab (failed requests)

### 3. Check Obvious Things
- [ ] Is service showing as running (green)?
- [ ] Are all environment variables set?
- [ ] Did I wait 2-3 minutes after deployment?
- [ ] Did I hard-refresh browser?

### 4. Restart Everything
```bash
# Render: Click Restart service
# Vercel: Click Redeploy
# Browser: Hard refresh (Ctrl+Shift+R)
# MongoDB: Check if paused (Resume if so)
```

### 5. Check Logs Line by Line
- Render logs show exact errors
- Vercel logs show build issues
- Browser console shows frontend errors

---

## 📞 Getting More Help

### Documentation Files
- [RENDER_DEPLOYMENT_GUIDE.md](./RENDER_DEPLOYMENT_GUIDE.md)
- [VERCEL_DEPLOYMENT_GUIDE.md](./VERCEL_DEPLOYMENT_GUIDE.md)
- [MONGODB_ATLAS_SETUP.md](./MONGODB_ATLAS_SETUP.md)
- [DEPLOY_RENDER_VERCEL.md](./DEPLOY_RENDER_VERCEL.md)

### External Resources
- **Render Docs:** https://render.com/docs
- **Vercel Docs:** https://vercel.com/docs
- **MongoDB Docs:** https://docs.mongodb.com
- **Node.js Docs:** https://nodejs.org/docs
- **React Docs:** https://react.dev

### Stack Overflow
Search: `error message + rendering + 2024`

---

## ✨ Common Solutions Summary

| Problem | Solution | Time |
|---------|----------|------|
| CORS error | Update CORS_ORIGIN on Render | 2 min |
| 404 endpoint | Check route exists in backend | 5 min |
| MongoDB timeout | Check network access (0.0.0.0/0) | 2 min |
| Page blank | Clear cache + hard refresh | 1 min |
| API doesn't respond | Check backend health endpoint | 3 min |
| Deployment failed | Check build logs | 5 min |
| No updates after push | Wait 2-3 min, hard refresh | 1 min |
| 500 error | Check Render logs | 5 min |

---

**Remember:** Most issues are caused by:
1. Wrong environment variables
2. CORS configuration
3. MongoDB connection
4. Not waiting for deployment
5. Not refreshing browser cache

**Check these first!** ✅
