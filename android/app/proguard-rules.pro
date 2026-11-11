# Release builds shrink code. Firebase registrars are only named from the
# manifest, so R8 drops them and startup dies with
# "FirebaseCrashlytics component is not present."
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-keep class io.flutter.plugins.firebase.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**
