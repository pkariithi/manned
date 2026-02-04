#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Run from project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$PROJECT_ROOT"

echo -e "${GREEN}Building Snap package for Manned Pages${NC}"

# Check for snapcraft
if ! command -v snapcraft &>/dev/null; then
  echo -e "${RED}snapcraft not found. Install with: sudo snap install snapcraft --classic${NC}"
  exit 1
fi

# Optional: sync version from pubspec.yaml into snap/snapcraft.yaml
VERSION_LINE=$(grep '^version:' pubspec.yaml | sed 's/version: //')
VERSION=$(echo "$VERSION_LINE" | sed 's/+.*//')
echo -e "${YELLOW}Project version: ${VERSION}${NC}"
echo -e "${YELLOW}Ensure snap/snapcraft.yaml version matches (currently used by snapcraft).${NC}"

# Build the snap (snapcraft will find snap/snapcraft.yaml or snapcraft.yaml)
echo -e "${YELLOW}Running snapcraft...${NC}"
snapcraft

echo -e "${GREEN}Snap build complete.${NC}"
echo -e "Output: manned-pages_${VERSION}_amd64.snap (or similar)"
echo -e ""
echo -e "Install locally: sudo snap install manned-pages_*.snap --dangerous"
echo -e "Or for devmode:  sudo snap install manned-pages_*.snap --dangerous --devmode"
