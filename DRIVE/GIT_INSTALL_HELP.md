# How to Install Git on Windows

Since automated installation failed, please install Git manually:

## Manual Installation Steps:

1. **Download Git Installer**
   - Go to: https://git-scm.com/download/win
   - Click the download button for Windows

2. **Run the Installer**
   - Double-click the downloaded file
   - Click "Next" through the setup wizard
   - Keep default options (this ensures Git is added to your PATH)
   - Click "Install"
   - Wait for installation to complete
   - Click "Finish"

3. **Verify Installation**
   - Open a NEW terminal window (important: after installation)
   - Run: `git --version`
   - Should show: `git version 2.x.x.windows.x`

4. **Configure Git (First Time)**
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```

## After Git is Installed:

1. Navigate to your project:
   ```bash
   cd "/c/Users/lucaz/Downloads/DRIVE"
   ```

2. Initialize git repo:
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git branch -M main
   ```

3. Create GitHub repository at: https://github.com/new
   - Repository name: un1fy_app (to match your URL)
   - Description: Optional
   - Public or Private: Your choice
   - DO NOT initialize with README/.gitignore/license
   - Click "Create repository"

4. Connect and push:
   ```bash
   git remote add origin https://github.com/Un1versxls/un1fy_app.git
   git push -u origin main
   ```

5. When prompted for credentials:
   - Username: Your GitHub username
   - Password: Use a Personal Access Token (NOT your GitHub password)
     - Create at: https://github.com/settings/tokens
     - Select "repo" scope
     - Generate and copy the token
     - Paste when prompted for password

## Troubleshooting:

- **"git' is not recognized"**: Close and reopen terminal AFTER installing Git
- **Authentication failed**: Use Personal Access Token, not your GitHub password
- **Repository not found**: Double-check the URL and that you created the repo on GitHub

Once pushed to GitHub, the Actions workflow I created will automatically build your IPA.