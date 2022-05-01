# Android

Back to [Readme](README.md).

## Build

... minSdkVersion=16

```sh
flutter build appbundle --release
# flutter build appbundle --target-platform android-arm,android-arm64
# flutter build apk --release --target-platform=android-arm
# flutter build appbundle --release --target-platform=android-arm
# flutter run --release --target-platform=android-arm
```

... minSdkVersion=21

```sh
# flutter build appbundle --release --target-platform=android-arm64
# flutter build apk --release --target-platform=android-arm64
# flutter run --target-platform=android-arm64
# flutter run --enable-software-rendering --target-platform=android-arm64
# flutter build appbundle --release --target-platform=android-arm64
# flutter build apk --split-per-abi --release
```

## Config

analytics (debug on windows)

```sh
# Powershell
cd $env:UserProfile/.dev/sdk/platform-tools
# Command Prompt
cd %UserProfile%/.dev/sdk/platform-tools

adb shell setprop debug.firebase.analytics.app "com.laisiangtho.bible"
```
