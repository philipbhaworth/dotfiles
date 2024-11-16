#!/bin/bash

fonts_list=(
  font-fira-mono-nerd-font
  font-fira-code-nerd-font
  font-hack-nerd-font
  font-hasklug-nerd-font
  font-iosevka-nerd-font
  font-jetbrains-mono-nerd-font
  font-mononoki-nerd-font
  font-roboto-mono-nerd-font
  font-sauce-code-pro-nerd-font
  font-ubuntu-nerd-font

)

brew tap homebrew/cask-fonts

for font in "${fonts_list[@]}"
do
  brew install --cask "$font"
done
exit
