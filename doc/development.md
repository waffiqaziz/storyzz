# Development Setup

This guide will help you set up the Storyzz project for local development.

## Prerequisites

- [Git](https://git-scm.com/) (latest stable version)
- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Flutter Version Management (FVM)](https://fvm.app/)
- An IDE ([VS Code](https://code.visualstudio.com/download),
[Android Studio](https://developer.android.com/studio), etc.)

## Setup Steps

### 1. Clone the repository

```bash
git clone https://github.com/waffiqaziz/storyzz.git
cd storyzz
```

### 2. Flutter Version Management (FVM)

This project uses FVM (Flutter Version Management) to ensure consistency across
development environments.

Install and use the required Flutter version `3.35.2` via FVM:

```bash
fvm install 3.35.2
fvm use 3.35.2
```

### 3. Install dependencies

```bash
flutter pub get
```

### 4. Generate required files

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 5. Configure API Keys

This project requires two API keys:

#### **Google Maps API**

Obtain your API key from the [Google Maps Platform](https://developers.google.com/maps/get-started#quickstart).

- **Web**: Create `web/env.js` with:

  ```javascript
  window.ENV = {
    GOOGLE_MAPS_API_KEY: 'YOUR_API_KEY'
  };
  ```

- **Android**: Add to `android/app/src/main/AndroidManifest.xml`:

  ```xml
  <meta-data
      android:name="com.google.android.geo.API_KEY"
      android:value="YOUR_API_KEY" />
  ```

- **iOS**: Add to `ios/Runner/AppDelegate.swift`:

  ```swift
  GMSServices.provideAPIKey("YOUR_API_KEY")
  ```

#### **Geocode API**

Obtain your API key from [Geocode Maps](https://geocode.maps.co/).

- **Web**: Update `web/env.js` to include:

  ```javascript
  window.ENV = {
    GOOGLE_MAPS_API_KEY: 'YOUR_GOOGLE_MAPS_API_KEY',
    GEOCODE_API_KEY: 'YOUR_GEOCODE_API_KEY'
  };
  ```

- **Android/iOS**: Create `assets/.env` with:

  ```env
  GEOCODE_API_KEY='YOUR_API_KEY'
  ```

### 5. Run the application

```bash
flutter run
```

## Testing

This project includes several test to ensure the correctness of the application.
We use GitHub Actions  to automatically run the tests on each pull request, and
you can view the results [here](https://github.com/waffiqaziz/storyzz/actions/workflows/flutter_ci_cd.yml).
To run testing on your local machine please read [here](testing.md).

## Building Android Variants

The app has two flavor variants:

- **Free**: Users cannot attach location when posting stories
- **Paid/Premium**: Users can attach location when posting stories

### Development (Debugging)

```bash
# Run Free version
flutter run --flavor free

# Run Paid version
flutter run --flavor paid
```

### Production Builds

```bash
# Build Free version APK
flutter build apk --flavor free -t lib/main.dart

# Build Paid version APK
flutter build apk --flavor paid -t lib/main.dart
```
