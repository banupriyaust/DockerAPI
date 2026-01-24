# Test script for the Secret API

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "Testing Secret API Endpoints" -ForegroundColor Cyan
Write-Host "================================================`n" -ForegroundColor Cyan

$baseUrl = "http://127.0.0.1:8000"

# Test 1: Public endpoint (no auth required)
Write-Host "Test 1: Public endpoint (/)" -ForegroundColor Green
Write-Host "Expected: Welcome message without authentication" -ForegroundColor Gray
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/" -Method Get
    $response.Content | ConvertFrom-Json | Format-List
    Write-Host "✓ PASSED: Public endpoint accessible`n" -ForegroundColor Green
} catch {
    Write-Host "✗ FAILED: $($_.Exception.Message)`n" -ForegroundColor Red
}

# Test 2: Protected endpoint without API key (should fail)
Write-Host "Test 2: Protected endpoint without API key" -ForegroundColor Yellow
Write-Host "Expected: 401 Unauthorized error" -ForegroundColor Gray
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/secret" -Method Get -ErrorAction Stop
    Write-Host "✗ FAILED: Should have been denied`n" -ForegroundColor Red
} catch {
    if ($_.Exception.Response.StatusCode.value__ -eq 401) {
        Write-Host "✓ PASSED: Correctly denied with 401 Unauthorized`n" -ForegroundColor Green
    } else {
        Write-Host "✗ FAILED: Wrong status code`n" -ForegroundColor Red
    }
}

# Test 3: Protected endpoint with invalid API key (should fail)
Write-Host "Test 3: Protected endpoint with invalid API key" -ForegroundColor Yellow
Write-Host "Expected: 403 Forbidden error" -ForegroundColor Gray
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/secret?api_key=wrong-key" -Method Get -ErrorAction Stop
    Write-Host "✗ FAILED: Should have been denied`n" -ForegroundColor Red
} catch {
    if ($_.Exception.Response.StatusCode.value__ -eq 403) {
        Write-Host "✓ PASSED: Correctly denied with 403 Forbidden`n" -ForegroundColor Green
    } else {
        Write-Host "✗ FAILED: Wrong status code`n" -ForegroundColor Red
    }
}

# Test 4: Protected endpoint with valid API key (via query param)
Write-Host "Test 4: Protected endpoint with valid API key (query param)" -ForegroundColor Green
Write-Host "Expected: Secret message returned" -ForegroundColor Gray
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/secret?api_key=test-key-12345" -Method Get
    $data = $response.Content | ConvertFrom-Json
    Write-Host $data.secret -ForegroundColor Cyan
    Write-Host "✓ PASSED: Secret accessible with valid query param key`n" -ForegroundColor Green
} catch {
    Write-Host "✗ FAILED: $($_.Exception.Message)`n" -ForegroundColor Red
}

# Test 5: Protected endpoint with valid API key (via header)
Write-Host "Test 5: Protected endpoint with valid API key (header)" -ForegroundColor Green
Write-Host "Expected: Secret message returned" -ForegroundColor Gray
try {
    $headers = @{"X-API-Key" = "test-key-12345"}
    $response = Invoke-WebRequest -Uri "$baseUrl/secret" -Method Get -Headers $headers
    $data = $response.Content | ConvertFrom-Json
    Write-Host $data.secret -ForegroundColor Cyan
    Write-Host "✓ PASSED: Secret accessible with valid header key`n" -ForegroundColor Green
} catch {
    Write-Host "✗ FAILED: $($_.Exception.Message)`n" -ForegroundColor Red
}

# Test 6: Health check endpoint
Write-Host "Test 6: Health check endpoint" -ForegroundColor Green
Write-Host "Expected: Healthy status" -ForegroundColor Gray
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/health" -Method Get
    $response.Content | ConvertFrom-Json | Format-List
    Write-Host "✓ PASSED: Health check successful`n" -ForegroundColor Green
} catch {
    Write-Host "✗ FAILED: $($_.Exception.Message)`n" -ForegroundColor Red
}

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "Testing Complete" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
