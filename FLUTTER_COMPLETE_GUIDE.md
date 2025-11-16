# Flutter Complete Implementation Guide

## Overview

This is the **Flutter implementation** of the EdTech Science Equipment Scanner app. It provides 100% feature parity with the React Native version while leveraging Flutter's cross-platform capabilities.

## Why Flutter?

✅ **Superior Performance** - Compiled to native code  
✅ **Hot Reload** - Instant updates during development  
✅ **Cross-Platform** - iOS, Android, Web, Desktop from single codebase  
✅ **Beautiful UI** - Material Design & Cupertino widgets  
✅ **Strong Typing** - Dart's type system prevents many bugs  
✅ **Growing Ecosystem** - 25,000+ packages on pub.dev

## Architecture

### State Management: Provider Pattern

This app uses the **Provider** package for state management:

- **AppState** - Current tab index, scanning status
- **LanguageProvider** - Current language, translations
- **ScanHistoryProvider** - Scan history, backup/sync operations

### Service Layer

All external APIs and storage are abstracted into services:

- **RoboflowService** - Image recognition API
- **GeminiService** - AI chatbot API
- **StorageService** - Local data persistence
- **DriveService** - Google Drive backup/sync

### UI Structure

Three main screens with bottom navigation:

1. **HomeScreen** - Welcome, features, language toggle
2. **ScanScreen** - Camera, image analysis, AI chat
3. **HistoryScreen** - Saved scans, data management

## Key Features Implementation

### 1. Camera & Image Picker

```dart
// Uses image_picker package
import 'package:image_picker/image_picker.dart';

final ImagePicker _picker = ImagePicker();

// Take photo
final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

// Pick from gallery
final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
```

### 2. Image Recognition (Roboflow API)

```dart
// Send image to Roboflow API
final imageBytes = await imageFile.readAsBytes();
final base64Image = base64Encode(imageBytes);

final response = await http.post(url, body: base64Image);
final data = jsonDecode(response.body);
```

### 3. AI Chat (Google Gemini)

```dart
// Initialize Gemini
final model = GenerativeModel(
  model: 'gemini-1.5-flash',
  apiKey: ApiConstants.geminiApiKey,
);

// Send message with context
final content = [Content.text('Context\n\nUser: $message')];
final response = await model.generateContent(content);
```

### 4. Local Storage (SharedPreferences)

```dart
// Save scan history
final prefs = await SharedPreferences.getInstance();
final jsonList = history.map((item) => item.toJson()).toList();
await prefs.setString('scan_history', jsonEncode(jsonList));

// Load scan history
final historyJson = prefs.getString('scan_history');
final decoded = jsonDecode(historyJson);
```

### 5. Bilingual Support

```dart
// Translations map
const Map<String, Map<String, String>> translations = {
  'en': {'welcome': 'Welcome', ...},
  'km': {'welcome': 'សូមស្វាគមន៍', ...},
};

// Usage
Text(Translations.get('welcome', currentLanguage))
```

## Comparison with React Native Version

| Aspect | React Native | Flutter |
|--------|-------------|---------|
| **File Structure** | Single file (App.tsx) | Modular (multiple files) |
| **State Management** | useState/useEffect | Provider pattern |
| **Navigation** | Custom tabs | BottomNavigationBar |
| **Styling** | StyleSheet API | Widget properties |
| **Hot Reload** | ~1.5s | ~0.6s |
| **Performance** | Excellent | Outstanding |

## Development Workflow

### 1. Start Development Server

```bash
flutter run
```

Flutter will:
- Compile the app
- Launch on connected device/emulator
- Enable hot reload

### 2. Make Changes

Edit any Dart file, then:

- Press `r` in terminal → Hot reload (preserves state)
- Press `R` in terminal → Hot restart (resets state)
- Or save file in VS Code (auto hot reload if enabled)

### 3. Debug

Use Flutter DevTools for advanced debugging:

```bash
flutter pub global activate devtools
flutter pub global run devtools
```

Features:
- Widget inspector
- Performance profiler
- Memory profiler
- Network inspector

## Adding New Features

