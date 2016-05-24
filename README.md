```
 .----------------.  .----------------.  .----------------.   .----------------.  .-----------------. .----------------. 
 | .--------------. || .--------------. || .--------------. | | .--------------. || .--------------. || .--------------. |
 | |  ________    | || |  _________   | || | ____   ____  | | | |  _________   | || | ____  _____  | || | ____   ____  | |
 | | |_   ___ `.  | || | |_   ___  |  | || ||_  _| |_  _| | | | | |_   ___  |  | || ||_   \|_   _| | || ||_  _| |_  _| | |
 | |   | |   `. \ | || |   | |_  \_|  | || |  \ \   / /   | | | |   | |_  \_|  | || |  |   \ | |   | || |  \ \   / /   | |
 | |   | |    | | | || |   |  _|  _   | || |   \ \ / /    | | | |   |  _|  _   | || |  | |\ \| |   | || |   \ \ / /    | |
 | |  _| |___.' / | || |  _| |___/ |  | || |    \ ' /     | | | |  _| |___/ |  | || | _| |_\   |_  | || |    \ ' /     | |
 | | |________.'  | || | |_________|  | || |     \_/      | | | | |_________|  | || ||_____|\____| | || |     \_/      | |
 | |              | || |              | || |              | | | |              | || |              | || |              | |
 | '--------------' || '--------------' || '--------------' | | '--------------' || '--------------' || '--------------' |
  '----------------'  '----------------'  '----------------'   '----------------'  '----------------'  '----------------' 
```

This is the skeleton for new developers. It provides a starting point for developers to customize their env.

## Dotfiles
* bashrc
Provides sane defaults for the bash shell.

* zshrc
Provides sane defaults for the zsh shell.

* bash_profile, profile
Ensures that .basrc is sourced.

* bash_aliases
Contains aliases for turning on and off proxy support as well as shortcuts for generating cookbooks.

* gitconfig
Sets https verify mode to false.

* vimrc
Provides sane defaults for vim and support for promptline, syntastic, and airline.

* promptline
A modified prompt that provides useful informaiton in a stylized way.

## Chef
This directory goes in your home directory and contains the validator.pem for the chef org we are using. It also has a stock knife.rb and contains directories for foodcritic, bootstrap, and the code_generator.

It is vital toi switch to master and git pull on these before doing anything else.

## Berkshelf
Sane config for berkshelf. Namely disabling https verification.

## ssh
Contains the Keys directory and a config that disables GSSAPI auth. (Reverse DNS)

## vim
Contains all the vim plugins needed to make this work.

## Fonts
Powerline fonts that give you access to the gliphs used in promptline.

# Usage
Clone this repository.

`git clone git@gitlab-server:gps-ocx-support/dev-env.git`

Run install.sh

`cd dev-env && ./install.sh`

Source your bashrc.

`source ~/.bashrc`
