from fastapi import FastAPI, Header, HTTPException, Query
from typing import Optional
import os
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

app = FastAPI(title="Secret API", version="1.0")

# Get API key from environment variable
API_KEY = os.getenv("API_KEY", "test-key-12345")


def verify_api_key(key: str) -> bool:
    """Verify if the provided API key is correct."""
    return key == API_KEY


@app.get("/")
def read_root():
    """Public endpoint - no authentication required."""
    return {
        "msg": "Welcome to DockerAPI!",
        "v": "1.0",
        "note": "Use /secret endpoint with X-API-Key header or ?api_key= parameter"
    }


@app.get("/secret")
def get_secret(
    x_api_key: Optional[str] = Header(None),
    api_key: Optional[str] = Query(None)
):
    """
    Protected endpoint - requires API key.
    
    Can provide API key in two ways:
    1. Header: X-API-Key: your-api-key
    2. Query parameter: ?api_key=your-api-key
    """
    # Check if API key is provided either way
    provided_key = x_api_key or api_key
    
    if not provided_key:
        raise HTTPException(
            status_code=401,
            detail="API key required. Provide X-API-Key header or api_key query parameter."
        )
    
    # Verify the API key
    if not verify_api_key(provided_key):
        raise HTTPException(
            status_code=403,
            detail="Invalid API key"
        )
    
    # Return secret data for authenticated users
    return {
        "secret": "🔐 This is a secret message! Only authenticated users can see this.",
        "data": {
            "classified_info": "Confidential data accessible only with valid API key",
            "timestamp": "2026-01-25",
            "status": "success"
        }
    }


@app.get("/health")
def health_check():
    """Health check endpoint - no authentication required."""
    return {"status": "healthy", "service": "DockerAPI"}
