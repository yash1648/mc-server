# 🎮 Minecraft Server - Quick Reference & Cheat Sheet

## 📌 One-Page Quick Start

```bash
# 1. Create directory and go there
mkdir -p ~/minecraft-server && cd ~/minecraft-server

# 2. Create subdirectories
mkdir -p scripts data backups tools

# 3. Create all files (copy content from provided files)
# - docker-compose.yml (root)
# - .env (root)
# - scripts/setup.sh
# - scripts/start.sh
# - scripts/stop.sh
# - scripts/restart.sh
# - scripts/status.sh
# - scripts/logs.sh
# - scripts/backup.sh
# - scripts/add-plugin.sh
# - scripts/console.sh
# - scripts/menu.sh

# 4. Make scripts executable
chmod +x scripts/*.sh

# 5. Initial setup
./scripts/setup.sh

# 6. Start server
./scripts/start.sh

# 7. Watch startup logs
./scripts/logs.sh
# Wait for: "Done! For help, type help"

# 8. Test locally
# Open Minecraft → Multiplayer → Direct Connect → localhost

# 9. Setup playit.gg for public access
# Download from: https://playit.gg/download
# Run in tools/ folder
# Create tunnel for port 25565
```

---

## 🎮 Common Tasks & Commands

### **Starting & Stopping**

```bash
# Start server
./scripts/start.sh

# Stop server (gracefully)
./scripts/stop.sh

# Restart server
./scripts/restart.sh

# Check if running
./scripts/status.sh
```

### **Monitoring & Debugging**

```bash
# View live logs
./scripts/logs.sh
# (Press Ctrl+C to exit)

# Check server status & resources
./scripts/status.sh

# See all backups
ls -lh backups/

# Check disk usage
du -sh data/
du -sh backups/
```

### **Plugins & Management**

```bash
# Add plugin from file
./scripts/add-plugin.sh ~/Downloads/plugin.jar

# Add plugin from URL
./scripts/add-plugin.sh https://example.com/plugin.jar

# Open admin console
./scripts/console.sh
# Then type commands like:
#   say Hello everyone!
#   op PlayerName
#   give @a diamond

# Interactive menu
./scripts/menu.sh
```

### **Backups**

```bash
# Create backup now
./scripts/backup.sh

# List all backups
ls -lh backups/

# Restore from backup (manual)
# 1. Stop server: ./scripts/stop.sh
# 2. Extract: tar -xzf backups/backup_YYYYMMDD_HHMMSS.tar.gz -C data/
# 3. Start: ./scripts/start.sh
```

---

## 📝 Console Commands (Use ./scripts/console.sh)

### **Broadcasting**
```
say Welcome everyone!
say Server restarting in 10 seconds
title @a title {"text":"RESTART!","color":"red"}
```

### **Player Management**
```
op PlayerName              # Make admin
deop PlayerName            # Remove admin
whitelist add PlayerName   # Add to whitelist
whitelist remove PlayerName # Remove whitelist
kick PlayerName            # Kick player
ban PlayerName             # Ban player
```

### **Inventory**
```
give @a diamond            # Give diamonds to all
give PlayerName apple 64   # Give apples
clear PlayerName           # Clear inventory
give @s netherite_sword    # Give yourself sword
```

### **Teleportation**
```
teleport PlayerName 0 64 0 # Teleport to coords
teleport Player1 Player2   # Teleport between players
tp @a 100 100 100         # Teleport all players
```

### **Game Settings**
```
gamemode creative @s       # Creative mode (yourself)
gamemode survival PlayerName # Survival mode
gamemode adventure @a      # Adventure mode (all)
difficulty hard            # Hard difficulty
weather clear              # Clear weather
weather rain               # Start rain
time set noon              # Set to noon
time set midnight          # Set to midnight
```

### **Server Commands**
```
save-all                   # Save world immediately
plugins                    # List loaded plugins
help                       # Show help
stop                       # Shutdown server (graceful)
```

