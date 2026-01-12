# 📜 Scripts Documentation

This directory contains all the Bash scripts used to manage the Minecraft server. Each script is designed to perform a specific task, from starting the server to managing backups and plugins.

## 📋 Script List

| Script | Purpose | Usage |
|--------|---------|-------|
| [`setup.sh`](#setupsh) | Initial server setup | `./scripts/setup.sh` |
| [`start.sh`](#startsh) | Start the server | `./scripts/start.sh` |
| [`stop.sh`](#stopsh) | Gracefully stop the server | `./scripts/stop.sh` |
| [`restart.sh`](#restartsh) | Restart the server | `./scripts/restart.sh` |
| [`status.sh`](#statussh) | Check server status | `./scripts/status.sh` |
| [`logs.sh`](#logssh) | View live server logs | `./scripts/logs.sh` |
| [`console.sh`](#consolesh) | Interactive admin console | `./scripts/console.sh` |
| [`backup.sh`](#backupsh) | Create world backup | `./scripts/backup.sh` |
| [`add-plugin.sh`](#add-pluginsh) | Install a plugin | `./scripts/add-plugin.sh <file/url>` |
| [`menu.sh`](#menush) | Interactive menu interface | `./scripts/menu.sh` |

---

## 🛠️ Detailed Documentation

### setup.sh
**Purpose:** Initial setup for Minecraft server.
**What it does:**
- Checks Docker installation.
- Creates necessary directories (`data`, `plugins`, `backups`, etc.).
- Creates config files (`docker-compose.yml`, `.env`) if they don't exist.
- Provides next steps.

**Usage:**
```bash
./scripts/setup.sh
```

### start.sh
**Purpose:** Start the Minecraft server.
**What it does:**
- Checks if the container already exists.
- Starts the Docker container with PaperMC.
- Displays container status.

**Usage:**
```bash
./scripts/start.sh
```

### stop.sh
**Purpose:** Gracefully stop the Minecraft server.
**What it does:**
- Sends `save-all` command to save the world.
- Sends `stop` command to gracefully shut down.
- Waits for the Docker container to stop.
- Displays status.

**Usage:**
```bash
./scripts/stop.sh
```

### restart.sh
**Purpose:** Restart the Minecraft server.
**What it does:**
- Stops the server gracefully (calls `stop.sh`).
- Starts it back up (calls `start.sh`).
- Useful after installing plugins or making configuration changes.

**Usage:**
```bash
./scripts/restart.sh
```

### status.sh
**Purpose:** Check Minecraft server status and resource usage.
**What it does:**
- Shows if the server is running or stopped.
- Displays resource usage (CPU, memory).
- Shows port bindings.
- Shows container info and disk usage.

**Usage:**
```bash
./scripts/status.sh
```

### logs.sh
**Purpose:** View live server logs (real-time streaming).
**What it does:**
- Displays server logs as they happen.
- Useful for debugging and monitoring.
- Shows startup process, errors, and player activity.

**Usage:**
```bash
./scripts/logs.sh
```
*Press `Ctrl+C` to exit.*

### console.sh
**Purpose:** Interactive admin console for server commands.
**What it does:**
- Allows running commands on the server interactively.
- Executes RCON commands without restarting.
- Manages players, settings, etc., in real-time.

**Usage:**
```bash
./scripts/console.sh
```
**Common Commands:**
- `say <message>`: Broadcast message.
- `op <player>`: Make player admin.
- `whitelist add <player>`: Add to whitelist.
- `help`: Show commands.

### backup.sh
**Purpose:** Create and manage world backups.
**What it does:**
- Saves the world to a compressed archive (`.tar.gz`).
- Creates timestamped backup files.
- Automatically removes old backups (keeps the last 10).
- Saves in the `backups/` directory.

**Usage:**
```bash
./scripts/backup.sh
```

### add-plugin.sh
**Purpose:** Install Minecraft plugins easily.
**What it does:**
- Accepts plugin from a local file or URL.
- Copies the plugin to the `data/plugins` directory.
- Can handle direct downloads from URLs.

**Usage:**
```bash
# From local file
./scripts/add-plugin.sh /path/to/plugin.jar

# From URL
./scripts/add-plugin.sh https://example.com/plugin.jar
```

### menu.sh
**Purpose:** Main interactive menu for server management.
**What it does:**
- Provides a GUI-like menu interface.
- Allows easy navigation without remembering commands.
- Shows status and options.

**Usage:**
```bash
./scripts/menu.sh
```

---

## 🔗 Dependencies

All scripts rely on:
- **Docker**: To run the Minecraft server container.
- **Docker Compose**: To manage the container configuration.
- **Bash**: The shell environment to run the scripts.

Ensure these are installed before running the scripts (except `setup.sh` which checks for them).
