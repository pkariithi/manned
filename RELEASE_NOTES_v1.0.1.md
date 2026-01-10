## Installation

Download the `.deb` file and install using:

```bash
sudo dpkg -i manned-pages_1.0.1-1_amd64.deb
sudo apt-get install -f  # Install dependencies if needed
```

Or use `gdebi` for a better experience:

```bash
sudo apt-get install gdebi
sudo gdebi manned-pages_1.0.1-1_amd64.deb
```

## What's New in v1.0.1

### Bug Fixes & Improvements

**Taskbar Icon Fix:**
- ✅ Fixed icon path loading issue - icons now load correctly from bundled assets
- ✅ Icons now display properly in the taskbar/dock on all desktop environments
- ✅ Added icons in multiple sizes (16x16, 24x24, 32x32, 48x48, 64x64, 128x128, 256x256, 512x512) for optimal display across different contexts
- ✅ Added scalable icon support for high-DPI displays
- ✅ Improved desktop integration with proper `StartupWMClass` configuration
- ✅ Enhanced icon cache updates during installation/removal

**Desktop Integration:**
- ✅ Fixed desktop file configuration for proper taskbar icon association
- ✅ Added `StartupNotify` for better desktop environment integration
- ✅ Improved icon cache update scripts (postinst/postrm) for reliable icon display
- ✅ Fixed desktop file categories warning

### Content Expansion

**New Commands Added (20 commands):**
- `stat` - Display file or filesystem status
- `free` - Display amount of free and used memory
- `ip` - Show/manipulate routing, network devices, interfaces and tunnels
- `journalctl` - Query the systemd journal
- `crontab` - Maintain crontab files for individual users
- `file` - Determine file type
- `tee` - Read from standard input and write to standard output and files
- `tr` - Translate or delete characters
- `watch` - Execute a program periodically, showing output fullscreen
- `date` - Display or set the system date and time
- `basename` - Strip directory and suffix from filenames
- `dirname` - Strip last component from file name
- `gzip` - Compress files
- `gunzip` - Decompress files compressed by gzip
- `unzip` - Extract files from ZIP archives
- `xargs` - Build and execute command lines from standard input
- `uptime` - Show how long the system has been running
- `id` - Print real and effective user and group IDs
- `hostname` - Show or set the system's host name
- `cal` - Display a calendar

**Total Commands:** Now supports **70 Linux commands** (up from 50)

### Documentation

**New Documentation Files:**
- ✅ `JSON_SCHEMA.md` - Complete documentation of the JSON structure for command data files
- ✅ `UI_STRUCTURE_VALIDATION.md` - Detailed mapping between UI components and JSON data structure

**Improved Documentation:**
- Updated packaging documentation for manual release workflow
- Enhanced build script documentation

### Technical Improvements

**Build & Packaging:**
- ✅ Improved .deb package build process with better icon handling
- ✅ Enhanced post-installation scripts for reliable desktop integration
- ✅ Better error handling in icon cache updates
- ✅ Removed .deb file from git tracking (properly ignored)

**Code Quality:**
- Fixed GTK application icon loading path
- Improved window role configuration for desktop environments
- Better asset path resolution for bundled resources

### Known Issues

None at this time.

### Migration Notes

**From v1.0.0 to v1.0.1:**
- No breaking changes
- Icons will now display correctly after installation
- Manual icon cache update may be needed in some cases:
  ```bash
  sudo gtk-update-icon-cache -f /usr/share/icons/hicolor
  sudo update-desktop-database /usr/share/applications/
  ```

## Full Changelog

- Fixed icon path in GTK application to correctly load from `flutter_assets/assets/icon.png`
- Added window role setting for proper desktop integration (`StartupWMClass`)
- Installed icons in multiple standard sizes for better taskbar support
- Added scalable icon entry for high-DPI displays
- Improved icon cache updates in postinst/postrm scripts
- Updated desktop file with `StartupWMClass` and `StartupNotify` for proper taskbar integration
- Fixed desktop file categories to avoid warnings
- Added 20 new command JSON files following the defined schema
- Updated `CommandService` to include all new commands
- Updated `PENDING_COMMANDS.md` to reflect added commands
- Removed .deb file from git tracking (properly ignored)
- Added comprehensive JSON schema documentation
- Added UI structure validation documentation

## Files Changed

- `linux/runner/my_application.cc` - Fixed icon loading path and window configuration
- `packaging/build_deb.sh` - Enhanced icon installation with multiple sizes
- `packaging/debian/postinst` - Improved icon cache updates
- `packaging/debian/postrm` - Improved icon cache updates
- `lib/services/command_service.dart` - Added 20 new commands
- `assets/data/*.json` - Added 20 new command JSON files
- `JSON_SCHEMA.md` - New documentation file
- `UI_STRUCTURE_VALIDATION.md` - New documentation file
- `PENDING_COMMANDS.md` - Updated with new commands added
