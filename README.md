# macOS on Dell XPS 9570

This repository contains a sample configuration to run macOS (Currently Mojave `10.14`) on a Dell XPS 9570

## Used Hardware Configuration

- Dell XPS 9570
  - Intel i9-8950HK
  - 32GB RAM
  - Display?
  - Toshiba SSD?
  - H/W components TBD...

- Firmware Revisions
  - BIOS version `1.5.0`

- External Devices
  - TBD

- Monitors
  - TBD

## Preparation

WIP.

## UEFI Variables

The XPS 9570 BIOS defaults to 64MB DVMT pre-alloc, which is sufficient for Intel UHD 630 Graphics acceleration and a 4K display. No changes need to be made to the BIOS currently (this may change as other pieces are implemented).

## Clover Configuration

All Clover hotpatches are included in source DSL format in the DSDT folder.

## Display Profiles

WIP.

## CPU Profile

WIP.

## Undervolting

WIP.

## Credits

- [XPS9360-macOS repo by the-darkvoid](https://github.com/the-darkvoid/XPS9360-macOS)
- Many others to be listed...
