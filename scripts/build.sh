#!/bin/bash

set -e

echo "=== Starting directory: $(pwd) ==="
echo "=== Contents: ==="
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