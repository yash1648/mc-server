#!/bin/bash

##############################################################################
# BACKUP SCRIPT
#
# Purpose: Create and manage world backups
# What it does:
#   - Saves world to compressed archive
#   - Creates timestamped backup files
#   - Automatically removes old backups (keeps last 10)
#   - Saves in backups/ directory
#
# Usage: ./scripts/backup.sh
#
# Backup files: backups/backup_YYYYMMDD_HHMMSS.tar.gz
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
echo "║         💾 Creating Server Backup                     ║"
echo "╚════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

# ============================================================================
# CONFIGURATION
# ============================================================================

BACKUP_DIR="backups"
KEEP_BACKUPS=10

mkdir -p $BACKUP_DIR

# Generate timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"

# ============================================================================
# CHECK IF SERVER IS RUNNING
# ============================================================================

SERVER_RUNNING=false

if docker ps --format '{{.Names}}' | grep -q "^papermc-server$"; then
    SERVER_RUNNING=true
fi

# ============================================================================
# PREPARE FOR BACKUP
# ============================================================================

echo -e "${YELLOW}Step 1: Preparing backup...${NC}"
echo ""

if [ "$SERVER_RUNNING" = true ]; then
    echo -e "${CYAN}→${NC} Disabling world save (prevents file modifications)..."
    docker exec papermc-server rcon-cli save-off > /dev/null 2>&1 || true
    sleep 2
    
    echo -e "${CYAN}→${NC} Saving current world state..."
    docker exec papermc-server rcon-cli save-all > /dev/null 2>&1 || true
    sleep 2
    
    echo -e "${GREEN}✅ Server prepared for backup${NC}"
else
    echo -e "${YELLOW}⚠️  Server is offline, creating offline backup${NC}"
fi

echo ""

# ============================================================================
# CREATE BACKUP
# ============================================================================

echo -e "${YELLOW}Step 2: Creating backup archive...${NC}"
echo ""

# Try to backup all world directories
if tar -czf "$BACKUP_FILE" \
    -C data world world_nether world_the_end \
    --ignore-failed-read 2>/dev/null; then
    
    echo -e "${GREEN}✅ Backup created successfully${NC}"
    
elif tar -czf "$BACKUP_FILE" \
    -C data . \
    --ignore-failed-read 2>/dev/null; then
    
    echo -e "${GREEN}✅ Backup created (partial structure)${NC}"
else
    echo -e "${RED}❌ Backup creation failed!${NC}"
    echo "Check that data/ directory exists"
    exit 1
fi

echo ""

# ============================================================================
# RESUME SAVING (IF SERVER WAS RUNNING)
# ============================================================================

if [ "$SERVER_RUNNING" = true ]; then
    echo -e "${YELLOW}Step 3: Resuming server operations...${NC}"
    echo ""
    
    docker exec papermc-server rcon-cli save-on > /dev/null 2>&1 || true
    sleep 1
    
    echo -e "${GREEN}✅ Server resumed${NC}"
fi

echo ""

# ============================================================================
# DISPLAY BACKUP INFO
# ============================================================================

echo -e "${BLUE}Backup Information:${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

BACKUP_SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
BACKUP_TIMESTAMP=$(stat -c %y "$BACKUP_FILE" | cut -d' ' -f1-2)

echo "File Name: ${CYAN}$(basename $BACKUP_FILE)${NC}"
echo "Location: ${CYAN}$BACKUP_FILE${NC}"
echo "Size: ${GREEN}$BACKUP_SIZE${NC}"
echo "Created: ${GREEN}$BACKUP_TIMESTAMP${NC}"

echo ""

# ============================================================================
# MANAGE BACKUP RETENTION
# ============================================================================

echo -e "${YELLOW}Step 4: Managing backup retention...${NC}"
echo ""

BACKUP_COUNT=$(ls -1 $BACKUP_DIR/backup_*.tar.gz 2>/dev/null | wc -l)

echo "Total backups: ${CYAN}$BACKUP_COUNT${NC}"
echo "Keeping: ${CYAN}$KEEP_BACKUPS${NC} most recent"

if [ $BACKUP_COUNT -gt $KEEP_BACKUPS ]; then
    echo ""
    echo -e "${CYAN}→${NC} Removing old backups..."
    
    # List and remove old backups
    ls -1t $BACKUP_DIR/backup_*.tar.gz | tail -n +$((KEEP_BACKUPS + 1)) | while read old_backup; do
        SIZE=$(du -h "$old_backup" | cut -f1)
        echo "  Deleted: $(basename $old_backup) ($SIZE)"
        rm -f "$old_backup"
    done
else
    echo -e "${GREEN}✅ Within retention limit${NC}"
fi

echo ""

# ============================================================================
# FINAL STATUS
# ============================================================================

echo -e "${BLUE}All Backups:${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ -z "$(ls -A $BACKUP_DIR 2>/dev/null)" ]; then
    echo "No backups yet"
else
    ls -lh $BACKUP_DIR/backup_*.tar.gz | awk '{printf "%-20s  %10s  %s\n", $6" "$7, $5, $9}' | sed 's|'$BACKUP_DIR'/||g'
fi

echo ""

# ============================================================================
# NEXT STEPS
# ============================================================================

echo -e "${YELLOW}📋 Next Steps:${NC}"
echo ""
echo "To restore from backup:"
echo "  1. Stop server: ${BLUE}./scripts/stop.sh${NC}"
echo "  2. Extract backup:"
echo "     ${BLUE}tar -xzf backups/backup_YYYYMMDD_HHMMSS.tar.gz -C data/${NC}"
echo "  3. Start server: ${BLUE}./scripts/start.sh${NC}"
echo ""

echo -e "${GREEN}✨ Backup complete!${NC}"
echo ""