#!/bin/bash

# Ensure the script is executed with one argument
if [ $# -ne 1 ]; then
  echo "Usage: $0 <project_name>"
  exit 1
fi

PROJECT_NAME=$1
BASE_DIR="$HOME/benches"
PROJECT_DIR="$BASE_DIR/$PROJECT_NAME"

SOURCE_DOCKER_COMPOSE="docker-compose.yaml"  # Path to your source docker-compose file
INSTALLER_SCRIPT="installer.py"  # Path to your installer.py file
UPDATED_COMPOSE_FILE="$PROJECT_DIR/$PROJECT_NAME-compose.yaml"
UPDATED_INSTALLER_SCRIPT="$PROJECT_DIR/source/installer.py"

# Create project directory structure
echo "Creating project directory at $PROJECT_DIR..."
mkdir -p "$PROJECT_DIR"

# Create source directory
echo "Creating source directory at $PROJECT_DIR/source..."
mkdir -p "$PROJECT_DIR/source"

# Create logs directory
echo "Creating logs directory at $PROJECT_DIR/logs..."
mkdir -p "$PROJECT_DIR/logs"

# Create bench logs file
echo "Creating bench logs file at $PROJECT_DIR/logs/bench.log..."
touch "$PROJECT_DIR/logs/bench.log"

# Copy docker-compose and installer.py files
echo "Copying $SOURCE_DOCKER_COMPOSE to $UPDATED_COMPOSE_FILE..."
cp "$SOURCE_DOCKER_COMPOSE" "$UPDATED_COMPOSE_FILE"

echo "Copying $INSTALLER_SCRIPT to $PROJECT_DIR..."
cp "$INSTALLER_SCRIPT" "$UPDATED_INSTALLER_SCRIPT"

# Update the installer file permission to executable
chmod +x "$UPDATED_INSTALLER_SCRIPT"

# Update network name in docker-compose.yaml
echo "Updating network name in $UPDATED_COMPOSE_FILE..."
sed -i '' "s/project_name/$PROJECT_NAME/g" "$UPDATED_COMPOSE_FILE"

# Navigate to the project directory
cd "$PROJECT_DIR" || { echo "Failed to navigate to $PROJECT_DIR"; exit 1; }

# Start Docker Compose
echo "Starting Docker Compose..."
docker-compose -f "$PROJECT_NAME-compose.yaml" up -d

FRAPPE_CONTAINER_NAME="$PROJECT_NAME-frappe-1"

echo "Waiting for Frappe container to start..."
while [ ! "$(docker inspect -f '{{.State.Running}}' $FRAPPE_CONTAINER_NAME)" == "true" ]; do
  sleep 1
done

# Get the container ID of the Frappe container
FRAPPE_CONTAINER_ID=$(docker ps -aqf "name=$FRAPPE_CONTAINER_NAME")



# Enter interactive mode and run installer.py
echo "Running installer script in Frappe container..."
docker exec -it "$FRAPPE_CONTAINER_ID" ./installer.py

