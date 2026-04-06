#!/bin/bash

# Utility: .env Generator Script
# Usage: ./setup-env.sh [environment]

ENVIRONMENT=${1:-production}

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    SECRET_KEY=$(openssl rand -base64 32)
else
    # Linux
    SECRET_KEY=$(head -c 32 /dev/urandom | base64)
fi

# Detect MongoDB password
if [ -z "$MONGO_PASSWORD" ]; then
    MONGO_PASSWORD=$(openssl rand -base64 16 | sed 's/=//g' | sed 's/+//g' | sed 's/\///g')
fi

# Create .env file
cat > .env << EOF
# Generated on $(date)
# Environment: $ENVIRONMENT

# ===========================
# ENVIRONMENT & PORTS
# ===========================

NODE_ENV=$ENVIRONMENT
BACKEND_PORT=5000
FRONTEND_PORT=3000

# ===========================
# DATABASE
# ===========================

MONGODB_URI=mongodb://admin:${MONGO_PASSWORD}@localhost:27017/krishiai?authSource=admin
MONGO_ROOT_USER=admin
MONGO_ROOT_PASSWORD=${MONGO_PASSWORD}
MONGO_PORT=27017

# ===========================
# SECURITY
# ===========================

JWT_SECRET=${SECRET_KEY}
CORS_ORIGIN=http://localhost:3000

# ===========================
# API KEYS (Required)
# ===========================

# Get keys from:
# - Google: https://ai.google.dev
# - OpenAI: https://platform.openai.com
# - Grok: https://api.x.ai

GOOGLE_GENAI_API_KEY=
OPENAI_API_KEY=
GROK_API_KEY=

# ===========================
# FRONTEND
# ===========================

REACT_APP_API_URL=http://localhost:5000

# ===========================
# LOGGING
# ===========================

LOG_LEVEL=info

EOF

echo "✅ .env file created successfully!"
echo "📝 Please update the API keys in .env"
echo "🔐 JWT_SECRET: ${SECRET_KEY:0:10}..."
echo "🔐 MongoDB Password: ${MONGO_PASSWORD:0:10}..."
echo ""
echo "Next steps:"
echo "1. nano .env"
echo "2. Fill in: GOOGLE_GENAI_API_KEY, OPENAI_API_KEY, GROK_API_KEY"
echo "3. docker-compose up -d"
