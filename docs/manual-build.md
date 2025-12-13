# Manual Build Guide

## How to Run Manual Builds

You can manually trigger builds from any branch using GitHub Actions interface.

### Steps

1. Go to **Actions** tab in GitHub
2. Select **"Build and Release"** workflow
3. Click **"Run workflow"** button
4. Configure build options:

### Build Options

| Option | Description | Default |
|--------|-------------|---------|
| **Build Frontend** | Build frontend assets | ✅ Yes |
| **Build Backend (Full with Frontend)** | Build backend with embedded frontend | ✅ Yes |
| **Build Backend (Slim without Frontend)** | Build lightweight backend without frontend | ✅ Yes |
| **Build Desktop Application** | Build Tauri desktop app | ✅ Yes |
| **Target Platforms** | Platforms to build for | `all` |
| **Create Release** | Create release with built artifacts (for testing) | ❌ No |
| **Release Tag** | Custom tag name (e.g., v0.9.7-test) or leave empty for auto | _(empty)_ |

### Platform Selection

**Available platforms:**

- `linux-x64` - Linux x86_64
- `linux-arm64` - Linux ARM64
- `macos-x64` - macOS Intel
- `macos-arm64` - macOS Apple Silicon
- `windows-x64` - Windows x64
- `windows-arm64` - Windows ARM64
- `all` - All platforms (default)

**Examples:**

- `linux-x64` - Only Linux x64
- `linux-x64,linux-arm64` - Both Linux architectures
- `linux-x64,macos-arm64` - Linux x64 and macOS ARM64
- `all` - All platforms

### Common Use Cases

#### Test Slim Build for Linux Only (with Custom Release Tag)

```md
✅ Build Frontend: No
✅ Build Backend (Full): No
✅ Build Backend (Slim): Yes
✅ Build Desktop: No
✅ Create Release: Yes
Release Tag: v0.9.7-slim-test
Target Platforms: linux-x64,linux-arm64
```

**Result:** Creates prerelease `v0.9.7-slim-test` with only slim Linux binaries

#### Test Slim Build (Auto-generated Tag)

```md
✅ Build Backend (Slim): Yes
✅ Create Release: Yes
Release Tag: (leave empty)
Target Platforms: linux-x64
```

**Result:** Creates prerelease `manual-abc1234-20231213-143000` with slim Linux x64 binary

#### Test Desktop App for macOS

```md
✅ Build Frontend: Yes
✅ Build Backend (Full): No
✅ Build Backend (Slim): No
✅ Build Desktop: Yes
Target Platforms: macos-x64,macos-arm64
```

#### Test Only Frontend Build

```md
✅ Build Frontend: Yes
✅ Build Backend (Full): No
✅ Build Backend (Slim): No
✅ Build Desktop: No
Target Platforms: all
```

#### Full Build for Single Platform (Testing)

```md
✅ Build Frontend: Yes
✅ Build Backend (Full): Yes
✅ Build Backend (Slim): Yes
✅ Build Desktop: Yes
Target Platforms: linux-x64
```

### Automatic Builds

Automatic builds still work as before:

- **Push to main** with changes in `backend/`, `frontend/`, `src-tauri/` → Full build for all platforms (no release)
- **Push tag `v*`** → Full build + Release creation (official release)

### Release Behavior

| Trigger | Create Release | Release Tag | Release Name | Artifacts |
|---------|----------------|-------------|--------------|-----------|
| Push to main | ❌ No | - | - | Available for download only |
| Push tag `v*` | ✅ Yes | Auto (from git tag) | `Release v0.9.6` | All built artifacts |
| Manual + Release ✅ + Custom Tag | ✅ Yes | `v0.9.7-test` | `v0.9.7-test` (prerelease) | Only selected artifacts |
| Manual + Release ✅ + Empty Tag | ✅ Yes | Auto-generated | `manual-abc1234-...` (prerelease) | Only selected artifacts |
| Manual + Release ❌ | ❌ No | - | - | Available for download only |

### Notes

- Manual builds can be run from **any branch**
- Artifacts are always available for download after build completes
- Official releases are created only for tagged versions (`v*`)
- Manual releases are marked as **prerelease** and named `manual-{commit}-{timestamp}`
- Build time depends on selected options and platforms
- If a job is skipped (unchecked), release will only include artifacts from jobs that ran

### Important

**When using "Create Release" for manual testing:**

- Release will be marked as **prerelease** (not official)
- **Custom tag**: Use your own tag name (e.g., `v0.9.7-slim-test`, `test-build-1`)
- **Auto tag**: Leave empty for `manual-{commit}-{timestamp}` format
- Only artifacts from selected builds will be included
- You can delete test releases after verification
- This does NOT affect automatic releases for tags

**Tag naming recommendations:**

- `v0.9.7-test` - Version-based test
- `v0.9.7-slim-linux` - Specific feature test
- `test-{feature}` - Feature testing
- Leave empty for auto-generated timestamp tag
