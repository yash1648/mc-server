# 📦 Complete File Manifest

## All Files Created (12 Files Total)

Below is a complete list of all files you need to create in your `minecraft-server` directory.

---

## 📋 File List

| # | File | Type | Location | Purpose |
|---|------|------|----------|---------|
| 1 | `docker-compose.yml` | Config | Root | Docker container configuration |
| 2 | `.env` | Config | Root | Server settings & environment variables |
| 3 | `setup.sh` | Script | `scripts/` | Initial setup & directory creation |
| 4 | `start.sh` | Script | `scripts/` | Start the server |
| 5 | `stop.sh` | Script | `scripts/` | Stop the server gracefully |
| 6 | `restart.sh` | Script | `scripts/` | Restart the server |
| 7 | `status.sh` | Script | `scripts/` | Check server status & resources |
| 8 | `logs.sh` | Script | `scripts/` | View live server logs |
| 9 | `backup.sh` | Script | `scripts/` | Create & manage backups |
| 10 | `add-plugin.sh` | Script | `scripts/` | Install plugins |
| 11 | `console.sh` | Script | `scripts/` | Interactive admin console |
| 12 | `menu.sh` | Script | `scripts/` | Interactive management menu |

---

## 🗂️ Directory Structure to Create

```
minecraft-server/
├── docker-compose.yml       ← File 1: Docker configuration
├── .env                     ← File 2: Environment variables
│
├── scripts/                 ← Create this directory
│   ├── setup.sh            ← File 3
│   ├── start.sh            ← File 4
│   ├── stop.sh             ← File 5
│   ├── restart.sh          ← File 6
│   ├── status.sh           ← File 7
│   ├── logs.sh             ← File 8
│   ├── backup.sh           ← File 9
│   ├── add-plugin.sh       ← File 10
│   ├── console.sh          ← File 11
│   └── menu.sh             ← File 12
│
├── data/                   ← Create this (will hold world data)
├── backups/                ← Create this (will hold backups)
└── tools/                  ← Create this (for playit.gg)
```

---

## 📥 How to Set Up All Files

### **Option 1: Manual Creation (Recommended for Learning)**

1. Create the main directory:
```bash
mkdir -p ~/minecraft-server
cd ~/minecraft-server
```

2. Create subdirectories:
```bash
mkdir -p data backups tools scripts
```

3. Copy each file content:
   - Create `docker-compose.yml` and paste the content
   - Create `.env` and paste the content
   - Create each script in `scripts/` directory and paste content

4. Make scripts executable:
```bash
chmod +x scripts/*.sh
```

### **Option 2: Using Git (Fastest)**

If you have the files in a git repository:

```bash
git clone <your-repo-url> minecraft-server
cd minecraft-server
chmod +x scripts/*.sh
./scripts/setup.sh
```

### **Option 3: Automated Download (Advanced)**

Create a setup script that downloads all files:

```bash
#!/bin/bash
mkdir -p minecraft-server/scripts
cd minecraft-server

# Download files from your source
curl -o docker-compose.yml <url>
curl -o .env <url>
curl -o scripts/setup.sh <url>
# ... etc for each file

chmod +x scripts/*.sh
./scripts/setup.sh
```

---

## 📝 File Details & Contents

### **1. docker-compose.yml**
- **What it is**: Docker configuration file
- **Where it goes**: Root directory of minecraft-server
- **What to customize**: `MEMORY`, `DIFFICULTY`, `MAX_PLAYERS`, `MOTD`
- **When to edit**: Initial setup or to change server properties
- **Contains**: Container definition, ports, environment variables, volumes

### **2. .env**
- **What it is**: Environment variables file
- **Where it goes**: Root directory of minecraft-server
- **What to customize**: Server memory, difficulty, max players, PVP settings
- **When to edit**: To change server settings without restarting
- **Contains**: Configuration values referenced by other files

### **3-12. Scripts (in scripts/ directory)**

All scripts do different things:

