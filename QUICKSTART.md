# EdTech Flutter - Quick Start Guide

## 🚀 5-Minute Setup

### Step 1: Prerequisites Check ✅

Make sure Flutter is installed:
```bash
flutter doctor
```

If not installed, visit: https://flutter.dev/docs/get-started/install

### Step 2: Install Dependencies 📦

```bash
cd edtech_flutter
flutter pub get
```

### Step 3: Configure API Keys 🔑

Edit `lib/utils/constants.dart` and add your keys:

1. **Roboflow API Key** (https://roboflow.com/)
   ```dart
   static const String roboflowApiKey = 'YOUR_KEY_HERE';
   ```

2. **Gemini AI Key** (https://makersuite.google.com/app/apikey)
   ```dart
   static const String geminiApiKey = 'YOUR_KEY_HERE';
   ```

### Step 4: Run the App 🏃

```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device-id>

# Or simply run on default device
flutter run
```

## 📱 Quick Commands

| Command | Description |
|---------|-------------|
| `flutter run` | Start development |
| `r` (in terminal) | Hot reload |
| `R` (in terminal) | Hot restart |
| `q` (in terminal) | Quit |
| `flutter clean` | Clean build files |
| `flutter doctor` | Check setup |
| `flutter devices` | List devices |

## 🎯 What to Test

1. **Home Tab** - View features and toggle language
2. **Scan Tab** - Take photo or select from gallery
3. **History Tab** - View saved scans

## 📚 Need Help?

- **Full Setup Guide**: See `SETUP_INSTRUCTIONS.md`
- **Flutter Guide**: See `FLUTTER_COMPLETE_GUIDE.md`
- **Project Spec**: See `../setup_spec.md`

## ⚠️ Common Issues

**Issue**: "Flutter not found"
- **Fix**: Add Flutter to PATH or install from flutter.dev

**Issue**: "Package not found"
- **Fix**: Run `flutter pub get`

**Issue**: "Build failed"
- **Fix**: Run `flutter clean && flutter pub get && flutter run`

**Issue**: "API not working"
- **Fix**: Check API keys in `lib/utils/constants.dart`

## 🎉 That's It!

Your Flutter app should now be running. Happy coding! 🚀
