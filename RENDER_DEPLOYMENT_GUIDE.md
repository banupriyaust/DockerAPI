# 🚀 Render Deployment Instructions

## Your Production API Key
```
F226D6E68DF094313A7416A9F2AC9CBB
```
⚠️ **SAVE THIS KEY** - You'll need it in Step 5 below!

---

## Step-by-Step Deployment Guide

### ✅ Step 1: GitHub Code is Ready
Your code has been pushed to:
```
https://github.com/banupriyaust/DockerAPI
```

All changes are committed and pushed. ✓

---

### 📝 Step 2: Create Render Account
1. Go to https://render.com/
2. Click "Sign up" (or login if you have an account)
3. Choose authentication method (GitHub recommended)
4. Authorize Render to access your GitHub

---

### 🔗 Step 3: Create New Web Service
1. Click "New +" button in top right
2. Select "Web Service"
3. Click "Connect" next to your `banupriyaust/DockerAPI` repository
4. Click "Connect" on the popup

---

### ⚙️ Step 4: Configure Service Settings

Fill in the following details:

**Basic Settings:**
- **Name**: `dockerapi` (or any name you prefer)
- **Environment**: `Python 3`
- **Region**: Select closest to you (e.g., Frankfurt)
- **Branch**: `main`

**Build & Deployment:**
- **Build Command**: 
  ```
  pip install -r requirements.txt
  ```
- **Start Command**: 
  ```
  uvicorn app.main:app --host 0.0.0.0
  ```

**Instance Type:**
- **Free** (good for testing)

Click "Create Web Service"

---

### 🔐 Step 5: Add Environment Variable

1. In your Render dashboard, find your `dockerapi` service
2. Click on it to open the service page
3. Go to "Environment" tab (left sidebar)
4. Click "Add Environment Variable"
5. Fill in:
   - **Key**: `API_KEY`
   - **Value**: `F226D6E68DF094313A7416A9F2AC9CBB`

6. Click "Save" 
7. Service will auto-deploy with the new environment variable

---

### ⏳ Step 6: Wait for Deployment

Your Render service will now:
1. Build the Docker image
2. Install dependencies
3. Start the FastAPI server

Watch the "Logs" tab for deployment progress. You'll see:
```
Build started...
...
Uvicorn running on http://0.0.0.0:8000
```

Once complete, you'll see:
```
Service live at https://dockerapi-xxxxx.onrender.com
```

**This typically takes 2-5 minutes**

---

### ✅ Step 7: Test Your Deployed API

Once deployed, test these URLs in your browser:

**1. Public Endpoint (no auth)**
```
https://dockerapi-xxxxx.onrender.com/
```
Expected: Welcome JSON

**2. Health Check (no auth)**
```
https://dockerapi-xxxxx.onrender.com/health
```
Expected: `{"status": "healthy", "service": "DockerAPI"}`

**3. Protected Endpoint (with API key)**
```
https://dockerapi-xxxxx.onrender.com/secret?api_key=F226D6E68DF094313A7416A9F2AC9CBB
```
Expected: Secret message returned

**4. Protected Endpoint (invalid key)**
```
https://dockerapi-xxxxx.onrender.com/secret?api_key=wrong
```
Expected: `{"detail": "Invalid API key"}` (403 Forbidden)

---

## 📋 Quick Reference

| What | URL |
|------|-----|
| Your Service | https://dockerapi-xxxxx.onrender.com |
| Public endpoint | https://dockerapi-xxxxx.onrender.com/ |
| Secret endpoint | https://dockerapi-xxxxx.onrender.com/secret?api_key=F226D6E68DF094313A7416A9F2AC9CBB |
| Health check | https://dockerapi-xxxxx.onrender.com/health |

**Replace `xxxxx` with your actual Render service ID** (shown on your Render dashboard)

---

## 🧪 PowerShell Testing (After Deployment)

```powershell
# Set your service URL
$serviceUrl = "https://dockerapi-xxxxx.onrender.com"
$apiKey = "F226D6E68DF094313A7416A9F2AC9CBB"

# Test public endpoint
Invoke-WebRequest "$serviceUrl/" | Select-Object -ExpandProperty Content

# Test protected endpoint with valid key
Invoke-WebRequest "$serviceUrl/secret?api_key=$apiKey" | Select-Object -ExpandProperty Content

# Test health check
Invoke-WebRequest "$serviceUrl/health" | Select-Object -ExpandProperty Content
```

---

## 🔍 Troubleshooting

### Service won't start
- Check "Logs" tab in Render dashboard
- Verify Python dependencies in requirements.txt
- Check Start Command is correct

### 401 Unauthorized or 403 Forbidden
- Verify API_KEY environment variable is set on Render
- Check the value matches: `F226D6E68DF094313A7416A9F2AC9CBB`
- Clear browser cache and try again

### 502 Bad Gateway
- Service may still be deploying - wait 1-2 minutes
- Check Logs tab for errors
- Try redeploying by clicking "Trigger Deploy"

### Service keeps crashing
- Check Logs for error messages
- Verify all requirements are in requirements.txt
- Ensure app.main:app is the correct entry point

---

## 🔐 Security Reminders

✅ API Key saved securely on Render server  
✅ .env file not committed to GitHub  
✅ Use HTTPS only (Render provides this automatically)  
✅ Keep API key confidential - don't share publicly  

---

## ✨ You're All Set!

Once deployment completes, your API will be:
- ✅ Live on the internet
- ✅ Protected with API key authentication
- ✅ Running 24/7
- ✅ Using HTTPS

Your API key for production:
```
F226D6E68DF094313A7416A9F2AC9CBB
```

🎉 **Deployment complete!**
