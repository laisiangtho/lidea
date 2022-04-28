# Patcher

- macOS Catalina(v10.15.7)
- MacBook Pro (Retina, Mid 2012)
- Processor: 2,7 GHz Quad-Core Intel Core i7
- Memory: 16 GB 1600 MHz DDR3
- Startup Disk MacOS
- Graphics Interl DH Graphics 4000 1536 MB
- Serial C02J80GJDKQ5 (283)

[Installer][installer], [Patcher][patcher]

## Disk Utility (Format and Erase)

- Format: Mac OS Extended (Journaled)
- Scheme: GUID Partition Map

## Install Media

```sh
# Show Package Contents(Install macOS Big Sur)
# Contents -> Recources -> createinstallmedia
$ sudo [createinstallmedia-binary-path] --volume [USB-Path]
```

## Adjust Patcher settings

- Enable Verbose Mode: true
- Set ShowPicker Mode: true
- Set SIP and SecureBootModel: true

## Build OpenCore

- set bool files to temporary location

## Install OpenCore

- select the USB disk
- then select the partition, probably there is only one partition!

## Reboot

Hold down -> `Option Key` To show all available startup disk

- EFI Boot
- Install macOS Big Sur
- Internal Hard-drive (Mac OS)

## Install Boot loader

enable only Set SIP and SecureBootModel

### Patcher settings

- Hide OpenCore Picker: true
- Disable AMFI

Then install on internal hard, and then Rebuild

### Patcher install

Install OpenCore to USB/internal drive

- select the internal drive

Pentalobe screw sizes include TS1 (0.8 mm, used on every iPhone starting with the iPhone 4), TS4 (1.2 mm, used on the MacBook Air and the MacBook Pro with Retina display), and TS5 (1.5 mm, used on the 2009 MacBook Pro battery).

Erase (Format: APFS)

## Log

- create install media: 16:58 - 17:17
- reboot: 17:25

[installer]: https://mrmacintosh.com/macos-big-sur-full-installer-database-download-directly-from-apple/ "installer"
[patcher]: https://dortania.github.io/OpenCore-Legacy-Patcher/WINDOWS.html#creating-the-installer "patcher"
