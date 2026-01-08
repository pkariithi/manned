# Packaging Manned Pages

This directory contains scripts and configuration files for building Debian packages (.deb) of Manned Pages.

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

The `.github/workflows/build-and-release.yml` workflow automatically:
- Builds the package when a tag is pushed (e.g., `v1.0.0`)
- Creates a GitHub release with the `.deb` file as a downloadable asset

### Creating a Release

#### Option 1: Using the release script (recommended)

1. **Build and create release:**
   ```bash
   ./packaging/create_release.sh
   ```

   This will:
   - Build the .deb package if needed
   - Create a GitHub release with the .deb file attached
   - Requires GitHub CLI (`gh`) to be installed and authenticated

#### Option 2: Using GitHub Actions

1. **Tag the release:**
   ```bash
   git tag -a v1.0.0 -m "Release version 1.0.0"
   git push origin v1.0.0
   ```

   The GitHub Actions workflow will automatically:
   - Build the .deb package
   - Create a GitHub release with the .deb file attached

#### Option 3: Manual release

1. **Build the package:**
   ```bash
   ./packaging/build_deb.sh
   ```

2. **Create release on GitHub:**
   - Go to: https://github.com/pkariithi/manned/releases/new
   - Tag: `v1.0.0` (match your version)
   - Title: `Manned Pages 1.0.0`
   - Upload the `.deb` file
   - Add installation instructions in the description

## Package Information

- **Package Name**: `manned-pages`
- **Section**: `utils`
- **Architecture**: `amd64`
- **Dependencies**: `libgtk-3-0`, `libglib2.0-0`, `libc6`

