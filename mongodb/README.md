# Mongodb Containerize Project

## 1. Configure the container (Docker Compose)

- using official mongodb-community image in ubuntu slimm
- expose 27017 port
- set environment parametes 
- set restart policy
- bind init.js for config
- persist database volumes 
- set using network


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

## A best practice to remember
