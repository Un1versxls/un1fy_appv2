#!/bin/bash

set -e

echo "=== Current working directory: $(pwd) ==="

# Navigate to repo root using absolute path
cd /Users/runner/work/un1fy_appv2/un1fy_appv2

echo "=== Now at: $(pwd) ==="
ls -la

PROJECT="./DRIVE.xcodeproj"
SCHEME="DRIVE"
CONFIGURATION="Release"
SDK="iphoneos"
DERIVED_DATA="build/DerivedData"
ARCHIVE_PATH="build/DRIVE.xcarchive"

mkdir -p "$DERIVED_DATA"

echo "=== Building project: $PROJECT ==="
xcodebuild archive \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -configuration "$CONFIGURATION" \
  -sdk "$SDK" \
  -derivedDataPath "$DERIVED_DATA" \
  -archivePath "$ARCHIVE_PATH" \
  CODE_SIGNING_ALLOWED=NO