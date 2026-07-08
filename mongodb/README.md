# MongoDB Containerized Project

A comprehensive learning project demonstrating MongoDB containerization with Docker Compose, featuring database initialization, backup/restore capabilities, and best practice configurations.

**Author:** FarshadRavaee@gmail.com  
**Last Updated:** 2026-07-08

---

## 📋 Table of Contents

- [Overview](#overview)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
- [Services](#services)
- [Database Initialization](#database-initialization)
- [MongoDB Shell Guide](#mongodb-shell-guide)
- [Backup & Restore](#backup--restore)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)

---

## 🎯 Overview

This project containerizes MongoDB 8.2 using Docker Compose with:

- **MongoDB Database Server** - Official MongoDB Community Server running on port 27017
- **MongoDB Tools Container** - Dedicated service for backup/restore operations
- **Automated Initialization** - Database, user, and collection creation on container startup
- **Health Checks** - Built-in monitoring to ensure database availability
- **Persistent Data** - Docker named volume for data persistence
- **Backup/Restore Scripts** - Production-ready shell scripts for data management

---

## 📁 Project Structure

```
mongodb/
├── compose.yaml                    # Docker Compose configuration
├── .env.example                    # Environment variables template
├── README.md                       # This file
├── mongosh.README.md              # MongoDB Shell command reference
├── config/
│   └── init.js                    # MongoDB initialization script
└── tools/
    ├── Dockerfile.mongoTools      # Tools container image definition
    ├── backup.sh                  # Backup script (external)
    ├── backup_inside_container.sh # Backup script (internal)
    ├── restore.sh                 # Restore script (external)
    └── restore inside_container.sh # Restore script (internal)
```

---

## ✅ Prerequisites

- Docker (version 20.10 or later)
- Docker Compose (version 2.0 or later)
- Bash shell
- 2GB available disk space (for containers and data)

---

## 🚀 Quick Start

### 1. Setup Environment Variables

```bash
cp .env.example .env
```

Edit `.env` with your desired credentials:

```dotenv
MONGODB_INITDB_ROOT_USERNAME=admin
MONGODB_INITDB_ROOT_PASSWORD=123!
```

### 2. Start the Containers

```bash
docker compose up --build -d
```

This command will:
- Build the MongoDB Tools image
- Start MongoDB server with health checks
- Execute initialization scripts
- Create persistent data volume
- Establish internal networking

### 3. Verify Setup

```bash
docker compose ps
```

Expected output:
```
NAME                  STATUS              PORTS
mongodb-mongodb-1     Up (healthy)        0.0.0.0:27017->27017/tcp
mongodb-tools-1       Up                  
```

---

## ⚙️ Configuration

### Environment Variables (`.env`)

```dotenv
MONGODB_INITDB_ROOT_USERNAME=admin           # Root admin username
MONGODB_INITDB_ROOT_PASSWORD=123!            # Root admin password
```

**Security Note:** Change default passwords before deploying to production!

### compose.yaml Highlights

```yaml
services:
  mongodb:
    image: mongodb/mongodb-community-server:8.2-ubuntu2204-slim
    hostname: mongodb
    ports:
      - "27017:27017"
    healthcheck:
      test: ["CMD", "mongosh", "--quiet", "--eval", "db.adminCommand('ping')"]
      interval: 30s                          # Check every 30 seconds
      timeout: 10s
      retries: 3
      start_period: 20s
    volumes:
      - ./config/init.js:/docker-entrypoint-initdb.d/init.js  # Read-only
      - mongo-data:/data/db                  # Persistent storage
```

---

## 🔧 Services

### MongoDB Server

- **Image:** `mongodb/mongodb-community-server:8.2-ubuntu2204-slim`
- **Port:** 27017
- **Hostname:** `mongodb`
- **Restart Policy:** Unless stopped
- **Health Check:** Enabled (pings every 30 seconds)
- **Data Volume:** `mongo-data` (persistent)

### MongoDB Tools

- **Purpose:** Backup and restore operations
- **Depends On:** MongoDB Server
- **Built From:** `./tools/Dockerfile.mongoTools`
- **Backup Directory:** `/backup_files` (bind mount to `./backup_files/`)

---

## 🗄️ Database Initialization

The MongoDB container automatically executes scripts in `/docker-entrypoint-initdb.d/` during first startup.

### Default Initialization (`config/init.js`)

The initialization script creates:

**Database:** `appdb`

**User:** `appuser`
- Password: `apppassword` (change in production)
- Permissions: `readWrite` on `appdb`

**Collection:** `users`

**Sample Document:**
```javascript
{
  name: "Administrator",
  createdAt: ISODate("2026-07-08T...")
}
```

### Customize Initialization

Edit `config/init.js` to add your own collections, indexes, or data:

```javascript
db = db.getSiblingDB("inventory");

db.createCollection("products");

db.products.insertMany([
  { name: "Laptop", price: 1000, stock: 5 },
  { name: "Mouse", price: 25, stock: 50 }
]);
```

---

## 🛠️ MongoDB Shell Guide

### Access MongoDB Container

```bash
docker exec -it mongodb-mongodb-1 mongosh
```

### Authentication

```javascript
use admin
db.auth("admin", "secretpassword")
```

For comprehensive command reference, see `mongosh.README.md`.

---

## 💾 Backup & Restore

### Backup Operations

#### Quick Backup (Using compose)

```bash
docker compose run --rm tools ./backup.sh
```

**What it does:**
- Creates timestamped backup directory: `./backup_files/YYYY-MM-DD-HH:MM`
- Uses `mongodump` with root credentials
- Authenticates against admin database
- Stores BSON dump of all databases

**Example output:**
```
Backup created in /backup_files/2026-07-08-14:30
```

#### Backup Validation

List available backups:
```bash
ls -la ./backup_files/
```

View backup structure:
```bash
tree ./backup_files/2026-07-08-14:30
```

### Restore Operations

#### Quick Restore (Using compose)

```bash
docker compose run --rm tools ./restore.sh 2026-07-08-14:30
```

**Parameters:**
- `<backup-timestamp>` - Directory name from backup (format: YYYY-MM-DD-HH:MM)

**What it does:**
- Locates backup in `./backup_files/<timestamp>`
- Uses `mongorestore` with root credentials
- Drops existing databases and restores from backup
- Authenticates against admin database

**Example:**
```bash
docker compose run --rm tools ./restore.sh 2026-07-08-08:50
```

#### Important Notes

⚠️ **Data Loss Warning:** The restore script uses the `--drop` flag, which **deletes existing databases before restoring**. Ensure you have a backup of current data before restoring.

---

## ✨ Best Practices

### 1. **Security**

- Change default credentials in `.env` before production deployment
- Use strong, unique passwords for application users
- Never commit `.env` with real credentials to version control
- Keep MongoDB image updated to latest patch version

### 2. **Data Management**

- Regular automated backups (daily recommended)
- Test restore procedures periodically
- Keep backups in multiple locations (local + external storage)
- Document backup retention policies

### 3. **Performance**

- Monitor MongoDB logs regularly
- Create indexes on frequently queried fields
- Use connection pooling for application connections
- Monitor disk space to prevent write errors

### 4. **Maintenance**

- Rebuild indexes periodically: `db.collection.reIndex()`
- Monitor health checks: `docker compose ps`
- Update Docker image regularly
- Review and archive old backups

### 5. **Deployment**

- Use Docker networks for inter-container communication (configured)
- Enable restart policies (configured as `unless-stopped`)
- Use volumes for persistence (configured)
- Implement health checks (configured)

---

## 🐛 Troubleshooting

### Container Won't Start

**Check logs:**
```bash
docker compose logs mongodb
```

**Common causes:**
- Port 27017 already in use: `lsof -i :27017`
- Insufficient disk space: `df -h`
- Permission issues: `ls -la ./backup_files`

### Connection Refused

```bash
# Verify container is healthy
docker compose ps

# Check if port is listening
netstat -tlnp | grep 27017

# Test connection
docker exec mongodb-mongodb-1 mongosh --eval "db.adminCommand('ping')"
```

### Authentication Failed

```javascript
// Verify admin credentials
db = db.getSiblingDB("admin")
db.auth("admin", "secretpassword")

// List all users
db.getUsers()

// Reset admin password
db.changeUserPassword("admin", "newpassword")
```

### Backup/Restore Issues

**Backup fails:**
```bash
# Check MongoDB is running
docker compose ps

# Verify credentials in .env
grep MONGODB_INITDB .env

# Check backup directory permissions
ls -la ./backup_files/
```

**Restore fails:**
```bash
# Verify backup directory exists
ls -la ./backup_files/2026-07-08-14:30

# Check MongoDB has space
docker exec mongodb-mongodb-1 df -h
```

### Performance Issues

```javascript
// Check current operations
db.currentOp()

// Check indexes
db.collection.getIndexes()

// Get database statistics
db.stats()
```

---

## 📚 Additional Resources

- [MongoDB Official Documentation](https://docs.mongodb.com/)
- [MongoDB Docker Hub](https://hub.docker.com/r/mongodb/mongodb-community-server)
- [MongoDB Shell (mongosh) Guide](https://www.mongodb.com/docs/mongodb-shell/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)

---

## 📝 License

This project is provided as-is for educational purposes.

---

## 👨‍💼 Contact

**Author:** FarshadRavaee@gmail.com  
**Project URL:** [GitHub Repository](https://github.com/farshadr1/DBs_dockerCompose_lab)

---

**Happy MongoDB Learning! 🎉**
