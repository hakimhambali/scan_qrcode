# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter QR code scanning application that allows users to scan QR codes using their camera or by selecting images from gallery. The app integrates with Firebase for user authentication and data storage.

## Common Commands

### Development
- `flutter run` - Run the app in development mode
- `flutter build apk` - Build APK for Android
- `flutter build ios` - Build for iOS
- `flutter clean` - Clean build artifacts
- `flutter pub get` - Install dependencies
- `flutter analyze` - Run static analysis
- `flutter test` - Run tests

### Package Management
- `flutter pub upgrade` - Upgrade all dependencies
- `flutter pub outdated` - Check for outdated dependencies

## Architecture & Key Components

### App Structure
- **Navigation Wrapper**: Central navigation controller (`lib/navigation_wrapper.dart`)
- **Splash Screen**: App entry point with splash animation (`lib/main.dart`)
- **QR Scanner**: Core scanning functionality with camera controls and overlay (`lib/screens/scan_qr.dart`)
- **History**: Displays scan history with Firebase integration (`lib/screens/history_screen.dart`)
- **Results**: Shows scanned QR code results (`lib/screens/result_scan_qr.dart`)

### Key Dependencies
- `mobile_scanner: ^7.0.1` - QR/barcode scanning
- `firebase_auth: ^6.0.1` - Authentication (supports anonymous and registered users)
- `cloud_firestore: ^6.0.0` - Data storage for scan history
- `google_nav_bar: ^5.0.6` - Bottom navigation UI
- `panara_dialogs: ^0.1.2` - Custom dialog components
- `image_picker: ^1.1.2` - Gallery image selection

### Firebase Integration
- Anonymous authentication is enabled by default
- Scan history is stored in Firestore under 'history' collection
- Users can optionally register to persist data across devices
- Each scan history entry includes: docID, link, date, userID, isFavorite
- **Data Merging**: When users transition from anonymous to permanent accounts, their history data is automatically merged
- **Account Cleanup**: Anonymous data is cleaned up after successful authentication transitions

### Scanning Features
- **Camera scanning**: Real-time QR code detection with torch and camera switching
- **Gallery scanning**: Select and analyze QR codes from device photos
- **Scanner overlay**: Custom overlay with clear center and semi-transparent edges
- **Top controls**: Camera controls (torch, switch, gallery) positioned at the top below notch
- **History persistence**: All scans are automatically saved to Firebase
- **Result handling**: Scanned codes are displayed with sharing options
- **Favorites system**: Users can mark history items as favorites with enhanced tap area
- **Empty states**: User-friendly messages when no history or favorites exist

## File Organization

```
lib/
├── main.dart              # App entry point with splash screen
├── navigation_wrapper.dart # Central navigation controller with bottom nav bar
├── screens/              # All UI screens
│   ├── scan_qr.dart      # QR scanning screen with camera overlay and top controls
│   ├── history_screen.dart # Scan history display with favorites and empty states
│   ├── result_scan_qr.dart # QR scan results
│   ├── login.dart        # User login with data merging support
│   ├── register.dart     # User registration with improved error handling
│   ├── signingoogle.dart # Google authentication with data merging
│   └── blank_screen.dart # Utility screen
├── services/             # Business logic services
│   └── data_merger.dart  # Handles anonymous to permanent account data transitions
├── model/
│   └── user.dart         # User and history data models
├── provider/
│   └── theme_provider.dart # Theme management with light/dark mode support
├── blocs/
│   └── theme.dart        # Theme bloc (currently unused)
└── configs/
    └── configs.dart      # App configurations
```

## Development Notes

### Firebase Setup
- Firebase is initialized in main() before running the app
- Anonymous authentication happens automatically on first launch
- Firestore security rules should allow read/write for authenticated users

### Authentication & Data Management
- **DataMerger Service**: Handles seamless data transitions between anonymous and permanent accounts
- **Error Handling**: User-friendly error messages replace technical Firebase errors
- **Account Lifecycle**: Anonymous accounts are cleaned up after successful permanent authentication
- **Data Preservation**: All anonymous history is merged to permanent accounts during sign-in

### Scanner Implementation
- Uses `MobileScannerController` for camera operations
- Implements custom overlay for scanner UI (`ScannerOverlay` class) with clear center and dark edges
- Camera controls positioned at top with rounded pill container below device notch
- Handles both real-time scanning and image analysis
- Proper camera lifecycle management (start/stop/dispose)
- Prevents duplicate scans with `isProcessing` flag

### Navigation Architecture
- Central `NavigationWrapper` manages bottom navigation bar
- Two main tabs: Scan QR (index 0) and History (index 1)
- Direct navigation between screens without redundant code
- App starts directly with NavigationWrapper (Scan QR tab active by default)

### Theme System
- **Dark Mode Support**: Complete light/dark theme implementation using Provider pattern
- **Theme Toggle**: Accessible via moon/sun icon in History screen header
- **Persistent Storage**: Theme preference saved to SharedPreferences
- **Theme-Aware Components**: All screens adapt colors, gradients, and styling based on current theme
- **Consistent Styling**: Proper contrast, readable text, and professional appearance in both modes

### State Management
- Uses basic Flutter `setState` for local state management
- **Provider Pattern**: Active theme management with `ThemeProvider` and `ChangeNotifier`
- Firebase streams for real-time history updates