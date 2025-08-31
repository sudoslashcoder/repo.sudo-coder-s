#!/bin/bash
set -e

# ===============================
#  GitHub .deb Repo Update Script
# ===============================

# Config
DEB_DIR="debs"
PKG_FILE="Packages"
PKG_GZ="Packages.gz"
RELEASE_FILE="Release"

# Make sure debs/ exists
if [ ! -d "$DEB_DIR" ]; then
    echo "[!] $DEB_DIR folder not found, creating it..."
    mkdir -p "$DEB_DIR"
fi

echo "[*] Cleaning old files..."
rm -f "$PKG_FILE" "$PKG_GZ"

echo "[*] Generating Packages file..."
dpkg-scanpackages "$DEB_DIR" > "$PKG_FILE"

echo "[*] Compressing Packages..."
gzip -c "$PKG_FILE" > "$PKG_GZ"

# Create a Release file if not exists
if [ ! -f "$RELEASE_FILE" ]; then
    echo "[*] No Release file found, generating a default one..."
    cat > "$RELEASE_FILE" <<EOF
Origin: My Tweak Repo
Label: Sudo/Coder
Suite: stable
Version: 1.0
Codename: ios
Architectures: iphoneos-arm
Components: main
Description: My tweak repository
EOF
fi

echo "[✔] Repo updated successfully!"
echo "Now run: git add . && git commit -m 'Update repo' && git push"
