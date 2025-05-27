<p align="center">
    <picture>
      <source
        media="(prefers-color-scheme: dark)"
        srcset="doc/images/storyzz-light.svg"
        width="250"
      >
      <source
        media="(prefers-color-scheme: light)"
        srcset="doc/images/storyzz-dark.svg"
        width="250"
      >
      <img alt="Storyzz" src="doc/images/storyzz-dark.svg">
    </picture>
</p>

<h3 align="center">
A Flutter application for sharing stories with images and location.
</h3>

## 🚀 Overview

Storyzz is a cross-platform Flutter application that enables users to share
stories with images and descriptions. The app provides authentication features,
story browsing, and creation capabilities with a modern, responsive UI that
supports both mobile and desktop platforms. Currently build for mobile and web platform.

[![codecov](https://codecov.io/github/waffiqaziz/storyzz/graph/badge.svg?token=KYFE69ZHVN)](https://codecov.io/github/waffiqaziz/storyzz)
[![Flutter Version](https://img.shields.io/badge/flutter-v3.32.0-blue?logo=flutter&logoColor=white)](https://github.com/flutter/flutter/blob/main/CHANGELOG.md#3320)

## ✨ Features

### Authentication

- **Login & Registration** - Secure user authentication system
- **Session Management** - Persistent login sessions using device preferences
- **Password Security** - Character masking for password fields

### Story Management

- **Story Feed** - Browse stories from other users
- **Story Details** - View full story information with images, descriptions,
  and a map of the story location.
- **Post Stories** - Upload images (max 1MB) with captions and location.
- **Map & List View** -  Display a split-screen showing a map with story
  locations alongside a scrollable list of stories.

### UI/UX

- **Responsive Design** - Optimized for both mobile and desktop views
- **Theme Support** - Toggle between light and dark themes
- **Localization** - Available in English and Indonesian

### Technical Features

- **Declarative Navigation** - Modern navigation system
- **Data Persistence** - Local storage for user preferences

## 🛠️ Getting Started

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

### Development Step by Step

To develop the project, please read [here](./doc/development.md).

## 📚 API Documentation

This application use several API's:

- Dicoding Story API:
  [https://story-api.dicoding.dev/v1/](https://story-api.dicoding.dev/v1/)
- Geocode API
  [https://geocode.maps.co/](https://geocode.maps.co/)

## 📸 Screenshots

<details>
<summary>📱 Mobile Platform | Light Mode</summary>
<p float="left">
  <img src="https://i.postimg.cc/CKJPKj5R/mobile-login.png"
    width="250" alt="Login Screen"
  />
  <img src="https://i.postimg.cc/FF24mQw2/mobile-register.png"
    width="250" alt="Register Screen"
  />
  <img src="https://i.postimg.cc/8Pr0bJKY/mobile-home.png"
    width="250" alt="Home Screen"
  />
</p>
<p float="left">
  <img src="https://i.postimg.cc/Jn2pNMbm/mobile-map.png"
    width="250" alt="Map Story Screen"
  />  
  <img src="https://i.postimg.cc/YC7BGzrR/mobile-upload-story.png"
    width="250" alt="Upload Story Screen"
    />
  <img src="https://i.postimg.cc/SRmcYPPq/mobile-upload-story2.png"
    width="250" alt="Upload Story Screen Filled"
    />
</p>
<p>
  <img src="https://i.postimg.cc/gcwWf0tV/mobile-settings.png"
    width="250" alt="Settings Screen"
  />
  <img src="https://i.postimg.cc/2SQ9spfF/mobile-localization.png"
    width="250" alt="Localization Dialog"
  />
  <img src="https://i.postimg.cc/XqtDb4Jx/mobile-detail.png"
    width="250" alt="Detail Screen"
  />
</p>
</details>

<details>
<summary>📱 Mobile Platform | Dark Mode</summary>
<p float="left">
  <img src="https://i.postimg.cc/JnnTHGHP/mobile-login-dark.png"
    width="250" alt="Login Screen (Dark)"
  />
  <img src="https://i.postimg.cc/J0HPKvqX/mobile-register-dark.png"
    width="250" alt="Register Screen (Dark)"
  />
  <img src="https://i.postimg.cc/x1DFpfB1/mobile-home-dark.png"
    width="250" alt="Home Screen (Dark)"
  />
</p>
<p float="left">
  <img src="https://i.postimg.cc/LhdvWDCb/mobile-map-dark.png"
    width="250" alt="Upload Map Screen (Dark)"
  />
  <img src="https://i.postimg.cc/k5XrwMtt/mobile-upload-story-dark.png"
    width="250" alt="Upload Story Screen (Dark)"
  />
    <img src="https://i.postimg.cc/cCTwRmq3/mobile-upload-story-dark2.png"
    width="250" alt="Upload Story Screen Filled (Dark)"
  />
</p>
<p>
  <img src="https://i.postimg.cc/pXztL6Hy/mobile-settings-dark.png"
    width="250" alt="Settings Screen (Dark)"
  />
  <img src="https://i.postimg.cc/fbMqZHz4/mobile-localization-dark.png"
    width="250" alt="Localization Dialog (Dark)"
  />
  <img src="https://i.postimg.cc/CM22DHND/mobile-detail-dark.png"
    width="250" alt="Detail Screen (Dark)"
  />
</p>
</details>

<details>
<summary>🖥️ Desktop Platform | Light Mode</summary>
<p>
  <img src="https://i.postimg.cc/25Fp7b6Y/desktop-login.png"
    width="400" alt="Login Screen"
  />
  <img src="https://i.postimg.cc/dQNb6Kqh/desktop-register.png"
    width="400" alt="Register Screen"
  />
</p>
<p>
  <img src="https://i.postimg.cc/fT46pf9s/desktop-home.png"
    width="400" alt="Home Screen"
  />
  <img src="https://i.postimg.cc/50xh74YC/desktop-map.png"
    width="400" alt="Map Screen"
  />
</p>
<p>
  <img src="https://i.postimg.cc/GhZZ0JTr/desktop-upload-story.png"
    width="400" alt="Upload Story Screen"
  />
  <img src="https://i.postimg.cc/BbzRn2hT/desktop-settings.png"
    width="400" alt="Settings Screen"
  />
</p>
<p>
  <img src="https://i.postimg.cc/pdB7nwGX/desktop-upload-story2.png"
    width="400" alt="Upload Story Screen Filled Top"
  />
  <img src="https://i.postimg.cc/PxWmxH22/desktop-upload-story3.png"
    width="400" alt="Upload Story Screen Filled Bottom"
  />
</p>
<p>
  <img src="https://i.postimg.cc/9fx6k3Gg/desktop-detail1.png"
    width="400" alt="Dialog Detail Screen Top"
  />
  <img src="https://i.postimg.cc/d1pzq8N8/desktop-detail2.png"
    width="400" alt="Dialog Detail Screen Bottom"
  />
</p>
<p>
  <img src="https://i.postimg.cc/13sb5RBY/desktop-localization.png"
    width="400" alt="Localization Dialog"
  />
</p>
</details>

<details>
<summary>🖥️ Desktop Platform | Dark Mode</summary>
<p>
  <img src="https://i.postimg.cc/Xv0S5cnx/desktop-login-dark.png"
    width="400" alt="Login Screen (Dark)"
  />
  <img src="https://i.postimg.cc/BnHRJL2F/desktop-register-dark.png"
    width="400" alt="Register Screen (Dark)"
  />
</p>
<p>
  <img src="https://i.postimg.cc/3JgPT0Xv/desktop-home-dark.png"
    width="400" alt="Home Screen (Dark)"
  />
  <img src="https://i.postimg.cc/8ccqGZbk/desktop-map-dark.png"
    width="400" alt="Map Screen (Dark)"
  />
</p>
<p>
  <img src="https://i.postimg.cc/3whVN8Zc/desktop-upload-story-dark.png"
    width="400" alt="Upload Story Screen (Dark)"
  />
  <img src="https://i.postimg.cc/HsJfPPxB/desktop-settings-dark.png"
    width="400" alt="Settings Screen (Dark)"
  />
</p>
<p>
  <img src="https://i.postimg.cc/G275XknW/desktop-upload-story-dark2.png"
    width="400" alt="Upload Story Screen Top (Dark)"
  />  
  <img src="https://i.postimg.cc/FR5yNzgY/desktop-upload-story-dark3.png"
    width="400" alt="Upload Story Screen Bottom (Dark)"
  />
</p>
<p>
  <img src="https://i.postimg.cc/j2fBCLBB/desktop-detail1-dark.png"
    width="400" alt="Dialog Detail Screen Top (Dark)"
  />
  <img src="https://i.postimg.cc/v8xJ0NDX/desktop-detail2-dark.png"
    width="400" alt="Dialog Detail Screen Bottom (Dark)"
  />
</p>
<p>
  <img src="https://i.postimg.cc/FRD2wM3n/desktop-localization-dark.png"
    width="400" alt="Localization Dialog (Dark)"
  />
</p>
</details>

## License

[Apache Version 2.0](LICENSE)

```text
Copyright 2025 Waffiq Aziz

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0
