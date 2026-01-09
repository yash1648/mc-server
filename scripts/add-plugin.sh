#!/bin/bash

##############################################################################
# ADD PLUGIN SCRIPT
#
# Purpose: Install Minecraft plugins easily
# What it does:
#   - Accepts plugin from file or URL
#   - Copies to plugins directory
#   - Optionally restarts server
#
# Usage:
#   ./scripts/add-plugin.sh /path/to/plugin.jar
#   ./scripts/add-plugin.sh https://example.com/plugin.jar
#
# Examples:
#   ./scripts/add-plugin.sh ~/Downloads/EssentialsX.jar
#   ./scripts/add-plugin.sh https://dev.bukkit.org/projects/essentialsx/download
##############################################################################

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

# ============================================================================
# CHECK ARGUMENTS
# ============================================================================

if [ $# -eq 0 ]; then
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════════════════════╗"
    echo "║            📦 Add Plugin to Server                     ║"
    echo "╚════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo ""
    echo -e "${YELLOW}Usage:${NC}"
    echo "  ${BLUE}./scripts/add-plugin.sh <plugin-file-or-url>${NC}"
    echo ""
    echo -e "${YELLOW}Examples:${NC}"
    echo "  ${BLUE}./scripts/add-plugin.sh ~/Downloads/EssentialsX.jar${NC}"
    echo "  ${BLUE}./scripts/add-plugin.sh https://example.com/plugin.jar${NC}"
    echo ""
    echo -e "${YELLOW}Popular Plugins:${NC}"
    echo "  • EssentialsX      - Essential commands"
    echo "  • WorldEdit        - Building tool"
    echo "  • LiteBans         - Moderation"
    echo "  • Vault            - Permissions management"
    echo "  • PlaceholderAPI   - Placeholder support"
    echo ""
    exit 1
fi

PLUGIN_INPUT="$1"
PLUGIN_DIR="data/plugins"

mkdir -p $PLUGIN_DIR

echo -e "${BLUE}"
echo "╔════════════════════════════════════════════════════════╗"
echo "║            📦 Adding Plugin to Server                 ║"
echo "╚════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

# ============================================================================
# DETERMINE INPUT TYPE (FILE OR URL)
# ============================================================================

if [[ $PLUGIN_INPUT == http* ]]; then
    # Input is a URL
    echo -e "${YELLOW}Downloading plugin from URL...${NC}"
    echo ""
    
    # Extract filename from URL
    PLUGIN_FILENAME=$(basename "$PLUGIN_INPUT" | sed 's/?.*//')
    PLUGIN_PATH="$PLUGIN_DIR/$PLUGIN_FILENAME"
    
    echo -e "${CYAN}→${NC} URL: $PLUGIN_INPUT"
    echo -e "${CYAN}→${NC} File: $PLUGIN_FILENAME"
    echo ""
    
    # Download the file
    if wget -q -O "$PLUGIN_PATH" "$PLUGIN_INPUT"; then
        echo -e "${GREEN}✅ Download successful${NC}"
    else
        echo -e "${RED}❌ Download failed!${NC}"
        echo ""
        echo "Possible causes:"
        echo "  • Invalid URL"
        echo "  • Network error"
        echo "  • Server requires authentication"
        echo ""
        exit 1
    fi
    
else
    # Input is a local file
    if [ ! -f "$PLUGIN_INPUT" ]; then
        echo -e "${RED}❌ File not found: $PLUGIN_INPUT${NC}"
        echo ""
        exit 1
    fi
    
    PLUGIN_FILENAME=$(basename "$PLUGIN_INPUT")
    PLUGIN_PATH="$PLUGIN_DIR/$PLUGIN_FILENAME"
    
    echo -e "${YELLOW}Copying plugin file...${NC}"
    echo ""
    echo -e "${CYAN}→${NC} From: $PLUGIN_INPUT"
    echo -e "${CYAN}→${NC} To: $PLUGIN_PATH"
    echo ""
    
    cp "$PLUGIN_INPUT" "$PLUGIN_PATH"
    echo -e "${GREEN}✅ File copied${NC}"
fi

echo ""

# ============================================================================
# VERIFY PLUGIN
# ============================================================================

echo -e "${YELLOW}Verifying plugin...${NC}"
echo ""

if [ ! -f "$PLUGIN_PATH" ]; then
    echo -e "${RED}❌ Plugin file verification failed!${NC}"
    exit 1
fi

PLUGIN_SIZE=$(du -h "$PLUGIN_PATH" | awk '{print $1}')

echo -e "${BLUE}Plugin Information:${NC}"
echo "  Name: ${CYAN}$PLUGIN_FILENAME${NC}"
echo "  Size: ${GREEN}$PLUGIN_SIZE${NC}"
echo "  Location: ${CYAN}$PLUGIN_PATH${NC}"

echo ""

# ============================================================================
# ASK ABOUT RESTART
# ============================================================================

echo -e "${YELLOW}Plugin installation options:${NC}"
echo ""

while true; do
    read -p "Restart server now to load plugin? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        RESTART=true
        break
    elif [[ $REPLY =~ ^[Nn]$ ]]; then
        RESTART=false
        break
    else
        echo "Please answer y or n"
    fi
done

echo ""

# ============================================================================
# RESTART SERVER (IF CHOSEN)
# ============================================================================

if [ "$RESTART" = true ]; then
    
    if docker ps --format '{{.Names}}' | grep -q "^papermc-server$"; then
        
        echo -e "${YELLOW}Restarting server...${NC}"
        echo ""
        
        # Stop server
        docker exec papermc-server rcon-cli save-all > /dev/null 2>&1 || true
        sleep 2
        docker exec papermc-server rcon-cli stop > /dev/null 2>&1 || true
        
        # Wait for stop
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
        
        sleep 3
        
        # Start server
        docker start papermc-server
        sleep 2
        
        echo -e "${GREEN}✅ Server restarted${NC}"
        echo ""
        echo "View startup logs:"
        echo "  ${BLUE}./scripts/logs.sh${NC}"
        
    else
        echo -e "${YELLOW}Server is not running. Start with:${NC}"
        echo "  ${BLUE}./scripts/start.sh${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  Server not restarted${NC}"
    echo ""
    echo "To load the plugin, restart with:"
    echo "  ${BLUE}./scripts/restart.sh${NC}"
    echo ""
    echo "Or stop and manually start:"
    echo "  ${BLUE}./scripts/stop.sh${NC}"
    echo "  ${BLUE}./scripts/start.sh${NC}"
fi

echo ""

# ============================================================================
# FINAL STATUS
# ============================================================================

echo -e "${BLUE}Installed Plugins:${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ -z "$(ls -A $PLUGIN_DIR/*.jar 2>/dev/null)" ]; then
    echo "No plugins installed yet"
else
    ls -lh $PLUGIN_DIR/*.jar 2>/dev/null | awk '{printf "%-30s  %8s\n", $9, $5}' | sed 's|'$PLUGIN_DIR'/||g'
fi

echo ""

echo -e "${GREEN}✨ Plugin installation complete!${NC}"
echo ""