---

## ⚙️ Configuration Quick Reference

### **docker-compose.yml Key Settings**

```yaml
MEMORY: "2G"           # RAM: 2G (small), 4G (medium), 8G (large)
VERSION: "LATEST"      # Auto-update or specify: "1.20.4"
DIFFICULTY: "1"        # 0=Peaceful, 1=Easy, 2=Normal, 3=Hard
MAX_PLAYERS: "20"      # Maximum concurrent players
GAMEMODE: "0"          # 0=Survival, 1=Creative, 2=Adventure, 3=Spectator
PVP: "true"            # Enable/disable PvP
MOTD: "Welcome!"       # Server message of the day
VIEW_DISTANCE: "10"    # Chunk render distance
```

### **.env File Key Settings**

```bash
SERVER_MEMORY=2G       # Same as docker-compose MEMORY
DIFFICULTY=1           # Same as docker-compose
MAX_PLAYERS=20         # Same as docker-compose
GAMEMODE=0             # Same as docker-compose
PVP=true               # Same as docker-compose
WHITELIST_ENABLED=false # Enable whitelist
```

---

## 🔧 Docker Direct Commands (Advanced)

If scripts don't work, use Docker directly:

```bash
# Start container directly
docker compose up -d

# Stop container directly
docker compose down

# View logs
docker logs -f papermc-server

# Stop gracefully
docker stop papermc-server

# Force kill (last resort)
docker kill papermc-server

# Restart container
docker restart papermc-server

# Check status
docker ps -a

# Show resource usage
docker stats papermc-server

# Enter container shell
docker exec -it papermc-server bash

# Run RCON command directly
docker exec papermc-server rcon-cli say "Hello"

# Copy files to/from container
docker cp file.jar papermc-server:/data/plugins/
docker cp papermc-server:/data/world ./world-backup
```

---

## 🐛 Common Issues & Solutions

### **Server won't start**
```bash
# Check logs
./scripts/logs.sh

# Port in use?
lsof -i :25565  # See what's using port
sudo fuser -k 25565/tcp  # Kill it (careful!)

# Reset container
docker compose down
docker compose up -d
```

### **Can't join locally**
```bash
# Wait longer (takes 30-60 seconds)
./scripts/logs.sh

# Check server is running
./scripts/status.sh

# Try different Minecraft version
# Try offline mode in launcher
```

### **Friends can't join via playit.gg**
```bash
# Check playit is running
ps aux | grep playit

# Restart playit.gg agent
# Kill (Ctrl+C) and restart: ./tools/playit-linux

# Verify tunnel in playit.gg dashboard
# Make sure local address is 127.0.0.1:25565
```

### **Server lagging**
```bash
# Check resource usage
./scripts/status.sh

# Increase memory
# Edit .env: SERVER_MEMORY=4G
./scripts/restart.sh

# Reduce simulation distance in console:
./scripts/console.sh
# Type: gamerule simulationDistance 8
```

### **Low disk space**
```bash
# Check usage
df -h

# Clean old backups
ls -lh backups/
# Manually delete old files

# Compress world (offline)
cd data
tar -czf world-compressed.tar.gz world/
```

---

## 📊 Performance Tuning

### **For Small Servers (2-5 players)**
```
SERVER_MEMORY=2G
VIEW_DISTANCE=8
SIMULATION_DISTANCE=8
MAX_PLAYERS=10
```

### **For Medium Servers (6-15 players)**
```
SERVER_MEMORY=4G
VIEW_DISTANCE=10
SIMULATION_DISTANCE=10
MAX_PLAYERS=20
```

### **For Large Servers (16+ players)**
```
SERVER_MEMORY=8G+
VIEW_DISTANCE=12
SIMULATION_DISTANCE=12
MAX_PLAYERS=50+
```

---

## 🔐 Security Checklist

