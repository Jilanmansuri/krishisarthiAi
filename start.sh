#!/bin/sh

# Start Nginx in the background
nginx -g "daemon on;"

# Wait for MongoDB to be ready
echo "Waiting for MongoDB to be ready..."
until nc -z mongodb 27017; do
  echo "MongoDB is unavailable - sleeping"
  sleep 1
done
echo "MongoDB is up - proceeding"

# Start Node.js backend
cd /app/backend
node server.js
