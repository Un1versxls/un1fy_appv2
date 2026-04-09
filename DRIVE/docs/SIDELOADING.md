# Sideloading DRIVE onto iOS Device

This guide explains how to install the DRIVE app on your iOS device without the App Store using Xcode and a free Apple ID.

## Prerequisites

- macOS with Xcode installed (latest version recommended)
- iOS device (iPhone or iPad)
- Apple ID (free account works)
- USB-C cable (or Lightning cable) to connect device to Mac

## Steps

1. **Open the Project**
   - Launch Xcode.
   - Open `DRIVE.xcodeproj` in the project root.

2. **Connect Your Device**
   - Connect your iOS device to your Mac via USB.
   - Trust the computer on your device if prompted.

3. **Select Development Team**
   - In Xcode, select the `DRIVE` target.
   - Go to the **Signing & Capabilities** tab.
   - Select your personal Apple ID under "Team". Xcode will create a free provisioning profile.

4. **Build and Run**
   - Choose your connected device as the run destination.
   - Press ⌘R or click the Play button to build and install the app on your device.
   - The app will launch on your device. You may need to trust the developer profile in Settings > General > VPN & Device Management > Developer App.

5. **Re-signing for Re-install (optional)**
   - If you need to export an IPA to sideload via AltStore or similar, use the provided `scripts/build.sh` to create an archive, then export using an `ExportOptions.plist` with method `developer-id` or `ad-hoc`.

6. **Troubleshooting**
   - Ensure your device is running a compatible iOS version (iOS 16+).
   - Free Apple IDs have a limited number of apps; revoke unused ones in Settings if needed.
   - Check Xcode's signing errors; sometimes you need to create a unique bundle identifier.

## Notes

- This app is for development purposes. Free provisioning requires re-signing every 7 days.
- For distribution beyond personal use, enroll in the Apple Developer Program.