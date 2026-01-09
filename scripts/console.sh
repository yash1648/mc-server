#!/bin/bash

##############################################################################
# ADMIN CONSOLE SCRIPT
#
# Purpose: Interactive admin console for server commands
# What it does:
#   - Allows running commands on the server interactively
#   - Execute RCON commands without restarting
#   - Manage players, settings, etc. in real-time
#
# Usage: ./scripts/console.sh
# Exit: Type 'exit' or press Ctrl+C
#
# Common Commands:
#   say <message>              - Send message to all players
#   op <player>                - Make player admin
#   deop <player>              - Remove admin status
#   whitelist add <player>     - Add to whitelist
#   give <player> <item> [amount] - Give item to player
#   teleport <player> x y z    - Teleport player
#   gamemode <mode> <player>   - Change gamemode
#   difficulty <level>         - Change difficulty
#   weather <clear|rain|thunder> - Change weather
#   save-all                   - Save world
#   help                       - Show commands
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
echo "║         🖥️  Minecraft Admin Console                   ║"
echo "╚════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

# ============================================================================
# CHECK IF SERVER IS RUNNING
# ============================================================================

if ! docker ps --format '{{.Names}}' | grep -q "^papermc-server$"; then
    echo -e "${RED}❌ Server is not running!${NC}"
    echo ""
    echo "Start the server with:"
    echo -e "  ${BLUE}./scripts/start.sh${NC}"
    echo ""
    exit 1
fi

# ============================================================================
# DISPLAY HELP
# ============================================================================

echo -e "${CYAN}Available Commands:${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo -e "${YELLOW}Messages:${NC}"
echo "  say <message>              - Broadcast message"
echo "  title <player> <text>      - Show title to player"
echo ""
echo -e "${YELLOW}Player Management:${NC}"
echo "  op <player>                - Make admin"
echo "  deop <player>              - Remove admin"
echo "  whitelist add <player>     - Add to whitelist"
echo "  whitelist remove <player>  - Remove from whitelist"
echo "  kick <player>              - Kick player"
echo "  ban <player>               - Ban player"
echo ""
echo -e "${YELLOW}Inventory:${NC}"
echo "  give @a <item>             - Give to all players"
echo "  give <player> diamond 64   - Give diamonds"
echo "  clear <player>             - Clear inventory"
echo ""
echo -e "${YELLOW}Teleport:${NC}"
echo "  teleport <player> x y z    - Teleport to coords"
echo "  teleport <p1> <p2>         - Teleport between players"
echo ""
echo -e "${YELLOW}Game Settings:${NC}"
echo "  gamemode creative <player> - Change gamemode"
echo "  difficulty hard            - Change difficulty"
echo "  weather clear              - Clear weather"
echo "  time set noon              - Set time"
echo ""
echo -e "${YELLOW}Server:${NC}"
echo "  save-all                   - Save world"
echo "  stop                       - Shutdown server"
echo "  help                       - Show command help"
echo "  plugins                    - List plugins"
echo ""
echo -e "${YELLOW}Special:${NC}"
echo "  exit / quit                - Exit console"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ============================================================================
# COMMAND LOOP
# ============================================================================

while true; do
    read -p "${GREEN}>${NC} " command
    
    # Check for exit commands
    if [ "$command" = "exit" ] || [ "$command" = "quit" ]; then
        echo ""
        echo -e "${YELLOW}Exiting console...${NC}"
        echo ""
        break
    fi
    
    # Skip empty commands
    if [ -z "$command" ]; then
        continue
    fi
    
    # Show feedback
    echo -e "${CYAN}Executing: $command${NC}"
    
    # Execute command via RCON
    if docker exec papermc-server rcon-cli "$command"; then
        :  # Success, do nothing (command output already shown)
    else
        echo -e "${RED}⚠️  Command may have failed or returned nothing${NC}"
    fi
    
    echo ""
done

echo -e "${GREEN}✨ Console closed.${NC}"
echo ""
