#!/bin/bash
set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

VERSION=$(grep '^version:' pubspec.yaml | sed 's/version: //' | sed 's/+.*//')
BUILD_NUMBER=$(grep '^version:' pubspec.yaml | sed 's/.*+//')
PACKAGE_NAME="manned-pages"
DEB_FILE="${PACKAGE_NAME}_${VERSION}-${BUILD_NUMBER}_amd64.deb"

echo -e "${GREEN}Creating GitHub Release for v${VERSION}${NC}"

# Check if .deb file exists
if [ ! -f "$DEB_FILE" ]; then
    echo -e "${YELLOW}Building .deb package first...${NC}"
    ./packaging/build_deb.sh
fi

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo -e "${YELLOW}GitHub CLI (gh) not found. Please install it or create release manually.${NC}"
    echo ""
    echo "To create a release manually:"
    echo "1. Go to: https://github.com/pkariithi/manned/releases/new"
    echo "2. Tag: v${VERSION}"
    echo "3. Title: Manned Pages ${VERSION}"
    echo "4. Upload: ${DEB_FILE}"
    echo "5. Description:"
    echo "   ## Installation"
    echo "   Download the .deb file and install:"
    echo "   \`\`\`bash"
    echo "   sudo dpkg -i ${DEB_FILE}"
    echo "   sudo apt-get install -f"
    echo "   \`\`\`"
    exit 0
fi

# Check if already logged in
if ! gh auth status &> /dev/null; then
    echo "Please login to GitHub:"
    gh auth login
fi

# Create release
echo -e "${GREEN}Creating release v${VERSION}...${NC}"
gh release create "v${VERSION}" \
    --title "Manned Pages ${VERSION}" \
    --notes "## Installation

Download the \`.deb\` file and install using:

\`\`\`bash
sudo dpkg -i ${DEB_FILE}
sudo apt-get install -f  # Install dependencies if needed
\`\`\`

Or use \`gdebi\` for a better experience:

\`\`\`bash
sudo apt-get install gdebi
sudo gdebi ${DEB_FILE}
\`\`\`

## What's New

See the [changelog](CHANGELOG.md) for details." \
    "${DEB_FILE}"

echo -e "${GREEN}✓ Release created successfully!${NC}"
echo "View at: https://github.com/pkariithi/manned/releases/tag/v${VERSION}"

