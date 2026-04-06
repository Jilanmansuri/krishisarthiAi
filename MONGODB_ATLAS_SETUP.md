# 🎯 MongoDB Atlas - Complete Setup Guide

Step-by-step guide with screenshots descriptions for setting up MongoDB Atlas.

---

## Step 1: Create Account

### 1.1 Go to MongoDB Atlas
- URL: https://www.mongodb.com/cloud/atlas
- Click **"Start Free"** button (green, top-right)

### 1.2 Sign Up
- **Option A:** Click "Continue with Google" → Select your Google account
- **Option B:** Click "Continue with GitHub" → Authorize access
- **Option C:** Fill email and password → Click "Sign up"

### 1.3 Accept Terms
- Check "I agree to the terms of service"
- Click "Create account"

### 1.4 Verify Email (if needed)
- Check your email inbox
- Click verification link
- Return to MongoDB website

---

## Step 2: Create Organization & Project

### 2.1 Create Organization
After login, you'll see "Create an organization":
- **Organization Name:** `KrishiSarthi-Org` (or your choice)
- Click **"Create Organization"**

### 2.2 Create Project
You'll be prompted to create a project:
- **Project Name:** `krishisarthi-project`
- Click **"Create Project"**

---

## Step 3: Build Your Cluster

### 3.1 Start Free Cluster
- Click **"Build a Database"** button (big blue button)
- Select **"Create"** under FREE tier (M0)

### 3.2 Choose Provider & Region
- **Cloud Provider:** AWS (default is fine)
- **Region:** Choose closest to you
  - Asia: Singapore, Tokyo
  - Europe: Frankfurt, Ireland
  - US: Virginia, Oregon
  - Other: Choose nearest
- Click **"Create Cluster"**

### 3.3 Wait for Cluster
- Shows "Cluster being created..."
- Wait 5-10 minutes
- Refresh page if needed
- Status changes to "Available"

---

## Step 4: Create Admin User

### 4.1 Access Database Access
- Click **"Database Access"** (left sidebar)
- Click **"Add New Database User"** (green button)

### 4.2 Fill User Details
- **Authentication Method:** Password
- **Username:** `krishisarthi`
- **Password:** Create strong password
  - Use mix of uppercase, lowercase, numbers, special chars
  - Example: `MySecure$Pass123!`
  - **SAVE THIS PASSWORD!** You'll need it later

### 4.3 Role Assignment
- **Built-in Role:** `Atlas Admin`
- Click **"Add User"**

---

## Step 5: Allow Network Access

### 5.1 Go to Network Access
- Click **"Network Access"** (left sidebar - under Security)
- Click **"Add IP Address"** (green button)

### 5.2 Add Access Rule
- Click **"Allow access from anywhere"** (or enter 0.0.0.0/0)
- Confirm message
- Click **"Confirm"**

Status: Shows your IP is added

---

## Step 6: Get Database Connection String

### 6.1 Go to Databases
- Click **"Databases"** (left sidebar)
- You see your cluster (e.g., "Cluster0")

### 6.2 Click Connect
- Click **"Connect"** button next to your cluster
- Modal appears with connection options

### 6.3 Select Drivers
- In modal, click **"Drivers"** tab (or option)
- Select **"Node.js"** from drivers list
- Version: Latest (should be automatic)

### 6.4 Copy Connection String
- You see code like:
```
mongodb+srv://<username>:<password>@cluster0.mongodb.net/?retryWrites=true&w=majority
```

### 6.5 Replace Placeholders
Replace the following in the string:
- `<username>` → `krishisarthi`
- `<password>` → Your password from Step 4.2

### 6.6 Add Database Name
After `.net/` add database name: `/krishiai`

**Final Connection String Example:**
```
mongodb+srv://krishisarthi:MySecure$Pass123!@cluster0.mongodb.net/krishiai?retryWrites=true&w=majority
```

**⚠️ IMPORTANT:**
- Make sure password has no special characters that need encoding
- If password has special chars, URL-encode them:
  - `@` → `%40`
  - `#` → `%23`
  - `$` → `%24`
  - `/` → `%2F`
  - `:` → `%3A`

---

## Step 7: Verify Connection (Optional)

### 7.1 Test Connection
Go to "Deployment" and click your cluster name
- Status shows "Available" (green checkmark)
- You can see cluster metrics

### 7.2 Collections
- Click **"Collections"** tab
- Initially shows "Create a database"
- Once you run app and insert data, collections will appear

---

## 🔐 Security Notes

### What You've Set Up
✅ Database: `krishiai`
✅ User: `krishisarthi` (with Admin role)
✅ Network: Open from anywhere
✅ Free Tier: 512MB storage

### For Production
- Limit network access to app IP
- Create limited-role users for app
- Enable backup (automatic on free tier)
- Monitor cluster usage
- Set up alerts

---

## Connection String Format

### Always Check Format
```
mongodb+srv://<username>:<password>@<cluster>.mongodb.net/<database>?retryWrites=true&w=majority
```

### Key Parts
- `mongodb+srv://` → Connection method (SRV record)
- `<username>:<password>` → Auth credentials
- `@<cluster>.mongodb.net` → Cluster address
- `/<database>` → Database name
- `?retryWrites=true&w=majority` → Connection options

### Your String Should Look Like
```
mongodb+srv://krishisarthi:[password]@cluster0.mongodb.net/krishiai?retryWrites=true&w=majority
```

---

## Troubleshooting

### Can't Sign Up
- Check email for verification link
- Use different browser if signing up fails
- Try GitHub login instead

### Cluster Creation Takes Too Long
- Cluster usually takes 3-10 minutes
- Refresh page
- Check cluster status
- If stuck > 15 min, contact MongoDB support

### Can't Connect (Connection Timeout)
**Solution 1:** Check Network Access
- Verify IP address is added (0.0.0.0/0)
- Verify status shows "Active"

**Solution 2:** Check Connection String
- Verify username and password are correct
- Verify database name is included
- Check for special characters that need encoding

**Solution 3:** Verify Credentials
- Right username? `krishisarthi`
- Right password? Check if you saved it correctly
- Database name included? `krishiai`

### "Authentication failed"
- Re-check username: should be `krishisarthi`
- Re-check password: exactly as you created it
- If special chars in password, ensure they're URL-encoded

---

## ✅ Completion Checklist

- [ ] Created organization
- [ ] Created project
- [ ] Created cluster (FREE tier M0)
- [ ] Cluster is "Available"
- [ ] Created user `krishisarthi`
- [ ] Saved password safely
- [ ] Added network access (0.0.0.0/0)
- [ ] Got connection string
- [ ] Replaced username and password in string
- [ ] Added database name `/krishiai`
- [ ] Connection string is ready: `mongodb+srv://...`

---

## Next Steps

Now go to: **DEPLOY_RENDER_VERCEL.md** → **Part 3: Deploy Backend on Render**

Use this connection string as `MONGODB_URI` environment variable on Render.
