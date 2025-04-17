# Storyzz

A Flutter application for sharing stories with images.

## 🚀 Overview

Storyzz is a cross-platform Flutter application that enables users to share stories with images and descriptions. The app provides authentication features, story browsing, and creation capabilities with a modern, responsive UI that supports both mobile and desktop platforms. Currently build for mobile and web platform.

## ✨ Features

### Authentication

- **Login & Registration** - Secure user authentication system
- **Session Management** - Persistent login sessions using device preferences
- **Password Security** - Character masking for password fields

### Story Management

- **Story Feed** - Browse stories from other users
- **Story Details** - View full story information with images, descriptions, and a map of the story location.
- **Create Stories** - Upload images (max 1MB) with custom captions
- **Map & List View** -  Display a split-screen showing a map with story locations alongside a scrollable list of stories.

### UI/UX

- **Responsive Design** - Optimized for both mobile and desktop platforms
- **Theme Support** - Toggle between light and dark themes
- **Localization** - Available in English and Indonesian

### Technical Features

- **Declarative Navigation** - Modern navigation system
- **API Integration** - Connected to Dicoding Story API
- **Data Persistence** - Local storage for user preferences

## 🛠️ Getting Started

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- An IDE (VS Code, Android Studio, etc.)

### Installation

1. Clone the repository

   ```bash
   git clone https://github.com/waffiqaziz/storyzz.git
   ```

2. Navigate to project directory and install dependencies

   ```bash
   cd storyzz
   flutter pub get
   ```

3. Generate required files

   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. Environment Setup

   - **Web**

     For local development web, create a local version of `web/env.js` with your      development API key:

     ```js
     window.ENV = {
       GOOGLE_MAPS_API_KEY: 'YOUR_API_KEY'
     };
     ```

   - **Android**

     Add your api on `android\app\src\main\AndroidManifest.xml`

     ```xml
     ...
     // TODO: Add your Google Maps Api Key here
     <meta-data
         android:name="com.google.android.geo.API_KEY"
         android:value="YOUR_API_KEY" />
     ...
     ```

   - **iOS**

     Add your api on `ios\Runner\AppDelegate.swift`

     ```swift
     ...
     // TODO: Add your Google Maps Api Key here
     GMSServices.provideAPIKey("YOUR_API_KEY")
     ...
     ```

5. Run the application

   ```bash
   flutter run
   ```

## 📚 API Documentation

This application uses the Dicoding Story API:
[https://story-api.dicoding.dev/v1/](https://story-api.dicoding.dev/v1/)

## 📸 Screenshots

<details>
<summary>📱 Mobile Platform | Light Mode</summary>
<p float="left">
  <img src="./doc/screenshots/mobile-login.png" width="250" alt="Login Screen" />
  <img src="./doc/screenshots/mobile-register.png" width="250" alt="Register Screen" />
  <img src="./doc/screenshots/mobile-home.png" width="250" alt="Home Screen" />
</p>
<p float="left">
  <img src="./doc/screenshots/mobile-upload-story.png" width="250" alt="Upload Story Screen" />
  <img src="./doc/screenshots/mobile-settings.png" width="250" alt="Settings Screen" />
  <img src="./doc/screenshots/mobile-localization.png" width="250" alt="Localization Dialog" />
</p>
</details>

<details>
<summary>📱 Mobile Platform | Dark Mode</summary>
<p float="left">
  <img src="./doc/screenshots/mobile-login-dark.png" width="250" alt="Login Screen (Dark)" />
  <img src="./doc/screenshots/mobile-register-dark.png" width="250" alt="Register Screen (Dark)" />
  <img src="./doc/screenshots/mobile-home-dark.png" width="250" alt="Home Screen (Dark)" />
</p>
<p float="left">
  <img src="./doc/screenshots/mobile-upload-story-dark.png" width="250" alt="Upload Story Screen (Dark)" />
  <img src="./doc/screenshots/mobile-settings-dark.png" width="250" alt="Settings Screen (Dark)" />
  <img src="./doc/screenshots/mobile-localization-dark.png" width="250" alt="Localization Dialog (Dark)" />
</p>
</details>

<details>
<summary>🖥️ Desktop Platform | Light Mode</summary>
<p>
  <img src="./doc/screenshots/desktop-login.png" width="400" alt="Login Screen" />
  <img src="./doc/screenshots/desktop-register.png" width="400" alt="Register Screen" />
</p>
<p>
  <img src="./doc/screenshots/desktop-home.png" width="400" alt="Home Screen" />
  <img src="./doc/screenshots/desktop-upload-story.png" width="400" alt="Upload Story Screen" />
</p>
<p>
  <img src="./doc/screenshots/desktop-settings.png" width="400" alt="Settings Screen" />
  <img src="./doc/screenshots/desktop-localization.png" width="400" alt="Localization Dialog" />
</p>
</details>

<details>
<summary>🖥️ Desktop Platform | Dark Mode</summary>
<p>
  <img src="./doc/screenshots/desktop-login-dark.png" width="400" alt="Login Screen (Dark)" />
  <img src="./doc/screenshots/desktop-register-dark.png" width="400" alt="Register Screen (Dark)" />
</p>
<p>
  <img src="./doc/screenshots/desktop-home-dark.png" width="400" alt="Home Screen (Dark)" />
  <img src="./doc/screenshots/desktop-upload-story-dark.png" width="400" alt="Upload Story Screen (Dark)" />
</p>
<p>
  <img src="./doc/screenshots/desktop-settings-dark.png" width="400" alt="Settings Screen (Dark)" />
  <img src="./doc/screenshots/desktop-localization-dark.png" width="400" alt="Localization Dialog (Dark)" />
</p>
</details>
