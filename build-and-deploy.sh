#!/bin/bash

# Script to build the image and create the container with distrobox
# Based on the commands from readme.md

set -e  # Exit if any command fails

echo "🔨 Building automation-toolbox-image:latest image..."
docker build -t automation-toolbox-image:latest .

echo "🗑️ Removing existing automation-toolbox container (if exists)..."
distrobox rm --force automation-toolbox || echo "ℹ️ No previous container to remove"

echo "📦 Creating new automation-toolbox container..."
distrobox create --name automation-toolbox --image automation-toolbox-image:latest

echo "✅ Process completed successfully!"
echo "💡 To enter the container run: distrobox enter automation-toolbox"
