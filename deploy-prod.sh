#!/bin/bash

# KrishiSarthi Production Deployment Script
# Usage: ./deploy-prod.sh <environment> [tag]

set -e

ENVIRONMENT=${1:-production}
TAG=${2:-latest}
REGISTRY=${REGISTRY:-your-registry}
PROJECT_NAME=krishisarthi

echo "🚀 Deploying $PROJECT_NAME to $ENVIRONMENT"
echo "Registry: $REGISTRY"
echo "Tag: $TAG"
echo ""

# Build images
echo "📦 Building Docker images..."
docker-compose build --no-cache

# Tag images
echo "🏷️  Tagging images..."
docker tag ${PROJECT_NAME}_backend:${TAG} ${REGISTRY}/${PROJECT_NAME}-backend:${TAG}
docker tag ${PROJECT_NAME}_frontend:${TAG} ${REGISTRY}/${PROJECT_NAME}-frontend:${TAG}

# Push to registry
echo "📤 Pushing to registry..."
docker push ${REGISTRY}/${PROJECT_NAME}-backend:${TAG}
docker push ${REGISTRY}/${PROJECT_NAME}-frontend:${TAG}

# Deploy based on environment
case $ENVIRONMENT in
  production)
    echo "🌍 Deploying to PRODUCTION"
    if [ ! -f ".env" ]; then
      echo "❌ Error: .env file not found"
      exit 1
    fi
    docker-compose -p ${PROJECT_NAME}_prod down || true
    docker-compose -f docker-compose.yml up -d
    ;;
  staging)
    echo "⚙️  Deploying to STAGING"
    docker-compose -f docker-compose.staging.yml -p ${PROJECT_NAME}_staging down || true
    docker-compose -f docker-compose.staging.yml -p ${PROJECT_NAME}_staging up -d
    ;;
  *)
    echo "❌ Unknown environment: $ENVIRONMENT"
    exit 1
    ;;
esac

echo ""
echo "✅ Deployment completed!"
echo ""
echo "🏥 Running health checks..."
sleep 5
./health-check.sh || echo "⚠️  Some health checks failed"

echo ""
echo "📍 Services:"
docker-compose ps
