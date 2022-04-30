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

  - Debug
    - Runner: Generated
      - Runner: Pods-Runner.debug
  - Release
    - Runner: Generated
      - Runner: Pods-Runner.Release
  - Profile
    - Runner: Generated
      - Runner: Pods-Runner.Profile

- Runner->Project->Localizations

Add English, Burmese and Norwegian

- Clean & Build

```sh
flutter clean && flutter pub get
rm ios/Podfile.lock && pod install
# rm ios/Podfile && install pod
cd .. && flutter build ios
```

## Updating gem and installing xcode clt

```sh
# install Xcode Command Line Tools
xcode-select --install
sudo xcodebuild -license accept
# curl -L https://get.rvm.io | bash -s stable
unset GEM_HOME ; \curl -sSL https://get.rvm.io | bash -s stable

rvm install ruby-2.6

# install without generating the documentation for each gem (faster):
gem install <gemname> --no-document
gem list
gem outdated
gem update <gemname>

sudo gem install cocoapods
pod install 

# update gem
sudo gem update --system
# sudo gem install activesupport -v 4.2.6

# sudo gem install cocoapods
# gem install cocoapods --user-install
# sudo gem install -n /usr/local/bin cocoapods
```

## Installing Cocoapods

add in `nano ~/.zshrc`

```sh
export PATH="$PATH:$HOME/sdk/flutter/bin"
# export GEM_HOME=$HOME/.gem
# export PATH=$GEM_HOME/bin:$PATH
```

then

```sh
# update
source $HOME/.zshrc

# install cocoapods
gem install cocoapods --user-install
gem which cocoapods
```

[more on](https://guides.cocoapods.org/using/getting-started.html#sudo-less-installation)

## ???

```sh
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

## Screen size

... `6.5"` (3 App Previous, 10 Screenshots) [1242x2688]

- [x] iPhone XS Max
- [ ] iPhone 12 Pro Max
- [ ] iPhone 11 Pro Max

... `5.5"` (3 App Previous, 10 Screenshots) [1242x2208]

- [x] iPhone 8 Plus Size
- [ ] iPhone 7 Plus Size
- [ ] iPhone 6s Plus
- [ ] iPhone 6 Plus
- [ ] iPhone 12 mini

... `12.9"` (3 App Previous, 10 Screenshots) [2048x2732]

- [ ] iPad Pro (5th gen)
- [x] iPad Pro (4th gen)
- [ ] iPad Pro (3rd gen)
- [ ] iPad Pro (2nd gen)
- [ ] iPad Pro (1st gen)
