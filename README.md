# Secret API with Authentication

A FastAPI application demonstrating secure API key authentication with both local and cloud deployment.

## Features

- **Public Endpoint** - Welcome message accessible without authentication
- **Protected Endpoint** - Returns secret data only with valid API key
- **Flexible Authentication** - Accept API key via header or query parameter
- **Local Development** - Uses `.env` file with `python-dotenv`
- **Production Ready** - Environment variable support for cloud deployment
- **Health Check** - Monitoring endpoint for deployment
- **Docker Support** - Containerized deployment ready

## Quick Start

### Local Development

1. **Install dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

2. **Create `.env` file**:
   ```bash
   cp .env-example .env
   # Edit .env and set API_KEY=test-key-12345
   ```

3. **Run the application**:
   ```bash
   uvicorn app.main:app --reload
   ```

4. **Test endpoints**:
   ```bash
   curl http://127.0.0.1:8000/
   curl -H "X-API-Key: test-key-12345" http://127.0.0.1:8000/secret
   curl "http://127.0.0.1:8000/secret?api_key=test-key-12345"
   curl http://127.0.0.1:8000/health
   ```

## API Endpoints

### GET /
Public welcome endpoint. No authentication required.

### GET /secret
Protected endpoint returning secret data. Requires API key.
- Header: `X-API-Key: your-api-key`
- Query: `?api_key=your-api-key`

### GET /health
Health check endpoint for monitoring.

## API Key Management

- **Local**: Store in `.env` file (not committed to git)
- **Production**: Set as environment variable in hosting platform

## Deployment

See [DEPLOYMENT.md](./DEPLOYMENT.md) for detailed deployment instructions.

Quick steps for Render:
1. Push code to GitHub
2. Create new Web Service on Render
3. Set `API_KEY` environment variable
4. Deploy!

## Security Best Practices

- Never commit `.env` file to version control
- Use HTTPS for all production traffic
- Use strong, random keys in production
- Implement rate limiting for production
- Rotate API keys regularly