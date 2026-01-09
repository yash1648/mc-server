#!/bin/bash

##############################################################################
# SERVER STATUS SCRIPT
#
# Purpose: Check Minecraft server status and resource usage
# What it does:
#   - Shows if server is running or stopped
#   - Displays resource usage (CPU, memory)
#   - Shows port bindings
#   - Shows container info
#
# Usage: ./scripts/status.sh
##############################################################################

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${BLUE}"
echo "╔════════════════════════════════════════════════════════╗"
echo "║         📊 Minecraft Server Status                     ║"
echo "╚════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

# ============================================================================
# CHECK IF SERVER IS RUNNING
# ============================================================================

if docker ps --format '{{.Names}}' | grep -q "^papermc-server$"; then
    STATUS_COLOR="${GREEN}"
    STATUS_TEXT="🟢 RUNNING"
else
    STATUS_COLOR="${RED}"
    STATUS_TEXT="🔴 STOPPED"
fi

echo -e "${CYAN}Server Status:${NC} ${STATUS_COLOR}${STATUS_TEXT}${NC}"
echo ""

# ============================================================================
# CONTAINER INFORMATION
# ============================================================================

echo -e "${BLUE}Container Information:${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

docker ps -a --filter "name=papermc-server" \
    --format "Container ID: {{.ID}}\nName: {{.Names}}\nStatus: {{.Status}}\nPorts: {{.Ports}}"

echo ""

# ============================================================================
# RESOURCE USAGE
# ============================================================================

if docker ps --format '{{.Names}}' | grep -q "^papermc-server$"; then
    
    echo -e "${BLUE}Resource Usage:${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    docker stats papermc-server --no-stream --format \
        "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}"
    
    echo ""
fi

# ============================================================================
# DISK USAGE
# ============================================================================

echo -e "${BLUE}Disk Usage:${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ -d "data" ]; then
    DATA_SIZE=$(du -sh data/ 2>/dev/null | awk '{print $1}')
    echo -e "World Data: ${GREEN}$DATA_SIZE${NC}"
else
    echo -e "World Data: ${YELLOW}Not yet created${NC}"
fi

if [ -d "backups" ]; then
    BACKUPS=$(ls -1 backups/backup_*.tar.gz 2>/dev/null | wc -l)
    BACKUP_SIZE=$(du -sh backups/ 2>/dev/null | awk '{print $1}')
    echo -e "Backups: ${GREEN}$BACKUPS backups ($BACKUP_SIZE)${NC}"
else
    echo -e "Backups: ${YELLOW}No backups yet${NC}"
fi

SYSTEM_FREE=$(df -h . | awk 'NR==2 {print $4}')
echo -e "Free Space: ${GREEN}$SYSTEM_FREE${NC}"

echo ""

# ============================================================================
# DOCKER INFO
# ============================================================================

echo -e "${BLUE}Docker Information:${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

DOCKER_VERSION=$(docker --version | grep -oP 'Docker version \K[^,]+')
COMPOSE_VERSION=$(docker compose version --short 2>/dev/null || echo "Unknown")

echo "Docker: $DOCKER_VERSION"
echo "Docker Compose: $COMPOSE_VERSION"
echo ""

# ============================================================================
# QUICK COMMANDS
# ============================================================================

echo -e "${YELLOW}📋 Quick Commands:${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if docker ps --format '{{.Names}}' | grep -q "^papermc-server$"; then
    echo -e "  ${BLUE}./scripts/stop.sh${NC}       - Stop the server"
    echo -e "  ${BLUE}./scripts/restart.sh${NC}    - Restart the server"
    echo -e "  ${BLUE}./scripts/logs.sh${NC}       - View live logs"
    echo -e "  ${BLUE}./scripts/console.sh${NC}    - Open admin console"
else
    echo -e "  ${BLUE}./scripts/start.sh${NC}      - Start the server"
    echo -e "  ${BLUE}./scripts/logs.sh${NC}       - View logs"
fi

echo -e "  ${BLUE}./scripts/backup.sh${NC}      - Create backup"
echo -e "  ${BLUE}./scripts/menu.sh${NC}        - Open main menu"

echo ""

# ============================================================================
# SUMMARY
# ============================================================================

if docker ps --format '{{.Names}}' | grep -q "^papermc-server$"; then
    echo -e "${GREEN}✅ Server is running and ready for players!${NC}"
else
    echo -e "${YELLOW}⚠️  Server is stopped. Run: ${BLUE}./scripts/start.sh${NC}"
fi

echo ""
