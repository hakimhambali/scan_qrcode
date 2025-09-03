# R8 Code Shrinking and Obfuscation Setup

This document explains the R8/ProGuard configuration for the QR Code Scanner app.

## What was configured:

### 1. Build Configuration (`android/app/build.gradle.kts`)
```kotlin
buildTypes {
    release {
        isMinifyEnabled = true          // Enable R8 code shrinking
        isShrinkResources = true        // Enable resource shrinking
        proguardFiles(
            getDefaultProguardFile("proguard-android-optimize.txt"),
            "proguard-rules.pro"
        )
        signingConfig = signingConfigs.getByName("release")
    }
}
```

### 2. ProGuard Rules (`android/app/proguard-rules.pro`)
Comprehensive rules covering:
- Flutter framework
- Firebase Auth & Firestore
- Mobile Scanner (QR code scanning)
- Camera and Image Picker
- URL Launcher
- Shared Preferences
- Theme Provider dependencies

## Benefits:

1. **Reduced App Size**: R8 removes unused code and resources
2. **Code Obfuscation**: Makes reverse engineering more difficult
3. **Better Play Store Analysis**: Deobfuscation files help debug crashes
4. **Performance**: Optimized bytecode for better runtime performance

## Building Release APK:

```bash
# For production flavor
flutter build apk --release --flavor prod

# For dev flavor  
flutter build apk --release --flavor dev

# For App Bundle (recommended for Play Store)
flutter build appbundle --release --flavor prod
```

## Deobfuscation Files:

After building, mapping files will be generated at:
- `build/app/outputs/mapping/prodRelease/mapping.txt`
- `build/app/outputs/mapping/devRelease/mapping.txt`

Upload these to Google Play Console for crash analysis.

## Testing:

1. Build release APK/AAB with R8 enabled
2. Test all app functionality thoroughly
3. Verify Firebase Auth and Firestore work correctly
4. Test QR code scanning functionality
5. Check theme switching and persistent storage

## Troubleshooting:

If you encounter issues after enabling R8:

1. Check the ProGuard rules in `proguard-rules.pro`
2. Add specific keep rules for problematic classes
3. Use `flutter build apk --release --verbose` for detailed logs
4. Test on different devices and Android versions

## Important Notes:

- Always test release builds thoroughly before deploying
- Keep mapping files safe for crash analysis
- Monitor app size reduction in Play Console
- Update ProGuard rules when adding new dependencies