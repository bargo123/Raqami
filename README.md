# Raqami

A Flutter-based marketplace platform for buying and selling premium phone numbers and car license plates in the United Arab Emirates.

## 📱 About

Raqami is a dedicated marketplace platform designed to connect buyers and sellers of premium phone numbers and car license plates in the UAE. The app provides a secure, user-friendly environment for transactions while ensuring authenticity and quality.

## ✨ Features

- **User Authentication**: Secure sign-up, login, and email verification
- **Post Management**: Create, edit, and delete posts for phone numbers and car plates
- **Advanced Filtering**: Filter posts by provider, code, emirate, and digit count
- **Wishlist**: Save favorite posts for later
- **Profile Management**: View and edit user profile information
- **Multi-language Support**: Full support for English and Arabic
- **Post Reporting**: Report inappropriate or suspicious posts
- **Contact & Support**: Easy access to contact information and privacy policy
- **Real-time Updates**: Live updates for post counts and wishlist items

## 🛠️ Tech Stack

- **Framework**: Flutter 3.8.1+
- **State Management**: Flutter Bloc
- **Backend**: Firebase (Firestore, Authentication, Storage)
- **Dependency Injection**: GetIt with Injectable
- **Localization**: Flutter Intl
- **UI Components**: Custom design system with Material Design 3

## 📋 Prerequisites

- Flutter SDK 3.8.1 or higher
- Dart SDK
- Firebase project setup
- Android Studio / Xcode (for mobile development)
- Git

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/bargo123/Raqami.git
cd Raqami
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Firebase Setup

1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Add Android and iOS apps to your Firebase project
3. Download configuration files:
   - `google-services.json` → Place in `android/app/`
   - `GoogleService-Info.plist` → Place in `ios/Runner/`
4. Run Firebase CLI to generate `firebase_options.dart`:
   ```bash
   flutterfire configure
   ```

### 4. Generate Code

Generate dependency injection and other generated code:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 5. Generate App Icons and Splash Screen

```bash
# Generate app icons
flutter pub run flutter_launcher_icons

# Generate splash screen
flutter pub run flutter_native_splash:create
```

### 6. Run the App

```bash
# For Android
flutter run

# For iOS
flutter run -d ios
```

## 📁 Project Structure

```
lib/
├── src/
│   ├── core/              # Core utilities and helpers
│   │   ├── localization/  # Localization helpers
│   │   └── utils/         # Utility functions
│   ├── data/              # Data layer (models, repositories implementation)
│   ├── domain/            # Business logic layer
│   │   ├── models/        # Domain models
│   │   ├── repositories/  # Repository interfaces
│   │   └── use_case/      # Use cases
│   ├── di/                # Dependency injection
│   └── presentation/      # UI layer
│       ├── home/          # Home screen
│       ├── profile/       # Profile screen
│       ├── create_post/   # Create post screen
│       ├── post_info/     # Post details screen
│       ├── wishlist/      # Wishlist screen
│       └── ui/            # Shared UI components
├── l10n/                  # Localization files
└── main.dart              # App entry point
```

## 🌐 Localization

The app supports English and Arabic. Localization files are located in `lib/l10n/`:
- `app_en.arb` - English translations
- `app_ar.arb` - Arabic translations

To add new translations:
1. Add entries to both `.arb` files
2. Run `flutter gen-l10n` to regenerate localization files

## 🔐 Security Notes

- Firebase API keys in the codebase are client-side keys and are safe to include
- Ensure Firebase Security Rules are properly configured in Firebase Console
- Never commit sensitive credentials like service account keys or admin SDK keys

## 📝 Environment Setup

The app uses Firebase for backend services. Make sure you have:
- Firebase project configured
- Firestore database set up with proper security rules
- Firebase Storage configured
- Firebase Authentication enabled (Email/Password)

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is private and proprietary.

## 📧 Contact

For support or inquiries, contact us at: raqami2026@outlook.com

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- All contributors and users of Raqami

---

**Version**: 1.0.0  
**Last Updated**: January 2026
