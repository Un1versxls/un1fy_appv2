#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$REPO_ROOT/DRIVE"

echo "Working directory: $(pwd)"
echo "Looking for project: $(find . -name '*.xcodeproj' -type d)"

PROJECT=$(find . -name '*.xcodeproj' -type d | head -1)
echo "Using project: $PROJECT"

SCHEME="DRIVE"
CONFIGURATION="Release"
SDK="iphoneos"
DERIVED_DATA="../build/DerivedData"
ARCHIVE_PATH="../build/DRIVE.xcarchive"
EXPORT_PATH="../build/export"

mkdir -p "$DERIVED_DATA"
mkdir -p "$EXPORT_PATH"

echo "=== Cleaning previous builds ==="
xcodebuild clean -project "$PROJECT" -scheme "$SCHEME" -configuration "$CONFIGURATION" -derivedDataPath "$DERIVED_DATA" || true

echo "=== Building and archiving ==="
xcodebuild archive \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -configuration "$CONFIGURATION" \
  -sdk "$SDK" \
  -derivedDataPath "$DERIVED_DATA" \
  -archivePath "$ARCHIVE_PATH" \
  CODE_SIGNING_ALLOWED=NO \
  CODE_SIGN_IDENTITY="" \
  PROVISIONING_PROFILE="" \
  -verbose

echo "Archive created at: $ARCHIVE_PATH"
echo "Build script finished."