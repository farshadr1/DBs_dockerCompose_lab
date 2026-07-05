# mongosh important commands

| Description        | Command   |
| ------------------ | --------- |
| List all databases | `show dbs`|
| Show current database| `db`|
| Switch to a database| `use `|
| switch user | `use admin`|
| Verify authenticated| `db.runCommand({ connectionStatus: 1 })`|
| authentucate| `db.auth("admin", "secretpassword")`|
| List collections in current database| `show collections`|
| Create a collection| `db.createCollection("products")`|
| Delete a collection| `db.products.drop()`|
| Insert one document| `db.products.insertOne({name:"Laptop", price:1200})`|
| Insert multiple documents| `db.products.insertMany([{name:"Mouse"}, {name:"Keyboard"}])`|
| Display all documents| `db.products.find()`|
| Display one document| `db.products.findOne()`|
| Query documents| `db.products.find({price: {$gt: 100}})`|
| Update one document| `db.products.updateOne({name:"Laptop"}, {$set:{price:1500}})`|
| Delete one document| `db.products.deleteOne({name:"Mouse"})`|
| Delete multiple documents| `db.products.deleteMany({stock:0})`|
| Count documents| `db.products.countDocuments()`|
| Delete the current database| `db.dropDatabase()`|
| Create a database user| `db.createUser({user:"appuser", pwd:"secret", roles:[{role:"readWrite", db:"inventory"}]})` |
| List users in current database| `show users`|
| Create an index| `db.products.createIndex({name:1})`|
| List indexes| `db.products.getIndexes()`|
| Display server status and statistics| `db.serverStatus()`|
| Exit `mongosh`| `exit`|
