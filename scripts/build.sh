#!/bin/bash

set -e

echo "=== Current directory: $(pwd) ==="

# Find the repo root - go up until we find .xcodeproj
while [ ! -f "DRIVE.xcodeproj/project.pbxproj" ] && [ "$(pwd)" != "/" ]; do
  echo "Going up from: $(pwd)"
  cd ..
done

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