
#!/bin/bash

# Update system packages
echo "Updating system packages..."
sudo apt update -y

#From a terminal, install gnupg and curl if they are not already available
sudo apt install gnupg curl

#To import the MongoDB public GPG key, run the following command
curl -fsSL https://pgp.mongodb.com/server-8.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg \
   --dearmor


#Create the list file /etc/apt/sources.list.d/mongodb-enterprise-8.0.list for your version of Ubuntu.
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.com/apt/ubuntu noble/mongodb-enterprise/8.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-enterprise-8.0.list

#Reload the package database
sudo apt update

#Install MongoDB Enterprise Server
sudo apt install -y mongodb-enterprise

# Start MongoDB service
echo "Starting MongoDB service..."
sudo systemctl start mongod

# Enable MongoDB to start on boot
sudo systemctl enable mongod

# Wait 10s for MongoDB to fully get started
sleep 10

# Create a MongoDB database called "myData" and a collection called "users"
echo "Setting up MongoDB database and collection..."

mongosh <<EOF
use myData;
db.createCollection("users");
db.users.insertMany([
  { name: "Alice Smith", email: "alice.smith@example.com", department: "Engineering" },
  { name: "Bob Johnson", email: "bob.johnson@example.com", department: "Sales" },
  { name: "Charlie Lee", email: "charlie.lee@example.com", department: "Marketing" },
  { name: "David Kim", email: "david.kim@example.com", department: "HR" },
  { name: "Eva Davis", email: "eva.davis@example.com", department: "Finance" }
]);
print("Database and collection created successfully with 5 dummy users.");
EOF

# Display the inserted users
echo "Displaying the inserted users in the collection:"
mongosh <<EOF
use myData;
printjson(db.users.find().toArray());
EOF

echo "MongoDB setup completed successfully!"

