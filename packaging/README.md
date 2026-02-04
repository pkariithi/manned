# Packaging Manned Pages

This directory contains scripts and configuration files for building Debian packages (.deb) and Snap packages of Manned Pages.

## Building a Snap Package

### Prerequisites

- [Snapcraft](https://snapcraft.io/docs/snapcraft-overview) (recommended: install via snap):
  ```bash
  sudo snap install snapcraft --classic
  ```
- Snapcraft will use the [Flutter plugin](https://snapcraft.io/docs/flutter-plugin) and handle the Flutter SDK in the build environment.

### Build Steps

1. **Build the snap** (from project root):
   ```bash
   ./packaging/build_snap.sh
   ```
   Or run snapcraft directly:
   ```bash
   snapcraft
   ```

2. **Output:** `manned-pages_<version>_amd64.snap` in the project root.

### Install the Snap Locally

```bash
sudo snap install manned-pages_*.snap --dangerous
```

Use `--dangerous` because the snap is not signed by the store. For testing with fewer restrictions:

```bash
sudo snap install manned-pages_*.snap --dangerous --devmode
```

### Publishing to the Snap Store

1. Create a [Snap Store account](https://snapcraft.io/register) and log in: `snapcraft login`
2. Register the snap name (one-time): `snapcraft register manned-pages`
3. Build and push: `snapcraft upload manned-pages_*.snap --release=stable`

### Snap Configuration

- **Config file:** `snap/snapcraft.yaml`
- **Base:** core22 (Ubuntu 22.04 LTS base)
- **Confinement:** strict (store-ready)
- **Extensions:** gnome-3-38 for desktop integration

---

## Building a .deb Package

### Prerequisites

- Flutter SDK installed
- `dpkg-dev` and `debhelper` packages:
  ```bash
  sudo apt-get install dpkg-dev debhelper
  ```

### Build Steps

1. **Build the package:**
   ```bash
   ./packaging/build_deb.sh
   ```

2. **The script will:**
   - Build the Flutter release
   - Create the Debian package structure
   - Package all application files
   - Generate a `.deb` file in the project root

3. **Output:**
   - The `.deb` file will be named: `manned-pages_<version>-<build>_amd64.deb`
   - Example: `manned-pages_1.0.0-1_amd64.deb`

## Installing the Package

### Using dpkg:
```bash
sudo dpkg -i manned-pages_*.deb
sudo apt-get install -f  # Install dependencies if needed
```

### Using gdebi (recommended):
```bash
sudo apt-get install gdebi
sudo gdebi manned-pages_*.deb
```

## Package Structure

The package installs:
- **Binary**: `/usr/bin/manned-pages`
- **Application files**: `/usr/share/manned-pages/`
- **Desktop file**: `/usr/share/applications/manned-pages.desktop`
- **Icon**: `/usr/share/icons/hicolor/256x256/apps/manned-pages.png`

## GitHub Releases

### Creating a Manual Release

1. **Build the .deb package:**
   ```bash
   ./packaging/build_deb.sh
   ```

   This creates: `manned-pages_<version>-<build>_amd64.deb`

2. **Create a git tag (if not already created):**
   ```bash
   git tag -a v1.0.0 -m "Release version 1.0.0"
   git push origin v1.0.0
   ```

3. **Create the release on GitHub:**
   - Go to: https://github.com/pkariithi/manned/releases/new
   - **Tag**: Select `v1.0.0` from the dropdown (or type it)
   - **Release title**: `Manned Pages 1.0.0`
   - **Description**: Copy from `RELEASE_NOTES_v1.0.0.md` or use the template:
     ```markdown
     ## Installation

     Download the `.deb` file and install using:

     ```bash
     sudo dpkg -i manned-pages_*.deb
     sudo apt-get install -f  # Install dependencies if needed
     ```

     Or use `gdebi` for a better experience:

     ```bash
     sudo apt-get install gdebi
     sudo gdebi manned-pages_*.deb
     ```

     ## What's New

     [Add release notes here]
     ```
   - **Attach files**: Drag and drop the `.deb` file
   - Click **"Publish release"**

### Release Checklist

- [ ] Build the .deb package: `./packaging/build_deb.sh`
- [ ] Create/verify git tag: `git tag -l`
- [ ] Push tag if new: `git push origin v1.0.0`
- [ ] Create release on GitHub
- [ ] Upload the .deb file
- [ ] Add release notes
- [ ] Verify download link works

## Package Information

- **Package Name**: `manned-pages`
- **Section**: `utils`
- **Architecture**: `amd64`
- **Dependencies**: `libgtk-3-0`, `libglib2.0-0`, `libc6`

