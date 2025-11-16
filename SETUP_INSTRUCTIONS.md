# EdTech Flutter - Setup Instructions

## Prerequisites

Before you can run this Flutter project, ensure you have:

1. **Flutter SDK** (>=3.0.0) installed
   - Download from: https://flutter.dev/docs/get-started/install
   - Verify installation: `flutter doctor`

2. **Android Studio** or **Xcode** (for iOS on macOS)
   - Android Studio: https://developer.android.com/studio
   - Xcode (macOS only): Install from App Store

3. **VS Code** with Flutter extension (recommended)
   - Download: https://code.visualstudio.com/
   - Install Flutter extension

## Installation Steps

### Step 1: Install Dependencies

```bash
cd edtech_flutter
flutter pub get
```

This will download all required packages listed in `pubspec.yaml`.

### Step 2: Configure API Keys

You need to configure three API keys in `lib/utils/constants.dart`:

#### 2.1 Roboflow API Key (Required)

1. Go to https://roboflow.com/
2. Create a free account
3. Get your API key
4. Open `lib/utils/constants.dart`
5. Replace `YOUR_ROBOFLOW_API_KEY` with your actual key
6. Replace `YOUR_MODEL` in the model URL with your Roboflow model ID

```dart
static const String roboflowApiKey = 'abc123xyz456';
static const String roboflowModelUrl = 'https://detect.roboflow.com/your-model-id/1';
```

#### 2.2 Google Gemini AI Key (Required)

1. Go to https://makersuite.google.com/app/apikey
2. Create API key (free tier available)
3. Open `lib/utils/constants.dart`
4. Replace `YOUR_GEMINI_API_KEY` with your actual key

```dart
static const String geminiApiKey = 'AIza...';
```

#### 2.3 Google OAuth Client ID (Optional - for Google Drive backup)

1. Go to https://console.cloud.google.com/
2. Create a new project
3. Enable Google Drive API
4. Create OAuth 2.0 credentials
5. Open `lib/utils/constants.dart`
6. Replace `YOUR_CLIENT_ID.apps.googleusercontent.com` with your client ID

```dart
static const String googleClientId = 'your-id.apps.googleusercontent.com';
```

### Step 3: Run the Application

#### Option A: Run on Android Emulator

1. Start Android Studio
2. Open AVD Manager
3. Start an emulator
4. Run:
   ```bash
   flutter run -d android
   ```

#### Option B: Run on iOS Simulator (macOS only)

1. Run:
   ```bash
   flutter run -d iphone
   ```

#### Option C: Run on Physical Device

1. Connect your device via USB
2. Enable USB debugging (Android) or trust computer (iOS)
3. Run:
   ```bash
   flutter devices  # List available devices
   flutter run -d <device-id>
   ```

#### Option D: Run on Web Browser

```bash
flutter run -d chrome
```

**Note:** Camera features may not work properly in web browser.

### Step 4: Development Mode Features

While the app is running, you can use these commands:

- Press `r` - Hot reload (fast refresh, preserves state)
- Press `R` - Hot restart (full restart)
- Press `q` - Quit

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/                      # Data models
│   ├── equipment.dart
│   ├── scan_result.dart
│   ├── chat_message.dart
│   └── scan_history_item.dart
├── providers/                   # State management
│   ├── app_state.dart
│   ├── language_provider.dart
│   └── scan_history_provider.dart
├── screens/                     # UI screens
│   ├── home_screen.dart
│   ├── scan_screen.dart
│   └── history_screen.dart
├── services/                    # API services
│   ├── roboflow_service.dart
│   ├── gemini_service.dart
│   ├── storage_service.dart
│   └── drive_service.dart
├── utils/                       # Utilities
│   ├── constants.dart           # API keys & constants
│   ├── equipment_database.dart  # 16 equipment definitions
│   ├── translations.dart        # English & Khmer translations
│   └── theme.dart              # App theme
└── config/                      # Configuration (future use)
```

## Building for Production

### Android APK

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### iOS (macOS only)

```bash
flutter build ios --release
```

Then open Xcode and archive the app.

## Troubleshooting

### Issue: "Flutter not found"

**Solution:** Ensure Flutter is added to your PATH:
```bash
export PATH="$PATH:`pwd`/flutter/bin"
```

### Issue: "Dependencies not found"

**Solution:** Run:
```bash
flutter clean
flutter pub get
```

### Issue: "API Key not working"

**Solution:** 
- Verify API keys are correctly copied
- Check for extra spaces or quotes
- Ensure API quotas are not exceeded

### Issue: "Camera permission denied"

**Solution:**
- Grant camera permission in device settings
- Restart the app

### Issue: "Build failed"

**Solution:**
```bash
flutter clean
flutter pub get
flutter pub upgrade
flutter run
```

## Testing the App

1. **Test Scanning:**
   - Go to Scan tab
   - Take photo or select from gallery
   - Verify equipment detection works

2. **Test AI Chat:**
   - After scanning equipment
   - Type a question about the equipment
   - Verify AI responds

3. **Test History:**
   - Scan multiple items
   - Go to History tab
   - Verify scans are saved

4. **Test Language Toggle:**
   - Toggle language on Home screen
   - Verify UI updates to Khmer/English

5. **Test Data Management:**
   - Try backing up to Google Drive (if configured)
   - Try clearing all data
   - Verify data persists after app restart

## Next Steps

1. Configure all API keys
2. Test all features
3. Customize equipment database if needed
4. Build and deploy to devices

## Support

For issues or questions, refer to:
- Flutter Documentation: https://flutter.dev/docs
- Project Specification: `../setup_spec.md`
- GitHub Issues: (if repository exists)

## License

Educational use only.