- [ ] Changed RCON password in `data/server.properties`
- [ ] Enabled whitelist if needed
- [ ] Created regular backups
- [ ] Configured firewall properly
- [ ] Keep software updated
- [ ] Monitor logs for suspicious activity
- [ ] Strong whitelist for public servers
- [ ] Op only trusted players

---

## 📅 Maintenance Schedule

### **Daily**
- Check server is running: `./scripts/status.sh`
- Review recent logs if issues: `./scripts/logs.sh`

### **Weekly**
- Create backup: `./scripts/backup.sh`
- Check disk space: `df -h`
- Review player activity

### **Monthly**
- Update Docker image: `docker pull itzg/minecraft-server`
- Clean old backups (keep last 10)
- Check for plugin updates
- Full server status review

### **As Needed**
- Restart server for plugins: `./scripts/restart.sh`
- Add new players to whitelist
- Install new plugins
- Adjust performance settings

---

## 🎯 File Locations Quick Reference

```
~/minecraft-server/
├── docker-compose.yml      ← Server config
├── .env                    ← Settings
├── scripts/
│   ├── start.sh           ← Start here
│   ├── stop.sh
│   ├── status.sh
│   ├── logs.sh
│   ├── backup.sh
│   ├── add-plugin.sh
│   ├── console.sh
│   └── menu.sh
├── data/                  ← World data (important!)
│   ├── world/
│   ├── plugins/
│   └── server.properties
├── backups/               ← Backups (important!)
└── tools/                 ← playit.gg agent
```

---

## 💡 Pro Tips

1. **Use menu.sh**: If you forget commands, use `./scripts/menu.sh`

2. **Set up backups**: Add to crontab for automatic backups
   ```bash
   crontab -e
   # Add: 0 3 * * * cd ~/minecraft-server && ./scripts/backup.sh
   ```

3. **Keep terminal open**: Server will shut down if terminal closes (unless using `screen` or `nohup`)

4. **Test before major changes**: Create backup before installing plugins or updating

5. **Monitor player activity**: Check logs regularly for errors or suspicious activity

6. **Document settings**: Keep notes of what plugins/settings you have

7. **Update regularly**: Check for server updates and security patches

8. **Network optimization**: High simulation distance = high CPU usage

---

## 🆘 Getting Help

### **If Scripts Fail:**
1. Check logs: `./scripts/logs.sh`
2. Verify Docker: `docker ps`
3. Check file permissions: `ls -la scripts/`
4. Look for error messages

### **If Server Crashes:**
1. Check logs: `./scripts/logs.sh`
2. Check backups: `ls backups/`
3. Restore if needed
4. Restart: `./scripts/restart.sh`

### **Resources:**
- PaperMC Docs: https://docs.papermc.io/
- Docker Docs: https://docs.docker.com/
- playit.gg Support: https://playit.gg/support
- Spigot Forums: https://www.spigotmc.org/forums/

---

## ✨ Quick Command Aliases (Optional)

Add to your `.bashrc` or `.zshrc` for faster commands:

```bash
alias mc-start='cd ~/minecraft-server && ./scripts/start.sh'
alias mc-stop='cd ~/minecraft-server && ./scripts/stop.sh'
alias mc-restart='cd ~/minecraft-server && ./scripts/restart.sh'
alias mc-logs='cd ~/minecraft-server && ./scripts/logs.sh'
alias mc-status='cd ~/minecraft-server && ./scripts/status.sh'
alias mc-backup='cd ~/minecraft-server && ./scripts/backup.sh'
alias mc-console='cd ~/minecraft-server && ./scripts/console.sh'
alias mc-menu='cd ~/minecraft-server && ./scripts/menu.sh'
```

Then you can just type: `mc-start`, `mc-stop`, etc.

---

## 🎉 You're All Set!

You now have everything to run a professional Minecraft server. Start with:

```bash
cd ~/minecraft-server
./scripts/menu.sh
```

Happy gaming! 🎮

---

**Last Updated**: January 2025 | **Version**: 1.0