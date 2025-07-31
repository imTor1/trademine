plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.trademine"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.example.trademine"
        minSdk = 23 
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    // --- เริ่มการแก้ไข ---
    // เก็บ jvmToolchain(21) ไว้ เพื่อให้ Gradle ใช้ Java 21 ที่ติดตั้งในระบบในการรัน build
    kotlin {
        jvmToolchain(21) // คงค่านี้เป็น 21 ไว้ เพราะระบบของคุณมี Java 21
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17 // <<<<<<< เปลี่ยนกลับเป็น 17
        targetCompatibility = JavaVersion.VERSION_17 // <<<<<<< เปลี่ยนกลับเป็น 17
        isCoreLibraryDesugaringEnabled = true
    }

    // กำหนด JVM target ของ Kotlin อย่างชัดเจนใน kotlinOptions
    // นี่มักจะจำเป็นแม้จะใช้ jvmToolchain เมื่อเกิดปัญหา target ที่เฉพาะเจาะจง
    kotlinOptions {
        jvmTarget = "17" // <<<<<<< เพิ่มบล็อกนี้และตั้งค่าเป็น "17"
    }
    // --- สิ้นสุดการแก้ไข ---
}

dependencies {
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
      implementation ("com.google.android.gms:play-services-auth:20.7.0")

}

flutter {
    source = "../.."
}