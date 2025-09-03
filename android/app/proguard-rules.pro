# Flutter ProGuard Rules
# =====================

# Keep Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }

# Keep dart:ffi exports
-keep @androidx.annotation.Keep class * { *; }

# Firebase Rules
# ==============

# Keep Firebase classes
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Firebase Auth
-keep class com.google.firebase.auth.** { *; }
-dontwarn com.google.firebase.auth.**

# Firestore
-keep class com.google.firebase.firestore.** { *; }
-dontwarn com.google.firebase.firestore.**

# Firebase Core
-keep class com.google.firebase.FirebaseApp { *; }
-keep class com.google.firebase.FirebaseOptions { *; }

# Keep Firebase annotations
-keepattributes *Annotation*

# Firebase crashlytics (if you add it later)
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception

# Mobile Scanner (QR Code Scanner)
# ===============================
-keep class com.google.mlkit.** { *; }
-keep class com.google.android.gms.vision.** { *; }
-dontwarn com.google.mlkit.**
-dontwarn com.google.android.gms.vision.**

# Camera and Image Picker
# =======================
-keep class androidx.camera.** { *; }
-dontwarn androidx.camera.**

# URL Launcher
# ============
-keep class io.flutter.plugins.urllauncher.** { *; }

# Shared Preferences (Theme Provider)
# ==================================
-keep class io.flutter.plugins.sharedpreferences.** { *; }

# General Android Rules
# ====================

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep enum classes
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep Parcelable classes
-keep class * implements android.os.Parcelable {
  public static final android.os.Parcelable$Creator *;
}

# Keep Serializable classes
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Keep generic signatures
-keepattributes Signature

# Keep source file and line numbers for debugging
-keepattributes SourceFile,LineNumberTable

# Remove debug logs in release builds
-assumenosideeffects class android.util.Log {
    public static boolean isLoggable(java.lang.String, int);
    public static int v(...);
    public static int i(...);
    public static int w(...);
    public static int d(...);
    public static int e(...);
}

# Remove Flutter debug logs
-assumenosideeffects class io.flutter.Log {
    public static void v(...);
    public static void d(...);
    public static void i(...);
    public static void w(...);
    public static void e(...);
}

# Optimization settings
# ====================

# Enable aggressive optimizations
-optimizations !code/simplification/arithmetic,!field/*,!class/merging/*,!code/allocation/variable

# Allow code shrinking
-dontshrink

# Remove unused code
-dontpreverify

# Provider (for theme management)
# ==============================
-keep class androidx.lifecycle.** { *; }
-keep class * extends androidx.lifecycle.ViewModel { *; }

# Intl (for date formatting)
# ==========================
-keep class com.ibm.icu.** { *; }
-dontwarn com.ibm.icu.**

# Additional safety rules
# ======================

# Keep all constructors
-keepclassmembers class * {
    public <init>(...);
}

# Keep all classes with @Keep annotation
-keep @androidx.annotation.Keep class *
-keepclassmembers class * {
    @androidx.annotation.Keep *;
}

# Keep Flutter platform channels
-keep class * implements io.flutter.plugin.common.** { *; }

# Google Play Services (required by Firebase)
# ==========================================
-keep class com.google.android.gms.common.** { *; }
-keep class com.google.android.gms.tasks.** { *; }
-dontwarn com.google.android.gms.**

# Keep crash reporting information
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception

# Flutter Build Configuration
# ===========================
-keep class io.flutter.plugins.GeneratedPluginRegistrant { *; }
-keep class * extends io.flutter.embedding.engine.plugins.FlutterPlugin { *; }