| Script | Purpose | When to Run |
|--------|---------|------------|
| `setup.sh` | Initial setup | Once, first time only |
| `start.sh` | Start server | When you want to turn it on |
| `stop.sh` | Stop server | When you want to turn it off |
| `restart.sh` | Restart server | After config changes or plugin install |
| `status.sh` | Check status | Anytime to see if server is running |
| `logs.sh` | View logs | To debug or watch startup |
| `backup.sh` | Create backup | Daily/weekly or before major changes |
| `add-plugin.sh` | Install plugin | When you want to add a plugin |
| `console.sh` | Admin console | To run commands (say, op, give, etc.) |
| `menu.sh` | Interactive menu | Easy way to do everything via menu |

---

## ✅ Step-by-Step Setup Checklist

### **Before You Start**
- [ ] Docker is installed and working
- [ ] You have at least 10GB free disk space
- [ ] You have a text editor (nano, vim, VS Code, etc.)

### **Step 1: Create Directory Structure**
```bash
mkdir -p ~/minecraft-server
mkdir -p ~/minecraft-server/scripts
mkdir -p ~/minecraft-server/data
mkdir -p ~/minecraft-server/backups
mkdir -p ~/minecraft-server/tools
cd ~/minecraft-server
```

### **Step 2: Create Configuration Files**

**Create `docker-compose.yml`:**
```bash
nano docker-compose.yml
# Paste content from the docker-compose.yml file
# Save: Ctrl+X, then Y, then Enter
```

**Create `.env`:**
```bash
nano .env
# Paste content from the .env file
# Save: Ctrl+X, then Y, then Enter
```

### **Step 3: Create All Scripts**

For each script file (setup.sh, start.sh, stop.sh, etc.):

```bash
nano scripts/setup.sh
# Paste content from setup.sh file
# Save and exit

nano scripts/start.sh
# Paste content from start.sh file
# Save and exit

# ... repeat for all 10 scripts
```

**Or use cat to create them:**
```bash
cat > scripts/setup.sh << 'EOF'
[paste setup.sh content here]
EOF

# Repeat for each script
```

### **Step 4: Make Scripts Executable**
```bash
chmod +x scripts/*.sh
```

### **Step 5: Verify All Files Exist**
```bash
ls -la
# Should show: docker-compose.yml, .env, scripts/

ls -la scripts/
# Should show: setup.sh, start.sh, stop.sh, restart.sh, status.sh, logs.sh, backup.sh, add-plugin.sh, console.sh, menu.sh
```

### **Step 6: Run Setup**
```bash
./scripts/setup.sh
```

### **Step 7: Start Server**
```bash
./scripts/start.sh
./scripts/logs.sh
# Wait for: "Done! For help, type help"
# Press Ctrl+C to exit logs
```

### **Step 8: Test Locally**
- Open Minecraft Java Edition
- Multiplayer → Direct Connect
- Address: `localhost`
- Join!

### **Step 9: Setup playit.gg (Public Access)**
```bash
# Download from: https://playit.gg/download
# Put in: ~/minecraft-server/tools/

# Run:
cd tools
./playit-linux  # Linux/Mac
# or
playit.exe      # Windows

# Follow login prompts in browser
# Create tunnel for port 25565
# Share public address with friends
```

---

## 🚀 Quick Command Reference

Once all files are set up:

```bash
cd ~/minecraft-server

./scripts/setup.sh        # First time setup
./scripts/start.sh        # Start server
./scripts/stop.sh         # Stop server
./scripts/restart.sh      # Restart server
./scripts/status.sh       # Check status
./scripts/logs.sh         # View logs (Ctrl+C to exit)
./scripts/backup.sh       # Create backup
./scripts/add-plugin.sh   # Add plugin
./scripts/console.sh      # Admin console
./scripts/menu.sh         # Interactive menu
```

---

## 🔍 File Content Summary

### **docker-compose.yml Contents:**
- ✅ Service definition (papermc)
- ✅ Image specification (itzg/minecraft-server)
- ✅ Port mapping (25565)
- ✅ Environment variables
- ✅ Volume mounting for data persistence
- ✅ Network configuration
- ✅ Restart policy

### **.env Contents:**
- ✅ Server memory allocation
- ✅ Difficulty level
- ✅ Max players
- ✅ Game mode
- ✅ PVP settings
- ✅ Whitelist settings
- ✅ View distance
- ✅ MOTD (message of the day)

