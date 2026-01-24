# Secret API - Deployment Guide

## Overview
This is a simple REST API with:
- **Public endpoint** (`/`) - No authentication required
- **Protected endpoint** (`/secret`) - Requires API key authentication
- **Health check endpoint** (`/health`) - For monitoring

## Local Development

### 1. Setup
```bash
# Install dependencies
pip install -r requirements.txt

# Create .env file
cp .env-example .env
# Edit .env and set your API_KEY
```

### 2. Run Locally
```bash
uvicorn app.main:app --reload
```

The API will be available at `http://127.0.0.1:8000`

### 3. Test Endpoints

**Public endpoint:**
```bash
curl http://127.0.0.1:8000/
```

**Protected endpoint (with API key):**
```bash
# Via query parameter
curl "http://127.0.0.1:8000/secret?api_key=test-key-12345"

# Via header
curl -H "X-API-Key: test-key-12345" http://127.0.0.1:8000/secret
```

**Health check:**
```bash
curl http://127.0.0.1:8000/health
```

---

## Deployment to Render

### 1. Prepare Repository
- Ensure `.env` file is in `.gitignore` (it is by default)
- Commit all changes to git

```bash
git add .
git commit -m "Add secret API with authentication"
git push origin main
```

### 2. Deploy on Render
1. Go to [render.com](https://render.com)
2. Click "New +" → "Web Service"
3. Connect your GitHub repository
4. Configure:
   - **Name**: `dockerapi`
   - **Runtime**: `Python 3`
   - **Build Command**: `pip install -r requirements.txt`
   - **Start Command**: `uvicorn app.main:app --host 0.0.0.0`
   - **Port**: `8000` (default)

### 3. Set Environment Variables
In Render dashboard:
1. Go to your service settings
2. Add environment variable:
   - **Key**: `API_KEY`
   - **Value**: `your-secure-api-key-here`

Replace `your-secure-api-key-here` with a secure key (minimum 32 characters recommended).

### 4. Testing Deployed API
Once deployed at `https://dockerapi-5txa.onrender.com/`:

```bash
# Public endpoint
curl https://dockerapi-5txa.onrender.com/

# Protected endpoint
curl -H "X-API-Key: your-secure-api-key-here" https://dockerapi-5txa.onrender.com/secret

# Health check
curl https://dockerapi-5txa.onrender.com/health
```

---

## API Key Management

### Best Practices
1. **Never commit API keys to version control**
   - Store in `.env` for local development
   - Use environment variables on production servers
   
2. **Use strong keys**
   - Minimum 32 characters
   - Mix of uppercase, lowercase, numbers, and special characters
   
3. **Rotate keys regularly**
   - Update keys every 3-6 months
   - Keep old keys temporarily during rotation

### Current Configuration
- **Local**: Uses `.env` file with `python-dotenv`
- **Production**: Uses environment variables set in Render dashboard
- **Default fallback**: `test-key-12345` (for local testing only)

---

## Project Structure
```
DockerAPI/
├── app/
│   ├── __init__.py
│   └── main.py          # FastAPI application
├── .env                 # Local environment variables (not in git)
├── .env-example         # Example environment variables
├── .gitignore           # Git ignore rules
├── requirements.txt     # Python dependencies
├── Dockerfile           # Docker configuration
├── docker-compose.yml   # Docker Compose configuration
└── README.md            # This file
```

---

## Endpoints Reference

### GET `/`
**Public endpoint**

Response:
```json
{
  "msg": "Welcome to DockerAPI!",
  "v": "1.0",
  "note": "Use /secret endpoint with X-API-Key header or ?api_key= parameter"
}
```

### GET `/secret`
**Protected endpoint - Requires API Key**

Authentication (choose one):
- Header: `X-API-Key: your-api-key`
- Query parameter: `?api_key=your-api-key`

Success Response (200):
```json
{
  "secret": "🔐 This is a secret message! Only authenticated users can see this.",
  "data": {
    "classified_info": "Confidential data accessible only with valid API key",
    "timestamp": "2026-01-25",
    "status": "success"
  }
}
```

Error Responses:
- **401 Unauthorized**: API key missing
- **403 Forbidden**: API key invalid

### GET `/health`
**Health check endpoint**

Response:
```json
{
  "status": "healthy",
  "service": "DockerAPI"
}
```

---

## Troubleshooting

### Local Development Issues
1. **Module not found**: Ensure you've run `pip install -r requirements.txt`
2. **Port already in use**: Change port with `uvicorn app.main:app --port 8001`
3. **.env not loading**: Verify `.env` file is in the project root

### Deployment Issues
1. **API key not working on Render**: Check environment variable spelling and value
2. **Service won't start**: Check logs in Render dashboard for errors
3. **502 Bad Gateway**: May indicate startup error - check deployment logs

---

## Security Notes
⚠️ **Important**:
- Never expose API keys in URLs in production (use headers instead)
- Use HTTPS only for production (Render provides this automatically)
- Implement rate limiting for production deployments
- Consider API key rotation strategies for high-security applications

---

## Next Steps
- Add database for user management
- Implement role-based access control (RBAC)
- Add request rate limiting
- Implement API key expiration
- Add comprehensive logging and monitoring
