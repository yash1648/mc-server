#!/bin/bash

##############################################################################
# INTERACTIVE MENU SCRIPT
#
# Purpose: Main interactive menu for server management
# What it does:
#   - Provides GUI-like menu interface
#   - Easy navigation without remembering commands
#   - Shows status and options
#
# Usage: ./scripts/menu.sh
##############################################################################

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;31m'
RED='\033[0;31m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m'

# Function to display menu
show_menu() {
    clear
    echo -e "${PURPLE}"
    echo "╔════════════════════════════════════════════════════════╗"
    echo "║       🎮 Minecraft Server Management Menu              ║"
    echo "╚════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    # Check server status
    if docker ps --format '{{.Names}}' | grep -q "^papermc-server$"; then
        STATUS="${GREEN}🟢 RUNNING${NC}"
    else
        STATUS="${RED}🔴 STOPPED${NC}"
    fi
    
    echo -e "Status: $STATUS"
    echo ""
    
    echo -e "${CYAN}SERVER CONTROL${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "  ${BLUE}1${NC})  Start Server"
    echo -e "  ${BLUE}2${NC})  Stop Server"
    echo -e "  ${BLUE}3${NC})  Restart Server"
    echo ""
    
    echo -e "${CYAN}MONITORING${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "  ${BLUE}4${NC})  View Live Logs"
    echo -e "  ${BLUE}5${NC})  Check Server Status"
    echo ""
    
    echo -e "${CYAN}ADMINISTRATION${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "  ${BLUE}6${NC})  Open Admin Console"
    echo -e "  ${BLUE}7${NC})  Show Server Info"
    echo ""
    
    echo -e "${CYAN}MAINTENANCE${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "  ${BLUE}8${NC})  Create Backup"
    echo -e "  ${BLUE}9${NC})  Add Plugin"
    echo -e "  ${BLUE}10${NC}) Edit Configuration"
    echo ""
    
    echo -e "${CYAN}SYSTEM${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "  ${BLUE}11${NC}) Docker Information"
    echo -e "  ${BLUE}12${NC}) Help & Documentation"
    echo -e "  ${BLUE}0${NC})  Exit Menu"
    echo ""
}

# Main menu loop
while true; do
    show_menu
    
    echo -e "${GREEN}Select option (0-12): ${NC}"
	read choice
    
    case $choice in
        
        # Server Control
        1)
            echo ""
            ./scripts/start.sh
            read -p "Press Enter to continue..."
            ;;
        2)
            echo ""
            ./scripts/stop.sh
            read -p "Press Enter to continue..."
            ;;
        3)
            echo ""
            ./scripts/restart.sh
            read -p "Press Enter to continue..."
            ;;
        
        # Monitoring
        4)
            echo ""
            ./scripts/logs.sh
            ;;
        5)
            echo ""
            ./scripts/status.sh
            read -p "Press Enter to continue..."
            ;;
        
        # Administration
        6)
            echo ""
            ./scripts/console.sh
            ;;
        7)
            clear
            echo -e "${BLUE}"
            echo "╔════════════════════════════════════════════════════════╗"
            echo "║         📊 Server Information                          ║"
            echo "╚════════════════════════════════════════════════════════╝"
            echo -e "${NC}"
            echo ""
            
            if docker ps -a --format '{{.Names}}' | grep -q "^papermc-server$"; then
                echo -e "${CYAN}Container Details:${NC}"
                docker ps -a --filter "name=papermc-server" \
                    --format "Name: {{.Names}}\nImage: {{.Image}}\nStatus: {{.Status}}\nPorts: {{.Ports}}"
                echo ""
            fi
            
            echo -e "${CYAN}Storage Info:${NC}"
            if [ -d "data" ]; then
                echo "World Size: $(du -sh data/ 2>/dev/null | awk '{print $1}')"
            fi
            
            if [ -d "backups" ]; then
                BACKUP_COUNT=$(ls -1 backups/backup_*.tar.gz 2>/dev/null | wc -l)
                echo "Backups: $BACKUP_COUNT"
            fi
            
            FREE_SPACE=$(df -h . | awk 'NR==2 {print $4}')
            echo "Free Space: $FREE_SPACE"
            echo ""
            
            read -p "Press Enter to continue..."
            ;;
        
        # Maintenance
        8)
            echo ""
            ./scripts/backup.sh
            read -p "Press Enter to continue..."
            ;;
        9)
            echo ""
            read -p "Enter plugin file or URL: " plugin_input
            if [ -n "$plugin_input" ]; then
                ./scripts/add-plugin.sh "$plugin_input"
            fi
            read -p "Press Enter to continue..."
            ;;
        10)
            # Edit configuration
            if command -v nano &> /dev/null; then
                nano docker-compose.yml
            elif command -v vi &> /dev/null; then
                vi docker-compose.yml
            else
                echo "No text editor found"
            fi
            ;;
        
        # System
        11)
            clear
            echo -e "${BLUE}"
            echo "╔════════════════════════════════════════════════════════╗"
            echo "║         🐳 Docker Information                          ║"
            echo "╚════════════════════════════════════════════════════════╝"
            echo -e "${NC}"
            echo ""
            echo -e "${CYAN}Versions:${NC}"
            docker --version
            docker compose version 2>/dev/null || echo "Docker Compose: Integrated"
            echo ""
            
            echo -e "${CYAN}Containers:${NC}"
            docker ps -a --format "table {{.Names}}\t{{.Status}}"
            echo ""
            
            if docker ps --format '{{.Names}}' | grep -q "^papermc-server$"; then
                echo -e "${CYAN}Resource Usage:${NC}"
                docker stats papermc-server --no-stream
                echo ""
            fi
            
            read -p "Press Enter to continue..."
            ;;
        
        12)
            clear
            echo -e "${BLUE}"
            echo "╔════════════════════════════════════════════════════════╗"
            echo "║         📚 Help & Documentation                        ║"
            echo "╚════════════════════════════════════════════════════════╝"
            echo -e "${NC}"
            echo ""
            echo -e "${CYAN}Quick Start:${NC}"
            echo "  1. Start server with option 1"
            echo "  2. View logs with option 4 (wait for 'Done!')"
            echo "  3. Join via Minecraft: localhost"
            echo ""
            echo -e "${CYAN}Setup playit.gg (public access):${NC}"
            echo "  1. Visit https://playit.gg/download"
            echo "  2. Download agent for your OS"
            echo "  3. Run: ./tools/playit-linux (or .exe for Windows)"
            echo "  4. Create tunnel for port 25565"
            echo "  5. Share public address with friends"
            echo ""
            echo -e "${CYAN}Useful Resources:${NC}"
            echo "  • PaperMC Docs: https://docs.papermc.io/"
            echo "  • Docker Docs: https://docs.docker.com/"
            echo "  • playit.gg Help: https://playit.gg/support"
            echo "  • Plugin Repository: https://www.spigotmc.org/"
            echo ""
            echo -e "${CYAN}Common Commands (in console):${NC}"
            echo "  say <message>          - Broadcast message"
            echo "  op <player>            - Make admin"
            echo "  give @a <item>         - Give to all"
            echo "  gamemode creative @s   - Change gamemode"
            echo "  weather clear          - Clear weather"
            echo ""
            read -p "Press Enter to continue..."
            ;;
        
        0)
            clear
            echo -e "${GREEN}Goodbye! 👋${NC}"
            echo ""
            exit 0
            ;;
        
        *)
            echo ""
            echo -e "${RED}Invalid option. Please try again.${NC}"
            read -p "Press Enter to continue..."
            ;;
    esac
done
