## Installation

Download the `.deb` file and install using:

```bash
sudo dpkg -i manned-pages_1.0.0-1_amd64.deb
sudo apt-get install -f  # Install dependencies if needed
```

Or use `gdebi` for a better experience:

```bash
sudo apt-get install gdebi
sudo gdebi manned-pages_1.0.0-1_amd64.deb
```

## What's New

### Initial Release - Version 1.0.0

**Features:**
- ✅ Comprehensive command database with 50 Linux commands
- ✅ Two-pane interface for easy navigation
- ✅ Smart search across command fields
- ✅ Light and dark theme support with toggle
- ✅ JSON view with syntax highlighting
- ✅ Installation instructions for installable commands
- ✅ Real-world examples with detailed output explanations
- ✅ Common misconceptions and pitfalls
- ✅ Best practices and performance tips
- ✅ Related commands suggestions

**Documentation:**
- Detailed command syntax and options
- Field-by-field output explanations
- Copy-to-clipboard functionality
- Auto-scroll on command selection

**Package:**
- Native .deb package for Ubuntu/Debian
- Desktop integration with icon and launcher
- Proper dependency management

**Technical:**
- Built with Flutter
- Yaru theme integration for native Ubuntu look
- Offline-first architecture
- Comprehensive unit tests

