#!/bin/bash

# Validate .env file before deployment
# Usage: ./validate-env.sh

set -e

echo "🔍 Validating environment configuration..."
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

ERRORS=0
WARNINGS=0

# Check if .env exists
if [ ! -f ".env" ]; then
    echo -e "${RED}✗${NC} .env file not found"
    echo "  Run: cp .env.example .env"
    exit 1
fi

# Required variables
REQUIRED_VARS=(
    "NODE_ENV"
    "MONGODB_URI"
    "JWT_SECRET"
    "CORS_ORIGIN"
)

# Check required variables
for var in "${REQUIRED_VARS[@]}"; do
    value=$(grep "^${var}=" .env | cut -d '=' -f2 | xargs)
    if [ -z "$value" ] || [ "$value" = "" ]; then
        echo -e "${RED}✗${NC} Missing required: $var"
        ERRORS=$((ERRORS + 1))
    else
        echo -e "${GREEN}✓${NC} $var is set"
    fi
done

# Check API keys (at least one should be set)
API_KEYS_SET=0
for key in "GOOGLE_GENAI_API_KEY" "OPENAI_API_KEY" "GROK_API_KEY"; do
    value=$(grep "^${key}=" .env | cut -d '=' -f2 | xargs)
    if [ ! -z "$value" ] && [ "$value" != "" ]; then
        echo -e "${GREEN}✓${NC} $key is set"
        API_KEYS_SET=$((API_KEYS_SET + 1))
    fi
done

if [ $API_KEYS_SET -eq 0 ]; then
    echo -e "${YELLOW}⚠${NC}  Warning: No AI API keys configured"
    WARNINGS=$((WARNINGS + 1))
fi

# Security checks
echo ""
echo "🔐 Security Checks:"

# Check JWT_SECRET length
JWT_SECRET=$(grep "^JWT_SECRET=" .env | cut -d '=' -f2 | xargs)
if [ ${#JWT_SECRET} -lt 32 ]; then
    echo -e "${YELLOW}⚠${NC}  JWT_SECRET is less than 32 characters (weak)"
    WARNINGS=$((WARNINGS + 1))
else
    echo -e "${GREEN}✓${NC} JWT_SECRET is strong"
fi

# Check if .env is in gitignore
if grep -q "^.env$" .gitignore 2>/dev/null; then
    echo -e "${GREEN}✓${NC} .env is in .gitignore"
else
    echo -e "${YELLOW}⚠${NC}  .env might not be in .gitignore"
    WARNINGS=$((WARNINGS + 1))
fi

# Check NODE_ENV
NODE_ENV=$(grep "^NODE_ENV=" .env | cut -d '=' -f2 | xargs)
if [ "$NODE_ENV" = "production" ]; then
    echo -e "${GREEN}✓${NC} NODE_ENV is set to production"
elif [ "$NODE_ENV" = "development" ]; then
    echo -e "${YELLOW}⚠${NC}  NODE_ENV is set to development (use production)"
    WARNINGS=$((WARNINGS + 1))
fi

# MongoDB connection check
echo ""
echo "🗄️  Database Checks:"
MONGODB_URI=$(grep "^MONGODB_URI=" .env | cut -d '=' -f2-' xargs)
if [[ $MONGODB_URI == mongodb* ]]; then
    echo -e "${GREEN}✓${NC} MONGODB_URI format is valid"
else
    echo -e "${RED}✗${NC} MONGODB_URI format invalid"
    ERRORS=$((ERRORS + 1))
fi

# Summary
echo ""
echo "======================================"
if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✅ All checks passed!${NC}"
    echo "Ready to deploy."
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠️  Warnings found ($WARNINGS)${NC}"
    echo "Can still deploy, but review warnings above."
    exit 0
else
    echo -e "${RED}❌ Errors found ($ERRORS)${NC}"
    echo "Please fix errors before deploying."
    exit 1
fi
