#!/bin/bash
# ============================================================
# Tetris Game - Deployment Script
# ============================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🎮 Tetris Game Deployment Script${NC}\n"

# Check Docker
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed${NC}"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}Error: Docker Compose is not installed${NC}"
    exit 1
fi

# Parse arguments
ENV=${1:-staging}
ACTION=${2:-deploy}

case $ACTION in
    deploy)
        echo -e "${YELLOW}Deploying to $ENV environment...${NC}"
        
        # Pull latest images
        echo "Pulling latest images..."
        docker-compose pull
        
        # Stop existing containers
        echo "Stopping existing containers..."
        docker-compose down
        
        # Start services
        echo "Starting services..."
        docker-compose up -d
        
        # Wait for health checks
        echo "Waiting for services to be healthy..."
        sleep 10
        
        # Show status
        docker-compose ps
        
        echo -e "${GREEN}✅ Deployment complete!${NC}"
        echo "Frontend: http://localhost:3000"
        echo "Backend API: http://localhost:3001"
        ;;
        
    stop)
        echo -e "${YELLOW}Stopping services...${NC}"
        docker-compose down
        echo -e "${GREEN}✅ Services stopped${NC}"
        ;;
        
    restart)
        echo -e "${YELLOW}Restarting services...${NC}"
        docker-compose restart
        echo -e "${GREEN}✅ Services restarted${NC}"
        ;;
        
    logs)
        echo -e "${YELLOW}Showing logs...${NC}"
        docker-compose logs -f
        ;;
        
    clean)
        echo -e "${RED}⚠️  Cleaning up...${NC}"
        docker-compose down -v --rmi all
        echo -e "${GREEN}✅ Cleanup complete${NC}"
        ;;
        
    *)
        echo "Usage: $0 [staging|production] [deploy|stop|restart|logs|clean]"
        echo ""
        echo "Examples:"
        echo "  $0 staging deploy    # Deploy to staging"
        echo "  $0 staging stop       # Stop staging services"
        echo "  $0 staging logs       # View logs"
        exit 1
        ;;
esac
