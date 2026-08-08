#!/bin/bash

# Define the source directory containing your downloaded .deb files
TARGET_DIR="$HOME/software"

echo "📂 Scanning directory: $TARGET_DIR for .deb installers..."

# 1. Verify the software directory actually exists
if [ ! -d "$TARGET_DIR" ]; then
    echo "❌ Error: The directory '$TARGET_DIR' does not exist."
    echo "💡 Creating it now. Drop your .deb files inside it and re-run this script."
    mkdir -p "$TARGET_DIR"
    exit 1
fi

# 2. Check if there are any .deb files inside the folder
shopt -s nullglob
deb_files=("$TARGET_DIR"/*.deb)
if [ ${#deb_files[@]} -eq 0 ]; then
    echo "📭 No .deb files found inside '$TARGET_DIR'."
    exit 0
fi

echo "📦 Found ${#deb_files[@]} package installer files. Starting verification sweep..."
echo "--------------------------------------------------------"

# 3. Loop through every .deb file found
for file in "${deb_files[@]}"; do
    filename=$(basename "$file")
    
    # Extract the true internal package name from the deb metadata safely
    pkg_name=$(dpkg-deb -f "$file" Package 2>/dev/null)
    
    if [ -z "$pkg_name" ]; then
        echo "⚠️ Skipping '$filename': Could not read internal package metadata."
        continue
    fi
    
    # Check if the extracted package name is already registered in the system
    if dpkg -s "$pkg_name" >/dev/null 2>&1; then
        echo "✅ Already Installed: $pkg_name ($filename)"
    else
        echo "📥 Missing: Installing $pkg_name from $filename..."
        
        # Install the package and automatically resolve any missing system dependencies
        sudo dpkg -i "$file"
        sudo apt-get install -f -y
    fi
done

echo "--------------------------------------------------------"
echo "🎉 Local offline application deployment loop completed successfully!"
