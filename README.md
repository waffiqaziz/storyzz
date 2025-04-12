# Storyzz

## 🚀 Introduction

Storyzz is a Flutter mobile application that allows users to share stories with images and descriptions. Users can register, login, view stories from other users, and add their own stories to the platform.

## 🌟 Features

This application includes the following key features:

### 1. Authentication Pages

- **Login Page**: Allows users to log in to the application
- **Register Page**: Allows new users to create an account
- **Password Security**: Character masking for password fields
- **Session Management**: Stores session and token data in device preferences
  - Automatically redirects to the main page if the user is already logged in
  - Directs to the login page if no active session exists
- **Logout Functionality**: Allows users to log out, clearing token and session information

### 2. Story Pages

- **Story List**: Displays a list of stories from the API, showing usernames and photos
- **Story Detail**: Shows detailed information (username, photo, and description) when a story item is tapped

### 3. Add Story

- **Create Story**: Interface for users to add new stories
- **Post Image**: Upload an image, with max size 1MB
- **Caption**: Allows users to add a brief description related to the image when creating a new story

### 4. Advanced Navigation

- Implements declarative navigation throughout the application using Flutter's navigation system

### 5. Dark and Light Themes

- Support dark and light themes
- Adjusted by system or select manually

### 6. Support Multi-languages

- Support localization
- Currently support English (en-US) and Indonesian (id-ID) languages

## 🛠️ Getting Started

API Doc: [https://story-api.dicoding.dev/v1/](https://story-api.dicoding.dev/v1/)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## 📸 Screenshots

<details>
<summary>📱 Mobile Platform | 🌞 Light Mode</summary>
<img src="./doc/screenshots/mobile-login.png" width=250 alt="Mobile Login Screen Light Mode">&nbsp;
<img src="./doc/screenshots/mobile-register.png" width=250 alt="Mobile Register Screen Light Mode">&nbsp;
<img src="./doc/screenshots/mobile-localization.png" width=250 alt="Mobile Localization Dialog Light Mode">&nbsp;
<img src="./doc/screenshots/mobile-home.png" width=250 alt="Mobile Home Screen Light Mode">&nbsp;
<img src="./doc/screenshots/mobile-upload-story.png" width=250 alt="Mobile Upload Story Screen Light Mode">&nbsp;
<img src="./doc/screenshots/mobile-settings.png" width=250 alt="Mobile Settings Screen Light Mode">&nbsp;
</details>

<br>

<details>
<summary>📱 Mobile Platform | 🌙 Dark Mode</summary>
<img src="./doc/screenshots/mobile-login-dark.png" width=250 alt="Mobile Login Screen Dark Mode">&nbsp;
<img src="./doc/screenshots/mobile-register-dark.png" width=250 alt="Mobile Register Screen Dark Mode">&nbsp;
<img src="./doc/screenshots/mobile-localization-dark.png" width=250 alt="Mobile Localization Dialog Dark Mode">&nbsp;
<img src="./doc/screenshots/mobile-home-dark.png" width=250 alt="Mobile Home Screen Dark Mode">&nbsp;
<img src="./doc/screenshots/mobile-upload-story-dark.png" width=250 alt="Mobile Upload Story Screen Dark Mode">&nbsp;
<img src="./doc/screenshots/mobile-settings-dark.png" width=250 alt="Mobile Settings Screen Dark Mode">&nbsp;
</details>

<br>

<details>
<summary>🌐 Desktop Web Platform | 🌞 Light Mode</summary>
<img src="./doc/screenshots/desktop-login.png" width=400 alt="Desktop Login Screen Light Mode">&nbsp;
<img src="./doc/screenshots/desktop-register.png" width=400 alt="Desktop Register Screen Light Mode">&nbsp;
<img src="./doc/screenshots/desktop-localization.png" width=400 alt="Desktop Localization Dialog Light Mode">&nbsp;
<img src="./doc/screenshots/desktop-home.png" width=400 alt="Desktop Home Screen Light Mode">&nbsp;
<img src="./doc/screenshots/desktop-upload-story.png" width=400 alt="Desktop Upload Story Screen Light Mode">&nbsp;
<img src="./doc/screenshots/desktop-settings.png" width=400 alt="Desktop Settings Screen Light Mode">&nbsp;
</details>

<br>

<details>
<summary>🌐 Desktop Web Platform | 🌙 Dark Mode</summary>
<img src="./doc/screenshots/desktop-login-dark.png" width=400 alt="Desktop Login Screen Dark Mode">&nbsp;
<img src="./doc/screenshots/desktop-register-dark.png" width=400 alt="Desktop Register Screen Dark Mode">&nbsp;
<img src="./doc/screenshots/desktop-localization-dark.png" width=400 alt="Desktop Localization Dialog Dark Mode">&nbsp;
<img src="./doc/screenshots/desktop-home-dark.png" width=400 alt="Desktop Home Screen Dark Mode">&nbsp;
<img src="./doc/screenshots/desktop-upload-story-dark.png" width=400 alt="Desktop Upload Story Screen Dark Mode">&nbsp;
<img src="./doc/screenshots/desktop-settings-dark.png" width=400 alt="Desktop Settings Screen Dark Mode">&nbsp;
</details>