### Example: Add New Equipment Type

1. **Update Equipment Database** (`lib/utils/equipment_database.dart`):

```dart
Equipment(
  className: 'new-equipment',
  nameEnglish: 'New Equipment',
  nameKhmer: 'ឧបករណ៍ថ្មី',
  category: 'Category',
  categoryKhmer: 'ប្រភេទ',
  usage: 'How to use...',
  icon: 'icon_name',
  tags: ['tag1', 'tag2'],
),
```

2. **Update Translations** (if needed) (`lib/utils/translations.dart`)

3. **Test** - Scan the new equipment

### Example: Add New Screen

1. **Create Screen File** (`lib/screens/new_screen.dart`):

```dart
class NewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Screen')),
      body: Center(child: Text('Content')),
    );
  }
}
```

2. **Add Navigation**:

```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => NewScreen()),
);
```

## Testing

### Unit Tests

```bash
flutter test
```

### Widget Tests

```dart
testWidgets('HomeScreen displays welcome message', (tester) async {
  await tester.pumpWidget(MyApp());
  expect(find.text('Welcome'), findsOneWidget);
});
```

### Integration Tests

```bash
flutter drive --target=test_driver/app.dart
```

## Building for Production

### Android

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# App Bundle (for Play Store)
flutter build appbundle --release
```

Output: `build/app/outputs/`

### iOS

```bash
flutter build ios --release
```

Then use Xcode to archive and upload to App Store.

### Web

```bash
flutter build web --release
```

Output: `build/web/`

### Desktop

```bash
# macOS
flutter build macos --release

# Windows
flutter build windows --release

# Linux
flutter build linux --release
```

## Performance Optimization

### 1. Use `const` Constructors

```dart
// Good
const Text('Hello')

// Bad
Text('Hello')
```

### 2. Avoid Rebuilding Widgets

```dart
// Use Consumer for targeted rebuilds
Consumer<LanguageProvider>(
  builder: (context, language, child) {
    return Text(language.currentLanguage);
  },
)
```

### 3. Optimize Images

```dart
Image.file(
  imageFile,
  cacheWidth: 800,  // Resize to max width
  cacheHeight: 600, // Resize to max height
)
```

### 4. Use ListView.builder

```dart
// Lazy loading for long lists
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ListTile(title: Text(items[index]));
  },
)
```

## Common Issues & Solutions

### Issue: "MissingPluginException"

**Solution:** Run `flutter clean && flutter pub get`

### Issue: "Hot reload not working"

**Solution:** Try hot restart (press `R`) or restart app

### Issue: "Build failed after adding package"

**Solution:**
```bash
flutter clean
flutter pub get
flutter run
```

### Issue: "Images not loading in release build"

**Solution:** Ensure images are declared in `pubspec.yaml`:
```yaml
flutter:
  assets:
    - assets/images/
```

## Best Practices

1. **Use Meaningful Names** - Widget and variable names should be clear
2. **Keep Widgets Small** - Break large widgets into smaller ones
3. **Use Provider Wisely** - Don't overuse global state
4. **Handle Errors** - Always wrap async calls in try-catch
5. **Follow Dart Style** - Use `dart format` to format code
6. **Write Tests** - Test critical functionality
7. **Document Code** - Add comments for complex logic

## Resources

### Official Documentation
- Flutter: https://flutter.dev/docs
- Dart: https://dart.dev/guides
- Provider: https://pub.dev/packages/provider

### Learning Resources
- Flutter Codelabs: https://flutter.dev/codelabs
- Flutter YouTube: https://www.youtube.com/flutterdev
- Dart Language Tour: https://dart.dev/guides/language/language-tour

### Community
- Flutter Discord: https://discord.gg/flutter
- r/FlutterDev: https://reddit.com/r/FlutterDev
- Stack Overflow: Tag `flutter`

## Next Steps

1. ✅ Complete setup and configuration
2. ✅ Test all features
3. ⬜ Customize for your needs
4. ⬜ Add new features
5. ⬜ Build and deploy

## License

Educational use only.

---

**Happy Flutter Development! 🚀**
