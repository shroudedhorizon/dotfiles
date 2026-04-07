
<div align="center">
<img width="15%" src="./assets/catgorl.png">
</div>

<div align="center">
  <p></p>
  <p><b><i> ~ Minimalistic Dotfiles ~ </i></b></p>
  <img src="https://img.shields.io/github/last-commit/shroudedhorizon/dotfiles/main?color=%23c4a7e7&style=for-the-badge">
  <img src="https://img.shields.io/github/repo-size/shroudedhorizon/dotfiles?color=%23e0def4&style=for-the-badge">
  <img src="https://img.shields.io/github/license/shroudedhorizon/dotfiles?color=%239ccfd8&style=for-the-badge">
</div>


| ![1](./assets/s1.png) | ![2](./assets/s2.png) |
| --- | --- |

## ***Environment***

- **OS**: Mac OS 11 / Linux Mint / Fedora 41
- **Terminal**: iTerm 2 / Terminator
- **Editor**: NeoVim
- **Browser**: Firefox
- **Shell**: Zsh
- **App Laucher**: Finder / Rofi
- **Font**: JetBrainsMonoNFM

## ***Installation***
1. Clone this directory to your home directory.

2. Run the makefile command to symbolically link all of the configurations to this repository.

Dependencies are listed within the `dependencies/` directory.

### Example

```bash
cd ~

cd dotfiles/

make all
```

## ***Windows Installation***
For windows, things are a bit different. Copy the windows/ directory into any place you wish, and then run
```powershell
run.bat
```
This script will install all of the dependencies I use on windows.