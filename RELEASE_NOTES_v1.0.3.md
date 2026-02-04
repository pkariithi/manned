## Installation

Download the `.deb` file and install using:

```bash
sudo dpkg -i manned-pages_1.0.3-1_amd64.deb
sudo apt install -f  # Install dependencies if needed
```

Or use `gdebi` for a better experience:

```bash
sudo apt-get install gdebi
sudo gdebi manned-pages_1.0.3-1_amd64.deb
```

**Snap (alternative):**

```bash
# Build locally: ./packaging/build_snap.sh
sudo snap install manned-pages_*.snap --dangerous
```

## What's New in v1.0.3

### 📚 Complete Command Coverage

**All Pending Commands Added (38 new commands):**
- **System Information:** vmstat, lsmem, lsusb, lspci, lscpu, lsof
- **User & Permissions:** su, passwd, useradd, usermod, userdel, groupadd, groupdel, groupmod, chgrp
- **Network:** ifconfig, host, nslookup, traceroute, dig
- **Process Management:** jobs, nice
- **Shell & Environment:** bash, sh, export, alias, info, time, yes, exit, whereis
- **Archive & Compression:** 7z, bunzip2, bzip2
- **Package Management:** apt-cache
- **File & Directory:** lsblk, blkid, locate, updatedb, split, umount
- **Text Processing:** patch, join, paste
- **Monitoring:** iostat, sar
- **Disk Management:** fdisk, parted, mkfs, fsck, dd
- **Systemd & Logs:** systemd-analyze, logrotate
- **Task Scheduling:** at, atq, atrm
- **System Utilities:** sync

**Total Commands:** Now supports **139 Linux commands** (all target commands completed).

### 📦 Snap Package

- ✅ Added Snap packaging for Manned Pages
- ✅ `snap/snapcraft.yaml` using the official Flutter plugin (base: core22)
- ✅ `packaging/build_snap.sh` script for building the snap
- ✅ Packaging README updated with Snap build, install, and publish instructions
- ✅ Desktop integration (GNOME extension) and icon support in the snap

### 📄 License

- ✅ Switched project license from WTFPL to **MIT License**
- ✅ Updated `LICENSE` with standard MIT text and copyright

### 🎨 About Dialog

- ✅ About dialog now shows version from the app (no hardcoded version)
- ✅ Added `package_info_plus` so version is read from `pubspec.yaml` at runtime
- ✅ Future version bumps only require updating pubspec (and snapcraft for snap)

### 🐛 Bug Fixes

**JSON Schema Fixes:**
- ✅ Fixed `umount.json`: `related_commands` was a single object; changed to array
- ✅ Fixed `rmdir.json`: `output_explanation.elements` in one example was an object; changed to array

### 🛠 Tooling & Tests

- ✅ Added `tool/validate_command_json.dart` to validate all command JSON files (required keys and types)
- ✅ Added test: "loadCommands loads all command JSON files without error" to verify all 139 files parse correctly
- ✅ `.gitignore` updated to ignore built `.snap` files

### Technical Summary

**Dependencies:**
- Added `package_info_plus: ^8.0.0` for dynamic version in About dialog

**Code Quality:**
- All command JSON files validated against schema (options, examples, related_commands, etc. as arrays when present)
- Command service registers all 139 command files

### Known Issues

None at this time.

### Migration Notes

**From v1.0.2 to v1.0.3:**
- No breaking changes
- New dependency `package_info_plus` is included in the build
- Install the new .deb or snap as usual; no data migration needed

## Full Changelog

- Added 38 new command documentation files (complete pending command list)
- Implemented Snap packaging (snapcraft.yaml, build_snap.sh)
- Switched license to MIT
- About dialog version now from package_info_plus (dynamic)
- Fixed umount.json related_commands type (object → array)
- Fixed rmdir.json output_explanation.elements type (object → array)
- Added tool/validate_command_json.dart for JSON validation
- Added load-all-commands Flutter test
- Updated PENDING_COMMANDS.md (all categories complete, 0 pending)
- Updated packaging README with Snap section
- Updated .gitignore for *.snap

## Files Changed (summary)

- `pubspec.yaml` – version 1.0.3, package_info_plus
- `snap/snapcraft.yaml` – new Snap package definition
- `packaging/build_snap.sh` – new Snap build script
- `packaging/README.md` – Snap build/install/publish section
- `lib/widgets/about_dialog.dart` – FutureBuilder + PackageInfo for version
- `lib/services/command_service.dart` – all new command file entries
- `assets/data/*.json` – 38 new files, umount.json and rmdir.json fixes
- `PENDING_COMMANDS.md` – all categories marked complete
- `LICENSE` – MIT license
- `tool/validate_command_json.dart` – new validation script
- `test/services/command_service_test.dart` – load-all-commands test
- `.gitignore` – *.snap

## Credits

Thank you for using Manned Pages! If you find this application helpful, please consider supporting the project:

- ⭐ Star the project on [GitHub](https://github.com/pkariithi/manned)
- ☕ [Buy Me a Coffee](https://buymeacoffee.com/patrickariithi)
