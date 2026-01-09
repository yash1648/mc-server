#!/bin/bash

##############################################################################
# LOGS VIEWER SCRIPT
#
# Purpose: View live server logs (real-time streaming)
# What it does:
#   - Displays server logs as they happen
#   - Useful for debugging and monitoring
#   - Shows startup process, errors, player activity
#
# Usage: ./scripts/logs.sh
# Exit: Press Ctrl+C
#
# What to look for:
#   - "Done! For help, type help" = Server fully started
#   - "[WARN]" = Warning (usually okay)
#   - "[ERROR]" = Error (may need attention)
#   - "Player logged in" = Someone joined
##############################################################################

# Colors for output
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}"
echo "╔════════════════════════════════════════════════════════╗"
echo "║         📋 Minecraft Server Logs (Live Stream)        ║"
echo "╚════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""
echo "📌 Tips:"
echo "  • Wait for 'Done! For help, type help' before joining"
echo "  • Press Ctrl+C to exit log viewer"
echo "  • [WARN] = warnings (usually fine)"
echo "  • [ERROR] = errors (may need fixing)"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Stream logs from Docker container
docker logs -f papermc-server
