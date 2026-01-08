#!/bin/bash
set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

VERSION=$(grep '^version:' pubspec.yaml | sed 's/version: //' | sed 's/+.*//')
BUILD_NUMBER=$(grep '^version:' pubspec.yaml | sed 's/.*+//')
PACKAGE_NAME="manned-pages"
DEB_FILE="${PACKAGE_NAME}_${VERSION}-${BUILD_NUMBER}_amd64.deb"
REPO="pkariithi/manned"
TAG="v${VERSION}"

echo -e "${GREEN}Creating GitHub Release for ${TAG}${NC}"

# Check if .deb file exists
if [ ! -f "$DEB_FILE" ]; then
    echo -e "${YELLOW}Building .deb package first...${NC}"
    ./packaging/build_deb.sh
fi

# Check for GitHub token
if [ -z "$GITHUB_TOKEN" ]; then
    echo -e "${RED}Error: GITHUB_TOKEN environment variable is not set.${NC}"
    echo ""
    echo "To create a release, you need a GitHub personal access token."
    echo "1. Go to: https://github.com/settings/tokens"
    echo "2. Generate a new token with 'repo' scope"
    echo "3. Export it: export GITHUB_TOKEN=your_token_here"
    echo "4. Run this script again"
    echo ""
    echo "Or create the release manually at:"
    echo "https://github.com/${REPO}/releases/new"
    exit 1
fi

# Check if release already exists
RELEASE_EXISTS=$(curl -s -o /dev/null -w "%{http_code}" \
    -H "Authorization: token $GITHUB_TOKEN" \
    "https://api.github.com/repos/${REPO}/releases/tags/${TAG}")

if [ "$RELEASE_EXISTS" = "200" ]; then
    echo -e "${YELLOW}Release ${TAG} already exists. Uploading asset...${NC}"
    
    # Get release ID
    RELEASE_ID=$(curl -s \
        -H "Authorization: token $GITHUB_TOKEN" \
        "https://api.github.com/repos/${REPO}/releases/tags/${TAG}" | \
        grep -o '"id":[0-9]*' | head -1 | cut -d':' -f2)
    
    # Upload asset
    UPLOAD_URL="https://uploads.github.com/repos/${REPO}/releases/${RELEASE_ID}/assets?name=$(basename $DEB_FILE)"
    
    curl -X POST \
        -H "Authorization: token $GITHUB_TOKEN" \
        -H "Content-Type: application/octet-stream" \
        --data-binary "@${DEB_FILE}" \
        "$UPLOAD_URL" > /dev/null
    
    echo -e "${GREEN}✓ Asset uploaded to existing release${NC}"
else
    # Create new release
    echo -e "${GREEN}Creating new release...${NC}"
    
    RELEASE_DATA=$(cat <<EOF
{
  "tag_name": "${TAG}",
  "name": "Manned Pages ${VERSION}",
  "body": "## Installation\n\nDownload the \`.deb\` file and install using:\n\n\`\`\`bash\nsudo dpkg -i ${DEB_FILE}\nsudo apt-get install -f  # Install dependencies if needed\n\`\`\`\n\nOr use \`gdebi\` for a better experience:\n\n\`\`\`bash\nsudo apt-get install gdebi\nsudo gdebi ${DEB_FILE}\n\`\`\`\n\n## What's New\n\n- Initial release with 50 Linux commands\n- Comprehensive documentation with examples\n- Light and dark theme support\n- JSON view with syntax highlighting\n- .deb package for easy installation",
  "draft": false,
  "prerelease": false
}
EOF
)
    
    # Create release
    RELEASE_RESPONSE=$(curl -s -X POST \
        -H "Authorization: token $GITHUB_TOKEN" \
        -H "Content-Type: application/json" \
        -d "$RELEASE_DATA" \
        "https://api.github.com/repos/${REPO}/releases")
    
    # Check if creation was successful
    if echo "$RELEASE_RESPONSE" | grep -q '"id"'; then
        RELEASE_ID=$(echo "$RELEASE_RESPONSE" | grep -o '"id":[0-9]*' | head -1 | cut -d':' -f2)
        echo -e "${GREEN}✓ Release created (ID: ${RELEASE_ID})${NC}"
        
        # Upload asset
        echo -e "${YELLOW}Uploading .deb file...${NC}"
        UPLOAD_URL="https://uploads.github.com/repos/${REPO}/releases/${RELEASE_ID}/assets?name=$(basename $DEB_FILE)"
        
        curl -X POST \
            -H "Authorization: token $GITHUB_TOKEN" \
            -H "Content-Type: application/octet-stream" \
            --data-binary "@${DEB_FILE}" \
            "$UPLOAD_URL" > /dev/null
        
        echo -e "${GREEN}✓ Asset uploaded successfully${NC}"
    else
        echo -e "${RED}✗ Failed to create release${NC}"
        echo "$RELEASE_RESPONSE" | head -20
        exit 1
    fi
fi

echo -e "${GREEN}✓ Release available at: https://github.com/${REPO}/releases/tag/${TAG}${NC}"

