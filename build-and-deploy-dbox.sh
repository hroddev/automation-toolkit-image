set -e # Exit if any command fails
echo "🛠️ Building millennium-falcon:latest image..."
podman build -t millennium-falcon:latest .
echo "🗑️ Removing Millennium Falcon container (if exists)..."
distrobox rm --force millennium-falcon || echo "✅ No previous container to remove"
echo "📦 Creating new Millennium Falcon:latest container..."
distrobox create --image millennium-falcon:latest millennium-falcon
echo "✅ Process completed successfully!"
echo "➡️ To enter the container run: distrobox enter millennium-falcon"
