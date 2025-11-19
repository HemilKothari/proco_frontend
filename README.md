# ProCo Frontend

ProCo Frontend is a mobile application built using **Flutter** and **Dart**.  
It connects to the ProCo Server API and provides the UI for authentication, job browsing, swiping, chatting, bookmarks, and user profile management.

---

## 🚀 Features

- Cross-platform app (Android & iOS)
- Clean UI screens for login, jobs, chat, swipes, bookmarks, and profile
- API integration with the ProCo backend
- Organized project structure with reusable widgets/services

---

## 📦 Technology Stack

- **Flutter**
- **Dart**
- **REST API Integration**

---

## ⚙️ Setup & Installation Guide

Follow these steps to run this Flutter app locally:

### 1. Install Flutter
Follow official installation steps:  
https://docs.flutter.dev/get-started/install

After installation, verify setup:
```bash
flutter doctor
```

### 2. Clone the repository
```bash
git clone https://github.com/HemilKothari/proco_frontend.git
cd proco_frontend
```

### 3. Install project dependencies
```bash
flutter pub get
```

### 4. Configure environment (if required)
If your project uses an API base URL or environment variables, update it under:
```
lib/config.dart
```
or whichever config file your project uses.

### 5. Run the project
Start a device or emulator, then run:
```bash
flutter run
```

### 6. Build for release (optional)
```bash
flutter build apk --release
```
For iOS:
```bash
flutter build ios --release
```

---

## 🚀 Deployment Notes

- The app is fully ready for deployment to **Google Play Store** or **Apple App Store**.
- Make sure backend API routes in service files match the live server URLs.
- Update `version:` in `pubspec.yaml` for every release.

---
