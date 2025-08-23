plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.codexcess.qrcodescanner"
    compileSdk = 35
    ndkVersion = "27.3.13750724"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.codexcess.qrcodescanner"
        minSdk = 23
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    flavorDimensions += "default"

    productFlavors {
        create("prod") {
            dimension = "default"
            resValue("string", "QRCodeScanner", "Flavors Example")
            applicationIdSuffix = ""
        }
        create("dev") {
            dimension = "default"
            resValue("string", "QRCodeScanner", "Dev Flavors Example")
            applicationIdSuffix = ".dev"
        }
    }
}

flutter {
    source = "../.."
}
