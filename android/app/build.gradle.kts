plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.josport.app.josport"
    compileSdk = 36

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.josport.app.josport"
        minSdk = flutter.minSdkVersion
        targetSdk = 34
        versionCode = 1
        versionName = "1.0.0"

        // Enable multidex for Firebase
        multiDexEnabled = true
    }

    buildTypes {
        release {
            // Signing with the debug keys for now
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Firebase BoM (Bill of Materials) - ensures compatible versions
    implementation(platform("com.google.firebase:firebase-bom:33.7.0"))

    // Firebase Authentication
    implementation("com.google.firebase:firebase-auth-ktx")

    // Google Sign-In
    implementation("com.google.android.gms:play-services-auth:21.2.0")

    // MultiDex support
    implementation("androidx.multidex:multidex:2.0.1")
}