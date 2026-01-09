#!/bin/bash

##############################################################################
# STOP SERVER SCRIPT
#
# Purpose: Gracefully stop the Minecraft server
# What it does:
#   - Sends "save-all" command to save world
#   - Sends "stop" command to gracefully shut down
#   - Waits for Docker container to stop
#   - Displays status
#
# Usage: ./scripts/stop.sh
#
# Note: Graceful stop saves the world and prevents corruption
##############################################################################

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}"
echo "╔════════════════════════════════════════════════════════╗"
echo "║            ⏹️  Stopping Minecraft Server              ║"
echo "╚════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

# ============================================================================
# CHECK IF SERVER IS RUNNING
# ============================================================================

if ! docker ps --format '{{.Names}}' | grep -q "^papermc-server$"; then
    echo -e "${YELLOW}⚠️  Server is not running.${NC}"
    echo ""
    echo "Use this command to start:"
    echo -e "  ${BLUE}./scripts/start.sh${NC}"
    echo ""
    exit 0
fi

# ============================================================================
# GRACEFULLY STOP SERVER
# ============================================================================

echo -e "${YELLOW}💾 Saving world...${NC}"
docker exec papermc-server rcon-cli save-all > /dev/null 2>&1 || true
sleep 2

echo -e "${YELLOW}🛑 Sending stop command...${NC}"
docker exec papermc-server rcon-cli stop > /dev/null 2>&1 || true

# Wait for container to stop gracefully
echo -e "${YELLOW}⏳ Waiting for server to shut down...${NC}"

max_wait=30
waited=0

while docker ps --format '{{.Names}}' | grep -q "^papermc-server$"; do
    if [ $waited -ge $max_wait ]; then
        echo -e "${YELLOW}⚠️  Timeout waiting for graceful shutdown, forcing stop...${NC}"
        docker stop papermc-server
        break
    fi
    
    waited=$((waited + 1))
    sleep 1
    echo -n "."
done

echo ""
echo ""

# ============================================================================
# FINAL STATUS
# ============================================================================

if docker ps -a --format '{{.Names}}' | grep -q "^papermc-server$"; then
    STATUS=$(docker ps -a --filter "name=papermc-server" \
        --format "{{.Status}}")
    
    echo -e "${GREEN}✅ Server stopped successfully!${NC}"
    echo "   Status: $STATUS"
else
    echo -e "${GREEN}✅ Server container removed.${NC}"
fi

echo ""

# ============================================================================
# NEXT STEPS
# ============================================================================

echo -e "${YELLOW}📋 Next Steps:${NC}"
echo ""
echo "  To start the server again:"
echo -e "    ${BLUE}./scripts/start.sh${NC}"
echo ""
echo "  To create a backup before major changes:"
echo -e "    ${BLUE}./scripts/backup.sh${NC}"
echo ""
echo "  To view container status:"
echo -e "    ${BLUE}./scripts/status.sh${NC}"
echo ""

echo -e "${GREEN}✨ Server stopped.${NC}"
echo ""