### **setup.sh Purpose:**
- ✅ Validates Docker installation
- ✅ Creates directories
- ✅ Creates default config files
- ✅ Shows next steps

### **start.sh Purpose:**
- ✅ Starts Docker container
- ✅ Shows status
- ✅ Handles first-time setup

### **stop.sh Purpose:**
- ✅ Gracefully stops server
- ✅ Saves world before stopping
- ✅ Prevents data corruption

### **All Other Scripts:**
- Each has specific function (restart, status, logs, backup, plugins, console, menu)
- Each has built-in help and feedback
- Each handles errors gracefully

---

## ⚠️ Important Notes

1. **File Permissions**: All `.sh` files must be executable
   ```bash
   chmod +x scripts/*.sh
   ```

2. **Line Endings**: If copying from Windows, ensure line endings are Unix (LF not CRLF)
   ```bash
   dos2unix scripts/*.sh  # If needed
   ```

3. **Paths**: All paths in scripts are relative to the minecraft-server directory
   - `data/` folder is relative
   - `backups/` folder is relative
   - `scripts/` folder is relative

4. **Docker Required**: All scripts require Docker to be installed and running

5. **Backup Your Files**: Keep copies of docker-compose.yml and .env somewhere safe

---

## 🆘 Troubleshooting File Setup

### **"Permission denied" when running scripts**
```bash
chmod +x scripts/*.sh
```

### **"No such file or directory" for scripts**
```bash
# Make sure you're in the minecraft-server directory
pwd  # Should show: /home/user/minecraft-server (or similar)

# If not, cd there:
cd ~/minecraft-server

# Then run:
./scripts/start.sh
```

### **"docker: command not found"**
```bash
# Docker not installed. Install it:
# Ubuntu/Debian:
sudo apt install docker.io docker-compose

# Windows: Download Docker Desktop
# macOS: Download Docker Desktop
```

### **Scripts look empty or have weird characters**
- File wasn't copied correctly
- Text encoding issue
- Try recreating the file with proper UTF-8 encoding

### **Config files not found**
```bash
# Verify files exist:
ls -la docker-compose.yml
ls -la .env

# If missing, create them:
touch docker-compose.yml
touch .env
# Then paste content
```

---

## 📚 File Organization Best Practices

### **Good Structure:**
```
minecraft-server/
├── Configuration (in root)
├── Scripts (in scripts/)
├── Data (in data/)
├── Backups (in backups/)
└── Tools (in tools/)
```

### **What to Backup:**
- ✅ `docker-compose.yml` - Keep safe copy
- ✅ `.env` - Keep safe copy
- ✅ `data/` folder - World data (auto-backup with backup.sh)
- ✅ `scripts/` folder - Custom scripts

### **What NOT to backup normally:**
- ❌ `.git/` folder - Excluded via .gitignore
- ❌ System generated files

---

## ✨ Final Verification

Before starting, verify all files exist:

```bash
cd ~/minecraft-server

# Check main config files
test -f docker-compose.yml && echo "✅ docker-compose.yml" || echo "❌ docker-compose.yml"
test -f .env && echo "✅ .env" || echo "❌ .env"

# Check directories
test -d scripts && echo "✅ scripts/" || echo "❌ scripts/"
test -d data && echo "✅ data/" || echo "❌ data/"
test -d backups && echo "✅ backups/" || echo "❌ backups/"

# Check scripts
for script in setup.sh start.sh stop.sh restart.sh status.sh logs.sh backup.sh add-plugin.sh console.sh menu.sh; do
    test -x scripts/$script && echo "✅ scripts/$script" || echo "❌ scripts/$script"
done
```

If all show ✅, you're ready to go!

---

## 🎯 Next Steps

1. **Set up all files** (following the checklist above)
2. **Run `./scripts/setup.sh`** - Initial setup
3. **Run `./scripts/start.sh`** - Start the server
4. **Run `./scripts/logs.sh`** - Watch it start
5. **Test locally** - Join `localhost` in Minecraft
6. **Setup playit.gg** - Public access
7. **Share address** - Invite friends!

---

**You now have everything you need! Good luck! 🎮**