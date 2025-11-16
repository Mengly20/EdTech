# EdTech Science Equipment Scanner - Flutter Version

A Flutter mobile application that helps students and educators identify science laboratory equipment using AI-powered image recognition.

## Features

- 📸 Camera-based equipment scanning
- 🤖 AI image recognition (Roboflow API)
- 🌐 Bilingual support (English & Khmer)
- 💬 AI chat assistant (Google Gemini)
- 📚 16 equipment types with detailed information
- 📊 Scan history with local storage
- ☁️ Google Drive backup/sync
- 🎨 Dark/Light theme support

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio or Xcode
- VS Code with Flutter extension (recommended)

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Configure API keys in `lib/utils/constants.dart`:
   - Roboflow API Key
   - Google Gemini AI Key
   - Google OAuth Client ID (optional)

4. Run the app:
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/                      # Data models
├── providers/                   # State management
├── screens/                     # UI screens
├── widgets/                     # Reusable widgets
├── services/                    # API services
├── utils/                       # Utilities & constants
└── config/                      # Configuration
```

## Documentation

See `setup_spec.md` in the parent directory for complete project specification.

## License

Educational use only.
