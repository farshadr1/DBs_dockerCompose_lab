// create a new database called "appdb"
db = db.getSiblingDB("appdb");

// create a new user with readWrite access to the "appdb" database
db.createUser({
  user: "appuser",
  pwd: "apppassword",
  roles: [
    {
      role: "readWrite",
      db: "appdb"
    }
  ]
});

// create a new collection called "users"
db.createCollection("users");

// insert a new user document into the "users" collection
db.users.insertOne({
  name: "Administrator",
  createdAt: new Date()
});