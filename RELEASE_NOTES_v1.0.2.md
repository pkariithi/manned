## Installation

Download the `.deb` file and install using:

```bash
sudo dpkg -i manned-pages_1.0.2-1_amd64.deb
sudo apt install -f  # Install dependencies if needed
```

Or use `gdebi` for a better experience:

```bash
sudo apt-get install gdebi
sudo gdebi manned-pages_1.0.2-1_amd64.deb
```

## What's New in v1.0.2

### 🎨 UI/UX Improvements

**Native Yaru Theme Integration:**
- ✅ Replaced standard AppBar with `YaruWindowTitleBar` for native Ubuntu window decorations
- ✅ Added rounded window corners and elegant window borders
- ✅ Full Flutter control over window appearance
- ✅ Improved desktop integration with proper window decorations
- ✅ Added `handy_window` package for enhanced window management

**Enhanced Title Bar:**
- ✅ Search icon on the left to toggle search bar visibility
- ✅ App name displayed in the center
- ✅ Menu icon on the right opens the About dialog
- ✅ Theme toggle and JSON view toggle remain accessible
- ✅ Clean, Settings-app-like interface design

**About Dialog:**
- ✅ New About dialog accessible from the menu icon
- ✅ Displays app icon, name, and version (1.0.2)
- ✅ Centered layout with app description
- ✅ GitHub repository link with logo image
- ✅ Buy Me a Coffee link with image button
- ✅ Tooltips show URLs on hover
- ✅ Right-click to copy URLs to clipboard with confirmation
- ✅ All content centered for better visual presentation

### 🔍 Search Functionality

**Search Bar Toggle:**
- ✅ Search bar can now be toggled on/off via the search icon in the title bar
- ✅ Search bar hidden by default for a cleaner interface
- ✅ Toggle state persists during the session
- ✅ Smooth show/hide transitions

### 📦 Build & Packaging

**Build Script Improvements:**
- ✅ Updated build script to handle versions without build numbers
- ✅ Automatic build number assignment (defaults to "1" if not specified)
- ✅ Better version parsing from `pubspec.yaml`
- ✅ Improved error handling during package creation

### 📸 Documentation

**Screenshots:**
- ✅ Added JSON View Dark Mode screenshot to README
- ✅ Complete screenshot gallery showing all views in both themes

**README Updates:**
- ✅ Added Buy Me a Coffee banner at the top
- ✅ Updated with new screenshot showcasing dark mode JSON view

### Technical Improvements

**Dependencies:**
- ✅ Added `handy_window: ^0.3.1` for window management
- ✅ Added `url_launcher: ^6.3.1` for external link handling
- ✅ Updated native Linux code to register plugins before showing window

**Code Quality:**
- ✅ Improved window initialization sequence
- ✅ Better plugin registration order for Yaru decorations
- ✅ Enhanced About dialog with proper URL handling
- ✅ Improved clipboard functionality with user feedback

### Known Issues

None at this time.

### Migration Notes

**From v1.0.1 to v1.0.2:**
- No breaking changes
- New dependencies will be automatically installed
- Window appearance will be updated to use native Yaru decorations
- About dialog is now accessible from the menu icon in the title bar

## Full Changelog

- Migrated from standard AppBar to YaruWindowTitleBar for native Ubuntu window decorations
- Added About dialog with app information, version, and links
- Implemented search bar toggle functionality
- Added GitHub and Buy Me a Coffee links with images in About dialog
- Added tooltips showing URLs on hover for image links
- Implemented right-click to copy URLs with clipboard confirmation
- Centered all content in About dialog for better visual presentation
- Added version display (1.0.2) in About dialog
- Updated build script to handle versions without explicit build numbers
- Added JSON View Dark Mode screenshot to README
- Added Buy Me a Coffee banner to README
- Updated native Linux code to register plugins before showing window
- Added `handy_window` and `url_launcher` dependencies
- Improved window initialization sequence for better Yaru integration

## Files Changed

- `lib/main.dart` - Added YaruWindowTitleBar initialization
- `lib/screens/main_screen.dart` - Replaced AppBar with YaruWindowTitleBar, added search toggle
- `lib/widgets/about_dialog.dart` - New About dialog widget
- `lib/widgets/command_list.dart` - Added showSearchBar parameter
- `linux/runner/my_application.cc` - Updated plugin registration order
- `pubspec.yaml` - Added handy_window and url_launcher dependencies, updated version
- `packaging/build_deb.sh` - Improved version parsing
- `README.md` - Added Buy Me a Coffee banner and JSON View Dark Mode screenshot
- `assets/buymeacoffee.png` - New asset (added to pubspec.yaml)
- `assets/github-logo.png` - New asset (added to pubspec.yaml)

## Credits

Thank you for using Manned Pages! If you find this application helpful, please consider supporting the project:

- ⭐ Star the project on [GitHub](https://github.com/pkariithi/manned)
- ☕ [Buy Me a Coffee](https://buymeacoffee.com/patrickariithi)
