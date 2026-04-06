#!/bin/bash

# One-click deployment script for KrishiSarthi
# Usage: ./deploy.sh [environment] [action]
# Examples:
#   ./deploy.sh local up
#   ./deploy.sh staging up
#   ./deploy.sh production up
#   ./deploy.sh production down

set -e

ENVIRONMENT=${1:-local}
ACTION=${2:-up}

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
log_info() {
    echo -e "${BLUE}ℹ${NC}  $1"
}

log_success() {
    echo -e "${GREEN}✓${NC}  $1"
}

log_warning() {
    echo -e "${YELLOW}⚠${NC}  $1"
}

log_error() {
    echo -e "${RED}✗${NC}  $1"
}

# Banner
echo "${BLUE}"
echo "╔════════════════════════════════════════╗"
echo "║    🚀 KrishiSarthi Deployment         ║"
echo "║                                        ║"
echo "╚════════════════════════════════════════╝"
echo "${NC}"
echo ""

# Validate inputs
case $ENVIRONMENT in
    local|staging|production)
        log_info "Environment: $ENVIRONMENT"
        ;;
    *)
        log_error "Unknown environment: $ENVIRONMENT"
        echo "Usage: ./deploy.sh [local|staging|production] [up|down|restart]"
        exit 1
        ;;
esac

case $ACTION in
    up|down|restart|logs|ps)
        log_info "Action: $ACTION"
        ;;
    *)
        log_error "Unknown action: $ACTION"
        echo "Usage: ./deploy.sh [environment] [up|down|restart|logs|ps]"
        exit 1
        ;;
esac

# Pre-checks
log_info "Running pre-flight checks..."

if ! command -v docker &> /dev/null; then
    log_error "Docker is not installed"
    exit 1
fi
log_success "Docker installed"

if ! command -v docker-compose &> /dev/null; then
    log_warning "Docker Compose V2 not found, checking for V1..."
    if ! docker compose --version &> /dev/null; then
        log_error "Docker Compose is not installed"
        exit 1
    fi
    COMPOSE_CMD="docker compose"
else
    COMPOSE_CMD="docker-compose"
fi
log_success "Docker Compose available"

# Environment setup
log_info "Configuring for $ENVIRONMENT environment..."

case $ENVIRONMENT in
    local)
        COMPOSE_FILE="docker-compose.yml"
        PROJECT_NAME="krishisarthi_local"
        ;;
    staging)
        COMPOSE_FILE="docker-compose.staging.yml"
        PROJECT_NAME="krishisarthi_staging"
        ;;
    production)
        COMPOSE_FILE="docker-compose.yml"
        PROJECT_NAME="krishisarthi_prod"
        ;;
esac

# Check .env file
if [ $ENVIRONMENT = "production" ]; then
    if [ ! -f ".env" ]; then
        log_error ".env file not found for production"
        log_info "Copy and configure: cp .env.example .env"
        exit 1
    fi
    log_success ".env file found"
    
    # Validate environment
    log_info "Validating environment..."
    bash validate-env.sh || exit 1
fi

# Execute action
log_info "Executing action: $ACTION"
echo ""

case $ACTION in
    up)
        log_info "Starting services..."
        $COMPOSE_CMD -f $COMPOSE_FILE -p $PROJECT_NAME build --no-cache
        $COMPOSE_CMD -f $COMPOSE_FILE -p $PROJECT_NAME up -d
        log_success "Services started"
        
        echo ""
        log_info "Waiting for services to be healthy..."
        sleep 3
        
        # Check health
        log_info "Checking application health..."
        for i in {1..10}; do
            if curl -s http://localhost/health > /dev/null 2>&1; then
                log_success "Application is healthy"
                break
            fi
            if [ $i -eq 10 ]; then
                log_warning "Health check inconclusive, check logs manually"
            fi
            sleep 2
        done
        
        echo ""
        log_success "Deployment complete!"
        echo ""
        echo "Services running:"
        $COMPOSE_CMD -f $COMPOSE_FILE -p $PROJECT_NAME ps
        echo ""
        echo "Access application:"
        echo "  Frontend: http://localhost"
        echo "  API: http://localhost/api/health"
        echo ""
        echo "Useful commands:"
        echo "  View logs: $COMPOSE_CMD -f $COMPOSE_FILE -p $PROJECT_NAME logs -f"
        echo "  Stop: ./deploy.sh $ENVIRONMENT down"
        echo "  Restart: ./deploy.sh $ENVIRONMENT restart"
        ;;
        
    down)
        log_info "Stopping services..."
        $COMPOSE_CMD -f $COMPOSE_FILE -p $PROJECT_NAME down
        log_success "Services stopped"
        ;;
        
    restart)
        log_info "Restarting services..."
        $COMPOSE_CMD -f $COMPOSE_FILE -p $PROJECT_NAME restart
        log_success "Services restarted"
        ;;
        
    logs)
        log_info "Fetching logs (Ctrl+C to exit)..."
        sleep 1
        $COMPOSE_CMD -f $COMPOSE_FILE -p $PROJECT_NAME logs -f
        ;;
        
    ps)
        log_info "Showing service status..."
        $COMPOSE_CMD -f $COMPOSE_FILE -p $PROJECT_NAME ps
        ;;
esac

echo ""
log_info "Done!"
