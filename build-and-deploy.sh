set -e # Exit if any command fails
echo "🛠️ Buildingmillennium-falcon:latest image..."
podman build -t millennium-falcon:latest .
echo "🗑️ Removinglocalhost/automation-toolbox container (if exists)..."
toolbox rm --force millennium-falcon|| echo "✅ No previous container to remove"
echo "📦 Creating new millennium-falcon:latest container..."
toolbox create --image localhost/millennium-falcon:latest millennium-falcon
echo "✅ Process completed successfully!"
echo "➡️ To enter the container run: distrobox entermillennium-falcon"
