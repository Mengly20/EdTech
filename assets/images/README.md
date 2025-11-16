# Assets Directory

Place your image assets in this directory.

## Required Assets

- `icon.png` - App icon (512x512 recommended)
- `splash-icon.png` - Splash screen icon
- `adaptive-icon.png` - Android adaptive icon

## Usage

Images placed in this directory will be accessible in the app after declaring them in `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/images/
```

## Example Usage in Code

```dart
Image.asset('assets/images/icon.png')
```
