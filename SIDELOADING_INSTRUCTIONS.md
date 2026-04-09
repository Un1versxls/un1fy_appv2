# How to Sideload DRIVE App onto iPhone using Sideloadly

## Prerequisites
1. Windows PC with iTunes installed (for USB drivers)
2. iPhone connected via USB cable
3. Apple ID (free or paid)
4. Sideloadly installed on your PC
5. DRIVE app built and exported as IPA

## Step-by-Step Instructions

### 1. Build and Export the IPA (if not already done)

The build script creates an archive, but you need to export it as an IPA:

```bash
# First run the build script (creates the archive)
./scripts/build.sh

# Then export as IPA (you'll need to create ExportOptions.plist first)
xcodebuild -exportArchive \
  -archivePath "build/DRIVE.xcarchive" \
  -exportOptionsPlist "ExportOptions.plist" \
  -exportPath "build/export"
```

### 2. Create ExportOptions.plist

Create this file in your project root:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>development</string>
    <key>provisioningProfiles</key>
    <dict>
        <key>com.yourcompany.DRIVE</key>
        <string>DRIVE Development</string>
    </dict>
    <key>signingStyle</key>
    <string>manual</string>
    <key>stripSwiftSymbols</key>
    <key>true</key>
    <key>teamID</key>
    <string>YOUR_TEAM_ID</string>
</dict>
</plist>
```

Note: For free Apple ID development, you can often use simpler options or let Xcode handle it automatically.

### 3. Download and Install Sideloadly

1. Go to https://sideloadly.io/
2. Download Sideloadly for Windows
3. Run the installer
4. Launch Sideloadly

### 4. Prepare Your iPhone

1. Connect your iPhone to your PC using a USB cable
2. On your iPhone, tap "Trust" when prompted to trust this computer
3. Ensure you're signed in with your Apple ID on the device (Settings > [your name])

### 5. Sideload the App

1. In Sideloadly, drag and drop the DRIVE.ipa file (from `build/export/DRIVE.ipa`)
2. Enter your Apple ID when prompted
3. If you have two-factor authentication enabled:
   - You'll need to use an app-specific password
   - Generate one at: https://appleid.apple.com/
4. Click the "Start" button
5. Wait for the process to complete (shows "Success" when done)

### 6. Trust the Developer Certificate

After installation completes:

1. On your iPhone, go to Settings > General > VPN & Device Management
2. Under "Developer App", find your Apple ID
3. Tap your Apple ID
4. Tap "Trust [Your Apple ID]"
5. Confirm by tapping "Trust" again

### 7. Launch the App

1. Find the DRIVE app icon on your home screen
2. Tap to open and use the app

## Important Notes

### Free Apple ID Limitations
- Apps need to be re-signed every 7 days
- You'll need to repeat the sideloading process weekly
- Some features (like push notifications) may be limited

### Paid Developer Account Benefits
- No 7-day re-signing requirement
- Access to all iOS features
- Ability to distribute via TestFlight/App Store

### Troubleshooting

**"Failed to create provisioning profile"**
- Make sure you're connected to the internet
- Try restarting Sideloadly
- Ensure your Apple ID has 2FA enabled (required for newer versions)

**"Unable to process application"**
- Check that the IPA is valid and not corrupted
- Try rebuilding the app
- Verify your ExportOptions.plist is correctly formatted

**"App crashed immediately on launch"**
- Check device console logs for more details
- Ensure minimum iOS version compatibility
- Try cleaning and rebuilding the project

### Alternative Methods

If Sideloadly doesn't work, you can also try:

1. **AltStore** - Similar sideloading tool with auto-renewal
2. **Xcode Direct Deployment** - If you have a Mac
3. **Apple Configurator** - For enterprise deployment

## Maintenance

To keep the app installed beyond 7 days with a free Apple ID:
1. Repeat the sideloading process weekly
2. Consider using AltStore which auto-renews every 7 days in background
3. Upgrade to a paid Apple Developer account for permanent installation

## Security Note

Only sideload apps from trusted sources. The DRIVE app you built yourself is safe to install.