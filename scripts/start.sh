#!/bin/bash

##############################################################################
# START SERVER SCRIPT
#
# Purpose: Start the Minecraft server
# What it does:
#   - Checks if container already exists
#   - Starts Docker container with PaperMC
#   - Displays container status
#
# Usage: ./scripts/start.sh
##############################################################################

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}"
echo "╔════════════════════════════════════════════════════════╗"
echo "║            🚀 Starting Minecraft Server               ║"
echo "╚════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

# ============================================================================
# CHECK IF CONTAINER EXISTS
# ============================================================================

if docker ps -a --format '{{.Names}}' | grep -q "^papermc-server$"; then
    
    # Container exists - check if it's running
    if docker ps --format '{{.Names}}' | grep -q "^papermc-server$"; then
        echo -e "${YELLOW}⚠️  Server is already running!${NC}"
        echo ""
        echo "Use one of these commands:"
        echo "  ${BLUE}./scripts/stop.sh${NC}      - Stop the server"
        echo "  ${BLUE}./scripts/restart.sh${NC}   - Restart the server"
        echo "  ${BLUE}./scripts/logs.sh${NC}      - View server logs"
        echo ""
        exit 0
    else
        # Container exists but stopped - start it
        echo -e "${YELLOW}⏸️  Server container exists (stopped). Starting...${NC}"
        echo ""
        docker start papermc-server
        
        sleep 2
        echo -e "${GREEN}✅ Server started!${NC}"
    fi
else
    # Container doesn't exist - create and start it
    echo -e "${YELLOW}🏗️  Creating server container...${NC}"
    echo "(This may take 1-2 minutes on first start)"
    echo ""
    
    docker compose up -d
    
    sleep 3
    echo -e "${GREEN}✅ Server created and started!${NC}"
fi

echo ""

# ============================================================================
# DISPLAY STATUS
# ============================================================================

echo -e "${BLUE}📊 Container Status:${NC}"
echo ""

docker ps --filter "name=papermc-server" \
    --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo ""

# ============================================================================
# NEXT STEPS
# ============================================================================

echo -e "${YELLOW}📋 Next Steps:${NC}"
echo ""
echo "  1. View startup logs:"
echo "     ${BLUE}./scripts/logs.sh${NC}"
echo "     (Wait for 'Done! For help, type help')"
echo ""
echo "  2. Test locally (if ready):"
echo "     Minecraft → Multiplayer → Direct Connect → localhost"
echo ""
echo "  3. Check server status:"
echo "     ${BLUE}./scripts/status.sh${NC}"
echo ""
echo "  4. Open admin console:"
echo "     ${BLUE}./scripts/console.sh${NC}"
echo ""

echo -e "${GREEN}✨ Server is starting up...${NC}"
echo ""