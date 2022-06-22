# Tool

Back to [Readme](README.md).

## Firebase

SDK setup and configuration

Add SHA certificate fingerprints accordingly and re-download `google-services.json` for Firebase service like signin, storage etc.

### Sha-1

- [x] debug
- [x] release
- [ ] profile

### Sha-256

- [x] debug
- [x] release
- [x] profile

...

## Path: JAVA_HOME

...Windows: `JAVA_HOME` is not set and no `java` command could be found in your PATH.

```sh
# Powershell
setx JAVA_HOME "$env:ProgramFiles\Android\Android Studio\jre"
# Command Prompt
setx JAVA_HOME "%ProgramFiles%\Android\Android Studio\jre"
```

## Path: keytool

...Windows

keytool and other

- keytool is not recognized
- Keystore file does not exist: `%UserProfile%`/.android/debug.keystore

```sh
# Powershell
setx PATH "$env:Path;$env:ProgramFiles\Android\Android Studio\jre\bin\"
# Command Prompt
setx PATH "%Path%;%ProgramFiles%\Android\Android Studio\jre\bin\"
```

## Path: flutter

...Windows

```sh
# Powershell
setx PATH "$env:Path;$env:UserProfile\.dev\flutter\bin"
# setx PATH "$env:Path;$env:OneDrive\env\bin"
# Command Prompt
setx PATH "%Path%;%UserProfile%\.dev\flutter\bin"
# setx PATH "%Path%;%OneDrive%\env\bin"
```

## Path: command-line

```sh
# setx /M path "%path%;C:\your\path\here\"
# PATH %PATH%;C:\xampp\php
```

## gradlew

```sh
cd android
./gradlew signingReport
./gradlew installDebug
```

## keytool

The certificate uses the SHA1withRSA signature algorithm which is considered a security risk. This algorithm will be disabled in a future update.

## keytool: generate

```sh
keytool -genkey -v -keystore "%UserProfile%/.android/debug.keystore" -alias androiddebugkey -keyalg RSA -sigalg SHA256withRSA -keysize 2048 -validity 10000
```

## keytool: list

```sh
# Powershell
keytool -list -alias androiddebugkey -keystore "$env:UserProfile/.android/debug.keystore"
keytool -list -v -alias lethil -keystore "$env:OneDrive/env/dev/laisiangtho/keystore.jks"
# Command Prompt
keytool -list -alias androiddebugkey -keystore "%UserProfile%/.android/debug.keystore"
keytool -list -v -alias lethil -keystore "%OneDrive%/env/dev/laisiangtho/keystore.jks"
```

## keytool: App signing key certificate

Git Bash

```sh
# get Base64 from sha1
echo 25:B5:97:94:C0:84:90:50:AF:00:8F:3F:87:FC:44:B5:81:83:A4:B6 | xxd -r -p | openssl base64
# get Base64 from androiddebugkey file
keytool -exportcert -alias androiddebugkey -keystore  ~/.android/debug.keystore | openssl sha1 -binary | openssl base64
```

## keytool: export

```sh
# Powershell
keytool -exportcert -v -alias androiddebugkey -keystore "$env:UserProfile/.android/debug.keystore"
keytool -exportcert -v -alias lethil -keystore "$env:OneDrive/env/dev/laisiangtho/keystore.jks"
# Command Prompt
keytool -exportcert -v -alias androiddebugkey -keystore "%UserProfile%/.android/debug.keystore"
keytool -exportcert -v -alias lethil -keystore "%OneDrive%/env/dev/laisiangtho/keystore.jks"
```

## git

```sh
git commit -m "Update docs to wiki"
git push origin master

git add .
git commit -a -m "commit" (do not need commit message either)
git push
