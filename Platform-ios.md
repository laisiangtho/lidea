# iOS

Back to [Readme](README.md).

## Build

...

## Config

As of firebase `platform :ios, '10.0'` need to set in *Podfile*.

`cd ios`

If `pod install` gives any error then try this
`pod install --repo-update`

- Runner->Project->Configurations

```sh
Debug
  Runner: Generated
    Runner: Pods-Runner.debug
Release
  Runner: Generated
    Runner: Pods-Runner.Release
Profile
  Runner: Generated
    Runner: Pods-Runner.Profile
```

- Runner->Project->Localizations

Add English, Burmese and Norwegian

```sh
flutter clean && flutter pub get
rm ios/Podfile && install pod
cd .. && flutter build ios
```

```bash
# flutter path
nano .bash_profile
export PATH="$PATH:/Users/Shared/Developer/flutter/bin"
export GEM_HOME=$HOME/.gem
export PATH=$GEM_HOME/bin:$PATH

nano .$HOME/.zshrc
export PATH="$PATH:/Users/Shared/Developer/flutter/bin"

# Update

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# rm '/usr/local/bin/pod'
brew reinstall cocoapods
brew link --overwrite cocoapods
# install pod

# sudo gem update --system
# sudo gem install cocoapods
# pod setup

cd ios
pod init
pod install
pod update
# if packages were not updated
rm Podfile.lock && pod install
```

## size

... 6.5in

- iPhone XS Max
- iPhone 12 Pro Max
- iPhone 11 Pro Max

... 5.5in

- iPhone 8 Plus Size
- iPhone 7 Plus Size
- iPhone 6s Plus
- iPhone 6 Plus
- iPhone 12 mini

... 12.9"

- iPad Pro (5th gen)
- iPad Pro (4th gen)
- iPad Pro (3rd gen)
- iPad Pro (2nd gen)
- iPad Pro (1st gen)
