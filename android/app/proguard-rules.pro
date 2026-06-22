## Flutter specific rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

## Firebase
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

## Firebase Crashlytics
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception
-keep class com.google.firebase.crashlytics.** { *; }

## Firebase Messaging
-keep class com.google.firebase.messaging.** { *; }

## Firebase Auth
-keep class com.google.firebase.auth.** { *; }

## Google Sign-In
-keep class com.google.android.gms.auth.** { *; }
-keep class com.google.android.gms.common.** { *; }
-dontwarn com.google.android.gms.**

## Sign In with Apple
-keep class com.aboutyou.dart_packages.sign_in_with_apple.** { *; }

## Google Maps
-keep class com.google.android.gms.maps.** { *; }
-dontwarn com.google.android.gms.maps.**

## Flutter Google Maps Plugin (Pigeon-generated Messages & inner classes)
-keep class io.flutter.plugins.googlemaps.** { *; }
-keep class io.flutter.plugins.googlemaps.Messages$* { *; }
-dontwarn io.flutter.plugins.googlemaps.**

## Google Maps Android Heatmap Utils
-keep class com.google.maps.android.** { *; }

## In-App Purchase / Billing
-keep class com.android.vending.billing.** { *; }
-keep class com.google.android.gms.internal.** { *; }

## Play Core (deferred components / split install)
-dontwarn com.google.android.play.core.**
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.SplitInstallException
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest
-dontwarn com.google.android.play.core.splitinstall.SplitInstallSessionState
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task

## Dio / OkHttp / Network
-dontwarn okhttp3.**
-dontwarn okio.**
-keep class okhttp3.** { *; }
-keep class okio.** { *; }

## Gson (used by various plugins)
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn sun.misc.**
-keep class com.google.gson.** { *; }
-keep class * extends com.google.gson.TypeAdapter
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

## Flutter Local Notifications
-keep class com.dexterous.flutterlocalnotifications.** { *; }

## WebView
-keep class android.webkit.** { *; }
-keep class io.flutter.plugins.webviewflutter.** { *; }

## Permission Handler
-keep class com.baseflow.permissionhandler.** { *; }

## Image Picker
-keep class io.flutter.plugins.imagepicker.** { *; }

## File Picker
-keep class com.mr.flutter.plugin.filepicker.** { *; }

## Share Plus
-keep class dev.fluttercommunity.plus.share.** { *; }

## URL Launcher
-keep class io.flutter.plugins.urllauncher.** { *; }

## Geolocator / Location
-keep class com.baseflow.geolocator.** { *; }

## Device Info Plus
-keep class dev.fluttercommunity.plus.device_info.** { *; }

## Package Info Plus
-keep class dev.fluttercommunity.plus.packageinfo.** { *; }

## Path Provider (Pigeon-generated Messages & inner classes)
-keep class io.flutter.plugins.pathprovider.** { *; }
-keep class io.flutter.plugins.pathprovider.Messages$* { *; }

## Internet Connection Checker
-keep class io.flutter.plugins.connectivity.** { *; }

## AndroidX
-keep class androidx.** { *; }
-dontwarn androidx.**

## Kotlin
-keep class kotlin.** { *; }
-dontwarn kotlin.**
-keepclassmembers class **$WhenMappings { <fields>; }

## General rules
-keepattributes InnerClasses
-keepattributes EnclosingMethod
-dontwarn javax.annotation.**
