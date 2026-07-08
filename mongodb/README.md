# Mongodb Containerize Project
this is a learning project to use mongodb database. and try to use best practice methods.

## 1. Configure the container with Docker Compose

There is two container:
1.mongoDb server:
    base official image: mongodb/mongodb-community-server:8.2-ubuntu2204-slim
    its use for Database server on port "27017". with hostname "mongo"
2.mongo tools:
    for backup and restore from Database Server 

use `docker compose up --build -d`
to run the project.    


## 2. Initialize MongoDB
The official MongoDB image automatically executes any scripts placed in:
```
/docker-entrypoint-initdb.d/
```
the /config/init.js file is initial config.

## 3. Configure later using MongoDB Shell

Sometimes you need to configure an already-running database.

Enter the container:
```bash
docker exec -it mongodb-mongodb-1 mongosh
```
Login:
```bash
use admin

db.auth("admin", "secretpassword")
```
Now you can do anything.

Create database:
```bash
use inventory
```
Create collection:
```bash
db.createCollection("products")
```
Create user:
```bash
db.createUser({
    user: "inventory_user",
    pwd: "password",
    roles: [
        {
            role: "readWrite",
            db: "inventory"
        }
    ]
})
```
Insert data:
```bash
db.products.insertOne({
    name: "Laptop",
    price: 1000
})
```

## how to use backup and restore
this need to run the tools service.

1. for backup :
    `docker compose run --rm tools ./backup.sh`
    backed up directory store in ./backup_files with stamp time name.
    this directory bind mount with the tools container

2. for restore :
    `docker compose run --rm tools ./restore.sh 2026-07-08-08:50`
        