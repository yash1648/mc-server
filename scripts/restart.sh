#!/bin/bash

##############################################################################
# RESTART SERVER SCRIPT
#
# Purpose: Restart the Minecraft server
# What it does:
#   - Stops the server gracefully
#   - Starts it back up
#   - Useful after installing plugins or making config changes
#
# Usage: ./scripts/restart.sh
##############################################################################

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}"
echo "╔════════════════════════════════════════════════════════╗"
echo "║           🔄 Restarting Minecraft Server              ║"
echo "╚════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

# ============================================================================
# STOP SERVER
# ============================================================================

echo -e "${YELLOW}Step 1: Stopping server...${NC}"
echo ""

# Call stop.sh but suppress its output headers
docker ps --format '{{.Names}}' | grep -q "^papermc-server$"

if [ $? -eq 0 ]; then
    # Server is running
    docker exec papermc-server rcon-cli save-all > /dev/null 2>&1 || true
    sleep 2
    docker exec papermc-server rcon-cli stop > /dev/null 2>&1 || true
    
    # Wait for graceful stop
    max_wait=30
    waited=0
    
    while docker ps --format '{{.Names}}' | grep -q "^papermc-server$"; do
        if [ $waited -ge $max_wait ]; then
            docker stop papermc-server
            break
        fi
        waited=$((waited + 1))
        sleep 1
    done
    
    echo -e "${GREEN}✅ Server stopped${NC}"
else
    echo -e "${BLUE}ℹ️  Server not running${NC}"
fi

echo ""

# ============================================================================
# WAIT BEFORE RESTART
# ============================================================================

echo -e "${YELLOW}Step 2: Waiting before restart...${NC}"
sleep 3
echo -e "${GREEN}✅ Ready to start${NC}"
echo ""

# ============================================================================
# START SERVER
# ============================================================================

echo -e "${YELLOW}Step 3: Starting server...${NC}"
echo ""

if docker ps -a --format '{{.Names}}' | grep -q "^papermc-server$"; then
    # Container exists
    docker start papermc-server
else
    # Create and start container
    docker compose up -d
fi

sleep 2

echo -e "${GREEN}✅ Server started${NC}"
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
echo -e "     ${BLUE}./scripts/logs.sh${NC}"
echo "     (Wait for 'Done! For help, type help')"
echo ""
echo "  2. Join the server to test"
echo ""
echo "  3. If plugins were added, check logs for:"
echo "     'Plugin loaded successfully'"
echo ""

echo -e "${GREEN}✨ Restart process complete!${NC}"
echo ""
