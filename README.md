# lidea

Loading, reading and writing file logic with dart plus flutter theme scope

![alt text][license]

## Flutter

create, analyze, test, and run an app:

```sh
# create
flutter create app_name
cd app_name

# analyze
flutter analyze

# test
flutter test

# run
flutter run lib/main.dart

# package
flutter pub get
# check outdated
flutter pub outdated

# upgrade
flutter pub upgrade
# upgrade dependencies
flutter pub upgrade --major-version

# To view all commands that flutter supports
flutter --help --verbose

# See the current version of the Flutter SDK, framework, engine & tools
flutter --version

# build
flutter build appbundle --release
```

> Flutter SDK command line tools

```shell
flutter channel stable
flutter upgrade
flutter config --enable-web
cd into project directory
flutter create .
flutter run -d chrome

# Update dependencies
flutter pub upgrade
```

## Extension

... String

```dart
''.bracketsHack('0');
''.gitHack('0');
''.token('0');
```

## Android

- [Config](Platform-android.md#config)
- [Build](Platform-android.md#build)

## iOS

- [Config](Platform-ios.md#config)
- [Build](Platform-ios.md#build)

## Tools

- [Firebase](TOOL.md#firebase)
- Path
  - [JAVA_HOME](TOOL.md#path-java_home)
  - [keytool](TOOL.md#path-keytool)
  - [flutter](TOOL.md#path-flutter)
- [gradlew](TOOL.md#gradlew)

See [Path configuration](TOOL.md#path-keytool) and [keytool](TOOL.md#keytool) cli.

- [keytool](TOOL.md#keytool)
  - [Generate](TOOL.md#keytool-generate)
  - [List](TOOL.md#keytool-list)
  - [Export](TOOL.md#keytool-export)
- [git](TOOL.md#git)
  
## config(windows-android)

- Powershell: `$env:UserProfile`
- Command Prompt: `%UserProfile%`

```sh
# flutter config --android-studio-dir <android-studio-dir>
# flutter config --android-sdk <android-sdk-path>

# Powershell
flutter config --android-studio-dir="$env:ProgramFiles/Android/Android Studio"
# Command Prompt
flutter config --android-studio-dir="%ProgramFiles%/Android/Android Studio"

flutter config --android-sdk="$env:UserProfile/.dev/sdk"
flutter config --android-sdk="%UserProfile%/.dev/sdk"
flutter config --android-sdk="$ANDROID_SDK"
```

[license]: https://img.shields.io/badge/License-MIT-yellow.svg "License"
