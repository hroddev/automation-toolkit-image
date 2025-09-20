set -e # Exit if any command fails
echo "🛠️ Building automation-toolbox-image:latest image..."
docker build -t automation-toolbox-image:latest .
echo "🗑️ Removing existing automation-toolbox container (if exists)..."
distrobox rm --force automation-toolbox || echo "✅ No previous container to remove"
echo "📦 Creating new automation-toolbox container..."
distrobox create --name automation-toolbox --image automation-toolbox-image:latest
echo "✅ Process completed successfully!"
echo "➡️ To enter the container run: distrobox enter automation-toolbox"
