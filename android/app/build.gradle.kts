import java.util.Properties
import java.io.FileInputStream

val secretsPropertiesFile = rootProject.file("secrets.properties")
val secretsProperties = Properties()
if (secretsPropertiesFile.exists()) {
    secretsProperties.load(FileInputStream(secretsPropertiesFile))
}

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.waffiq.storyzz"
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.waffiq.storyzz"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        manifestPlaceholders["MAPS_API_KEY"] = secretsProperties.getProperty("MAPS_API_KEY", "")

        ndk {
            abiFilters += listOf("armeabi-v7a", "arm64-v8a", "x86_64")
        }
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
    buildFeatures {
        buildConfig = true
    }

    flavorDimensions += "tier"
    productFlavors {
        create("free") {
            dimension = "tier"
            applicationIdSuffix = ".free"
            resValue("string", "app_name", "Storyzz Free")
            buildConfigField("boolean", "IS_PAID_VERSION", "false")
        }
        create("paid") {
            dimension = "tier"
            applicationIdSuffix = ".paid"
            resValue("string", "app_name", "Storyzz Premium")
            buildConfigField("boolean", "IS_PAID_VERSION", "true")
        }
    }
}

flutter {
    source = "../.."
}

// add explicit task dependencies between the different flavor builds:
tasks.whenTaskAdded {
    if (name.contains("compile") && name.contains("Flutter")) {
        // Add dependencies between Flutter compilation tasks
        val taskName = name
        
        if (taskName.contains("Free")) {
            tasks.matching { it.name.contains("compile") && it.name.contains("Flutter") && it.name.contains("Paid") }
                .forEach { this.mustRunAfter(it) }
        }
        
        if (taskName.contains("Paid")) {
            tasks.matching { it.name.contains("compile") && it.name.contains("Flutter") && it.name.contains("Free") }
                .forEach { this.mustRunAfter(it) }
        }
    }
}