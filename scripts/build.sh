#!/bin/bash

set -e

# Determine if we're running from repo root or DRIVE directory
if [ -f "../DRIVE.xcodeproj/project.pbxproj" ]; then
  # We're in the DRIVE directory
  PROJECT="../DRIVE.xcodeproj"
elif [ -f "DRIVE.xcodeproj/project.pbxproj" ]; then
  # We're in the repository root
  PROJECT="DRIVE.xcodeproj"
else
  echo "Error: Could not find DRIVE.xcodeproj"
  exit 1
fi

SCHEME="DRIVE"
CONFIGURATION="Release"
SDK="iphoneos"
DERIVED_DATA="../build/DerivedData"
ARCHIVE_PATH="../build/DRIVE.xcarchive"
EXPORT_PATH="../build/export"

# Create output directories
mkdir -p "$DERIVED_DATA"
mkdir -p "$EXPORT_PATH"

# Clean previous builds
xcodebuild clean -project "$PROJECT" -scheme "$SCHEME" -configuration "$CONFIGURATION" -derivedDataPath "$DERIVED_DATA"

# Build and archive with code signing disabled for CI
xcodebuild archive \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -configuration "$CONFIGURATION" \
  -sdk "$SDK" \
  -derivedDataPath "$DERIVED_DATA" \
  -archivePath "$ARCHIVE_PATH" \
  CODE_SIGNING_ALLOWED=NO \
  CODE_SIGN_IDENTITY="" \
  PROVISIONING_PROFILE=""

echo "Archive created at: $ARCHIVE_PATH"

# Note: To export an IPA for sideloading, you need an ExportOptions.plist. You can create one using Xcode's Export function.
# Example export command:
# xcodebuild -exportArchive -archivePath "$ARCHIVE_PATH" -exportOptionsPlist "ExportOptions.plist" -exportPath "$EXPORT_PATH"

echo "Build script finished. Use Xcode to export the archive to an IPA for sideloading."