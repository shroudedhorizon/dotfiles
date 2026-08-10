
<div align="center">
<img width="20%" src="./assets/catgorl.jpg">
</div>

<div align="center">
  <p></p>
  <p><b><i> ~ Personal Dotfiles ~ </i></b></p>
  <img src="https://img.shields.io/badge/macOS-000000?logo=apple&logoColor=F0F0F0">
  <img src="https://custom-icon-badges.demolab.com/badge/Windows-0078D6?logo=windows11&logoColor=white">
  <img src="https://img.shields.io/badge/Linux%20Mint-87CF3E?logo=linuxmint&logoColor=fff">
  <img src="https://img.shields.io/badge/Pop!__OS-48B9C7?logo=popos&logoColor=fff">
  <img src="https://img.shields.io/badge/Fedora-51A2DA?logo=fedora&logoColor=fff">
</div>


| ![1](./assets/s1.jpg) | ![2](./assets/s2.jpg) |
| --- | --- |

## ***Tools***

- **Terminal**: Ghostty / Terminator
- **Editor**: NeoVim
- **Browser**: Brave
- **Shell**: Zsh
- **App Laucher**: Spotlight / Rofi
- **Font**: JetBrainsMonoNFM

## ***Installation from CLI Script***
These steps are recommended for work computers, containers, and other potentially ephemeral systems.
1. Run this command below
`curl -s https://raw.githubusercontent.com/shroudedhorizon/dotfiles/refs/heads/main/configure_system.sh | sh`

Follow the system prompts on screen.

## ***Installation with Git***
These steps are recommended if you want to make changes to these dotfiles yourself and commit them. For personal computers.
1. Clone this directory to your home directory.
2. Run the makefile command to symbolically link all of the configurations to this repository and install dependencies.
### Usage

```bash
cd ~

cd dotfiles/

make all
```

## ***Windows Installation***
See this [README.md](../windows/README.md).
