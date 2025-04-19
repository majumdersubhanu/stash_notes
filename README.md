# 📘 StashNotes

**StashNotes** is a lightweight, markdown-powered note-taking app built with **Flutter**. It offers essential features like **user authentication**, **offline-first storage**, and **cloud synchronization** via **Firebase**. Designed for simplicity and speed, it prioritizes a clean UI, robust offline capabilities, and privacy-conscious design.

---

## ✨ Features

### 🔐 Authentication

- Password-based user registration and login.
- Google Sign-In.
- Uses Firebase Authentication.
- Secure session management with automatic re-authentication.
- Guards in place to prevent access to notes without login.

### 📝 Markdown Editor

- Basic markdown syntax support:
  - Headers (`#`, `##`, etc.)
  - Bold, Italics, Strikethrough
  - Lists, Links, Blockquotes
  - Inline code and code blocks
- Toggle between **Edit** and **Preview** modes.

### 📶 Offline-First

- Notes are stored locally using `sqflite` package.
- Users can create, edit, and delete notes offline.
- Automatic sync logic when connectivity is restored.
- Local-first editing: writes go to local DB first, then queued for sync.

### ☁️ Cloud Sync

- Firebase Firestore used for persistent cloud storage.
- Notes are synced per authenticated user.

### 🗃️ Notes Management

- Create, update, and delete notes from a persistent list.
- Notes sorted by latest edit time.
- Search (basic string match).

### 📱 UI/UX

- Minimalist interface inspired by Markdown writing tools.
- Theming support (dark/light mode toggle).

---

## 🔧 Setup Guide

### Prerequisites

- Flutter SDK (Stable)
- Firebase CLI
- Firebase Project
- Android/iOS setup for Firebase

---

### 1. **Clone the Repository**

```bash
git clone https://github.com/majumdersubhanu/stashnotes.git
cd stashnotes
```

---

### 2. **Install Firebase CLI**

Install Firebase CLI globally using npm:

```bash
npm install -g firebase-tools
```

Login to your Firebase account:

```bash
firebase login
```

Initialize Firebase in your Flutter project directory:

```bash
firebase init
```

---

### 3. **Firebase Project Setup**

1. Go to [Firebase Console](https://console.firebase.google.com/) and create a new project.
2. Add **Android** and **iOS** apps to the project.

   #### Android

   - Download `google-services.json` and place it in:  
     `android/app/`

   - Add the SHA-1 and SHA-256 fingerprints (see below).

   #### iOS

   - Download `GoogleService-Info.plist` and place it in:  
     `ios/Runner/`

3. Enable **Email/Password Authentication** and **Google Sign-In** from the Firebase Console → Authentication → Sign-in methods.

4. Enable **Cloud Firestore** and apply the following security rules:

```js
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/notes/{noteId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

---

### 4. **Generate `signingReport` for Google Sign-In**

To configure Google Sign-In, you must register your SHA-1 and SHA-256 keys in the Firebase Console.

#### Steps

```bash
cd android
./gradlew signingReport
```

This will output your **SHA-1** and **SHA-256** fingerprints. Copy them and:

1. Go to Firebase Console → Project Settings → Your Apps → Android
2. Add the SHA-1 and SHA-256 under "Add Fingerprint"

Ensure your `android/app/build.gradle` includes:

```gradle
apply plugin: 'com.google.gms.google-services'
```

And the dependencies block includes:

```gradle
dependencies {
    implementation 'com.google.firebase:firebase-auth'
    implementation 'com.google.android.gms:play-services-auth'
}
```

---

### 5. **Run the App**

```bash
flutter pub get
flutter run
```
