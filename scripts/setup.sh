#!/bin/bash

##############################################################################
# MINECRAFT SERVER SETUP SCRIPT
# 
# Purpose: Initial setup for Minecraft server
# What it does:
#   - Checks Docker installation
#   - Creates necessary directories
#   - Creates config files if they don't exist
#   - Provides next steps
#
# Usage: ./scripts/setup.sh
##############################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}"
echo "╔════════════════════════════════════════════════════════╗"
echo "║       Minecraft Server - Initial Setup Script          ║"
echo "╚════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

# ============================================================================
# 1. CHECK DOCKER INSTALLATION
# ============================================================================

echo -e "${YELLOW}[1/5] Checking Docker installation...${NC}"

if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker not found!${NC}"
    echo ""
    echo "Please install Docker first:"
    echo "  Ubuntu/Debian: https://docs.docker.com/engine/install/ubuntu/"
    echo "  Windows: https://docs.docker.com/desktop/install/windows-install/"
    echo "  macOS: https://docs.docker.com/desktop/install/mac-install/"
    exit 1
fi

echo -e "${GREEN}✅ Docker found: $(docker --version)${NC}"

if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo -e "${RED}❌ Docker Compose not found!${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Docker Compose ready${NC}"
echo ""

# ============================================================================
# 2. CREATE NECESSARY DIRECTORIES
# ============================================================================

echo -e "${YELLOW}[2/5] Creating directories...${NC}"

directories=(
    "data"
    "data/plugins"
    "backups"
    "logs"
    "tools"
    "scripts"
)

for dir in "${directories[@]}"; do
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        echo -e "${GREEN}✅ Created: $dir${NC}"
    else
        echo -e "${BLUE}ℹ️  Already exists: $dir${NC}"
    fi
done

echo ""

# ============================================================================
# 3. CREATE DOCKER-COMPOSE.YML
# ============================================================================

echo -e "${YELLOW}[3/5] Setting up docker-compose.yml...${NC}"

if [ ! -f docker-compose.yml ]; then
    echo -e "${GREEN}✅ Creating docker-compose.yml${NC}"
    cat > docker-compose.yml <<'EOF'
version: '3.8'

services:
  papermc:
    image: itzg/minecraft-server:latest
    container_name: papermc-server
    ports:
      - "25565:25565"
    environment:
      EULA: "TRUE"
      TYPE: "PAPER"
      VERSION: "LATEST"
      MEMORY: "2G"
      NOGUI: "true"
      DIFFICULTY: "1"
      MAX_PLAYERS: "20"
      MOTD: "§6Welcome to PaperMC Server!"
      PVP: "true"
      VIEW_DISTANCE: "10"
      SIMULATION_DISTANCE: "10"
    volumes:
      - ./data:/data
    restart: unless-stopped
    networks:
      - minecraft-net

networks:
  minecraft-net:
    driver: bridge
EOF
else
    echo -e "${BLUE}ℹ️  docker-compose.yml already exists${NC}"
fi

echo ""

# ============================================================================
# 4. CREATE .ENV FILE
# ============================================================================

echo -e "${YELLOW}[4/5] Setting up .env configuration...${NC}"

if [ ! -f .env ]; then
    echo -e "${GREEN}✅ Creating .env file${NC}"
    cat > .env <<'EOF'
# Server Configuration
SERVER_MEMORY=2G
SERVER_NAME="My Minecraft Server"
DIFFICULTY=1
MAX_PLAYERS=20
GAMEMODE=0
PVP=true
ALLOW_FLIGHT=false
SPAWN_PROTECTION=16

# View Distance
VIEW_DISTANCE=10
SIMULATION_DISTANCE=10

# Whitelist
WHITELIST_ENABLED=false

# Logging
LOG_LEVEL=INFO

# Backup
BACKUP_ENABLED=true
BACKUP_INTERVAL=3600
BACKUP_KEEP=10
EOF
else
    echo -e "${BLUE}ℹ️  .env file already exists${NC}"
fi

echo ""

# ============================================================================
# 5. CREATE .GITIGNORE (for Git users)
# ============================================================================

echo -e "${YELLOW}[5/5] Creating .gitignore...${NC}"

if [ ! -f .gitignore ]; then
    echo -e "${GREEN}✅ Creating .gitignore${NC}"
    cat > .gitignore <<'EOF'
# Data folders
data/
backups/
logs/
tools/playit*
tools/playit.exe

# System files
.DS_Store
Thumbs.db
*.swp
*.swo
*~

# IDE
.vscode/
.idea/
*.code-workspace

# Environment
.env.local
EOF
else
    echo -e "${BLUE}ℹ️  .gitignore already exists${NC}"
fi

echo ""

# ============================================================================
# FINAL STATUS & NEXT STEPS
# ============================================================================

echo -e "${GREEN}"
echo "╔════════════════════════════════════════════════════════╗"
echo "║              ✅ Setup Complete!                        ║"
echo "╚════════════════════════════════════════════════════════╝"
echo -e "${NC}"

echo ""
echo -e "${BLUE}📁 Directory Structure:${NC}"
echo "  ✅ data/           - World data and configs"
echo "  ✅ backups/        - World backups"
echo "  ✅ logs/           - Log files"
echo "  ✅ scripts/        - Management scripts"
echo "  ✅ tools/          - External tools (playit.gg)"
echo ""

echo -e "${BLUE}📝 Configuration Files:${NC}"
echo "  ✅ docker-compose.yml - Docker setup"
echo "  ✅ .env             - Server settings"
echo "  ✅ .gitignore       - Git exclusions"
echo ""

echo -e "${YELLOW}🚀 Next Steps:${NC}"
echo ""
echo "  1. Make scripts executable:"
echo -e "     ${BLUE}chmod +x scripts/*.sh${NC}"
echo ""
echo "  2. Start the server:"
echo -e "     ${BLUE}./scripts/start.sh${NC}"
echo ""
echo "  3. Watch the startup process:"
echo -e "     ${BLUE}./scripts/logs.sh${NC}"
echo "     (Wait for 'Done! For help, type help')"
echo ""
echo "  4. Test locally in Minecraft:"
echo "     Multiplayer → Direct Connect → localhost"
echo ""
echo "  5. Setup playit.gg for public access:"
echo -e "     Visit: ${BLUE}https://playit.gg/download${NC}"
echo "     Download agent and follow dashboard instructions"
echo ""
echo "  6. View all available commands:"
echo -e "     ${BLUE}./scripts/menu.sh${NC}"
echo ""

echo -e "${YELLOW}💡 Tips:${NC}"
echo "  • Edit .env to customize server settings"
echo "  • Use ./scripts/menu.sh for interactive management"
echo "  • Check ./scripts/logs.sh if you encounter issues"
echo "  • Run backups regularly: ./scripts/backup.sh"
echo ""

echo -e "${GREEN}Happy Gaming! 🎮${NC}"
echo ""
