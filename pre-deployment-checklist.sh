#!/bin/bash

# Comprehensive pre-deployment checklist
# Usage: ./pre-deployment-checklist.sh

echo "🚀 KrishiSarthi Pre-Deployment Checklist"
echo "=========================================="
echo ""

PASS=0
FAIL=0
WARN=0

check_status() {
    if [ $1 -eq 0 ]; then
        echo "✅ PASS: $2"
        PASS=$((PASS + 1))
    elif [ $1 -eq 1 ]; then
        echo "⚠️  WARN: $2"
        WARN=$((WARN + 1))
    else
        echo "❌ FAIL: $2"
        FAIL=$((FAIL + 1))
    fi
}

# 1. Environment Setup
echo "📝 1. Environment Configuration"
[ -f ".env" ] && check_status 0 ".env file exists" || check_status 2 ".env file not found"
[ -f ".env.example" ] && check_status 0 ".env.example exists" || check_status 2 ".env.example not found"

# 2. Docker Setup
echo ""
echo "🐳 2. Docker & Compose"
command -v docker &> /dev/null && check_status 0 "Docker is installed" || check_status 2 "Docker not installed"
command -v docker-compose &> /dev/null && check_status 0 "Docker Compose is installed" || check_status 2 "Docker Compose not installed"

# 3. API Keys
echo ""
echo "🔑 3. API Keys Setup"
grep -q "GOOGLE_GENAI_API_KEY=" .env && grep -q "GOOGLE_GENAI_API_KEY=AIzaSy" .env && check_status 0 "Google GenAI key configured" || check_status 1 "Google GenAI key not configured"
grep -q "OPENAI_API_KEY=" .env && grep -q "OPENAI_API_KEY=sk-" .env && check_status 0 "OpenAI key configured" || check_status 1 "OpenAI key not configured"
grep -q "GROK_API_KEY=" .env && grep -q "GROK_API_KEY=xai-" .env && check_status 0 "Grok key configured" || check_status 1 "Grok key not configured"

# 4. Database
echo ""
echo "🗄️  4. Database Configuration"
grep -q "MONGODB_URI=" .env && check_status 0 "MongoDB URI configured" || check_status 2 "MongoDB URI not configured"
grep -q "JWT_SECRET=" .env && check_status 0 "JWT Secret configured" || check_status 2 "JWT Secret not configured"

# 5. Security
echo ""
echo "🔐 5. Security Configuration"
NODE_ENV=$(grep "^NODE_ENV=" .env | cut -d '=' -f2 | tr -d ' ')
[ "$NODE_ENV" = "production" ] && check_status 0 "NODE_ENV=production" || check_status 1 "NODE_ENV not set to production"
JWT_LEN=$(grep "^JWT_SECRET=" .env | cut -d '=' -f2 | wc -c)
[ $JWT_LEN -gt 32 ] && check_status 0 "JWT Secret length sufficient (${JWT_LEN} chars)" || check_status 1 "JWT Secret too short"

# 6. CORS & Domain
echo ""
echo "🌐 6. Domain & CORS"
grep -q "CORS_ORIGIN=" .env && check_status 0 "CORS Origin configured" || check_status 2 "CORS Origin not configured"
grep -q "REACT_APP_API_URL=" .env && check_status 0 "Frontend API URL configured" || check_status 2 "Frontend API URL not configured"

# 7. Configuration Files
echo ""
echo "📋 7. Configuration Files"
[ -f "docker-compose.yml" ] && check_status 0 "docker-compose.yml exists" || check_status 2 "docker-compose.yml not found"
[ -f "nginx.conf" ] && check_status 0 "nginx.conf exists" || check_status 2 "nginx.conf not found"
[ -f "backend/Dockerfile" ] && check_status 0 "backend/Dockerfile exists" || check_status 2 "backend/Dockerfile not found"
[ -f "frontend/Dockerfile" ] && check_status 0 "frontend/Dockerfile exists" || check_status 2 "frontend/Dockerfile not found"

# 8. Scripts
echo ""
echo "🔧 8. Helper Scripts"
[ -f "health-check.sh" ] && check_status 0 "health-check.sh exists" || check_status 1 "health-check.sh not found"
[ -f "validate-env.sh" ] && check_status 0 "validate-env.sh exists" || check_status 1 "validate-env.sh not found"
[ -f "deploy-prod.sh" ] && check_status 0 "deploy-prod.sh exists" || check_status 1 "deploy-prod.sh not found"

# 9. Build Test
echo ""
echo "🏗️  9. Build Test (Optional)"
echo "  To test build, run: docker-compose build"
echo "  This may take 5-10 minutes..."

# Summary
echo ""
echo "=========================================="
echo "📊 Results:"
echo "  ✅ Passed: $PASS"
echo "  ⚠️  Warnings: $WARN"
echo "  ❌ Failed: $FAIL"
echo ""

if [ $FAIL -eq 0 ]; then
    echo "✅ Ready for deployment!"
    echo ""
    echo "Next steps:"
    echo "1. Review warnings above"
    echo "2. Run: docker-compose build"
    echo "3. Run: docker-compose up -d"
    echo "4. Check: http://localhost"
else
    echo "❌ Please fix failures before deployment"
    exit 1
fi
