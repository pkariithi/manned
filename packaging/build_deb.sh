#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get version from pubspec.yaml
VERSION=$(grep '^version:' pubspec.yaml | sed 's/version: //' | sed 's/+.*//')
BUILD_NUMBER=$(grep '^version:' pubspec.yaml | sed 's/.*+//')
PACKAGE_NAME="manned-pages"
DEB_VERSION="${VERSION}-${BUILD_NUMBER}"
ARCH="amd64"

echo -e "${GREEN}Building .deb package for ${PACKAGE_NAME} ${DEB_VERSION}${NC}"

# Clean previous builds
echo -e "${YELLOW}Cleaning previous builds...${NC}"
rm -rf build/deb
rm -f ${PACKAGE_NAME}_${DEB_VERSION}_${ARCH}.deb

# Build Flutter release
echo -e "${YELLOW}Building Flutter release...${NC}"
flutter build linux --release

# Create package structure
echo -e "${YELLOW}Creating package structure...${NC}"
BUILD_DIR="build/deb/${PACKAGE_NAME}_${DEB_VERSION}_${ARCH}"
mkdir -p "${BUILD_DIR}/DEBIAN"
mkdir -p "${BUILD_DIR}/usr/bin"
mkdir -p "${BUILD_DIR}/usr/share/applications"
mkdir -p "${BUILD_DIR}/usr/share/icons/hicolor/256x256/apps"
mkdir -p "${BUILD_DIR}/usr/share/manned-pages"

# Copy control files
cp packaging/debian/control "${BUILD_DIR}/DEBIAN/control"
cp packaging/debian/postinst "${BUILD_DIR}/DEBIAN/postinst"
cp packaging/debian/postrm "${BUILD_DIR}/DEBIAN/postrm"
chmod 755 "${BUILD_DIR}/DEBIAN/postinst"
chmod 755 "${BUILD_DIR}/DEBIAN/postrm"

# Update version in control file
sed -i "s/Version: .*/Version: ${DEB_VERSION}/" "${BUILD_DIR}/DEBIAN/control"
sed -i "s/Architecture: .*/Architecture: ${ARCH}/" "${BUILD_DIR}/DEBIAN/control"

# Copy application files
echo -e "${YELLOW}Copying application files...${NC}"
cp -r build/linux/x64/release/bundle/* "${BUILD_DIR}/usr/share/manned-pages/"

# Create launcher script
cat > "${BUILD_DIR}/usr/bin/manned-pages" << 'EOF'
#!/bin/bash
cd /usr/share/manned-pages
exec ./manned_pages "$@"
EOF
chmod +x "${BUILD_DIR}/usr/bin/manned-pages"

# Create desktop file
cat > "${BUILD_DIR}/usr/share/applications/manned-pages.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Manned Pages
Comment=A modern, user-friendly Linux command reference application
Exec=/usr/bin/manned-pages
Icon=manned-pages
Terminal=false
Categories=Utility;Documentation;Education;
Keywords=linux;commands;documentation;man;reference;
EOF

# Copy icon
if [ -f "assets/icon.png" ]; then
    cp assets/icon.png "${BUILD_DIR}/usr/share/icons/hicolor/256x256/apps/manned-pages.png"
fi

# Calculate installed size
INSTALLED_SIZE=$(du -sk "${BUILD_DIR}/usr" | cut -f1)
sed -i "s/Installed-Size: .*/Installed-Size: ${INSTALLED_SIZE}/" "${BUILD_DIR}/DEBIAN/control" || \
    sed -i "/^Maintainer:/a Installed-Size: ${INSTALLED_SIZE}" "${BUILD_DIR}/DEBIAN/control"

# Build .deb package
echo -e "${YELLOW}Building .deb package...${NC}"
dpkg-deb --build --root-owner-group "${BUILD_DIR}" "${PACKAGE_NAME}_${DEB_VERSION}_${ARCH}.deb"

# Verify package
if [ -f "${PACKAGE_NAME}_${DEB_VERSION}_${ARCH}.deb" ]; then
    PACKAGE_SIZE=$(du -h "${PACKAGE_NAME}_${DEB_VERSION}_${ARCH}.deb" | cut -f1)
    echo -e "${GREEN}✓ Package built successfully: ${PACKAGE_NAME}_${DEB_VERSION}_${ARCH}.deb (${PACKAGE_SIZE})${NC}"

    # Show package info
    echo -e "${YELLOW}Package info:${NC}"
    dpkg-deb -I "${PACKAGE_NAME}_${DEB_VERSION}_${ARCH}.deb"
else
    echo -e "${RED}✗ Package build failed!${NC}"
    exit 1
fi

