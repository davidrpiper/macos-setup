#!/bin/sh
################################################################################
# David's macOS Fresh Install Script                                           #
#                                                                              #
# Usage: ./macos-setup.sh <apple_id>                                           #
#                                                                              #
# This script first checks that the provided Apple ID is currently signed in.  #
################################################################################
set -e

dprint() {
	echo "[david] $1"
}

############################################################
# Apple Account / iCloud Login Check                       #
############################################################

if [ "$#" -eq 1 ]; then
	if defaults read MobileMeAccounts Accounts | grep -q $1; then
		dprint "Logged in Apple Account: $1"
	else
		dprint "Provided Apple Account ($1) is not logged in. Exiting."
		exit 2
	fi
else
	dprint "Please provide an Apple ID"
	dprint "Usage: macos-setup.sh <apple_id>"
	exit 1
fi

############################################################
# Basic CLI Tools                                          #
############################################################

dprint "Xcode Command Line Tools"
xcode-select --install

dprint "Homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Homebrew post-setup
echo 'eval $(/opt/homebrew/bin/brew shellenv)' >> /Users/$USER/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

brew update

############################################################
# General CLI Tools                                        #
############################################################

dprint "General CLI Tools"
brew install coreutils
brew install git
brew install rsync
brew install syncthing
brew install wget
brew install ffmpeg
brew install yt-dlp

dprint "Node + nvm"
brew install node nvm

dprint "Python + pyenv"
brew install python pyenv

############################################################
# Software CLI Tools                                       #
############################################################

dprint "Software CLI Tools"
brew install rg
brew install jq
brew install cmake

dprint "Claude Code"
npm install -g @anthropic-ai/claude-code

############################################################
# Basic Applications                                       #
############################################################

dprint "(Brew Cask) Basic Applications..."

brew install --cask anki
brew install --cask discord
brew install --cask firefox
brew install --cask gimp
brew install --cask paragon-ntfs
brew install --cask obsidian
brew install --cask vlc
brew install --cask zoom

############################################################
# Musical Applications                                     #
############################################################

dprint "(Brew Cask) Musical Applications..."

brew install --cask ableton-live-suite
brew install --cask audacity
brew install --cask ik-product-manager
brew install --cask focusrite-control-2
brew install --cask musescore
brew install --cask native-access
brew install --cask vcv-rack

############################################################
# Code & Writing Applications                              #
############################################################

dprint "(Brew Cask) Coding and Writing Applications..."

brew install --cask clion
brew install --cask inky
brew install --cask mactex
brew install --cask sublime-text
brew install --cask visual-studio-code

############################################################
# Video Applications                                       #
############################################################

dprint "(Brew Cask) Video Applications..."

brew install --cask obs

############################################################
# Mac App Store                                            #
############################################################

dprint "Mac App Store Apps..."

dprint "Installing mas"
brew install mas

dprint "The Unarchiver..."
mas install 425424353

dprint "Pages, Numbers, Keynote..."
mas install 409201541
mas install 409203825
mas install 409183694

dprint "Scrivener..."
mas install 1310686187

dprint "Logic Pro..."
mas install 634148309

dprint "Final Cut Pro..."
mas install 424389933

dprint "And of course, Xcode..."
mas install 497799835

dprint "Uninstalling mas"
brew uninstall mas

############################################################
# Personalised Config                                      #
############################################################

dprint "Home directory folders..."
mkdir -p ~/blog
mkdir -p ~/src
mkdir -p ~/mus
mkdir -p ~/wri
mkdir -p ~/vid
mkdir -p ~/tmp

dprint "Catppuccin-Latte Terminal theme (requires manual post-install in Terminal settings)"
curl -o ~/Downloads/Catppuccin-Latte.terminal https://raw.githubusercontent.com/davidrpiper/Terminal.app/main/themes/catppuccin-latte.terminal

dprint "Oh-My-Zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

dprint "Aliases for .zprofile"
cat <<EOF >> ~/.zprofile

# Aliases
alias la="ls -lAh"
alias sub="open -a Sublime\ Text"
alias yt="yt-dlp -S res,vcodec:h264,acodec:m4a"
alias yt1080="yt-dlp -S res,vcodec:h264,res:1080,acodec:m4a"
alias yt720="yt-dlp -S res,vcodec:h264,res:720,acodec:m4a"
EOF

############################################################
# Some Sensible Defaults                                   #
############################################################

dprint "Setting defaults..."

dprint "Expand save panels by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

dprint "Expand print panels by default"
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

dprint "Save to disk (not iCloud) by default"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

dprint "Save screenshots as PNGs to a custom folder, and disable shadows"
mkdir -p ~/Screenshots
defaults write com.apple.screencapture location -string "${HOME}/Screenshots"
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture disable-shadow -bool true

dprint "Disable .DS_Store files on network and USB volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

############################################################
# Manual Setup Remaining                                   #
############################################################

dprint "🚶🏻‍♂️ A few remaining manual steps are still needed..."
dprint "> 1. Install Sony Digital Paper App: https://www.sony.com/electronics/support/articles/S1F1667"
dprint "> 2. Install products / plugins from Musical Tools:"
dprint ">      - FabFilter (get from backup)"
dprint ">      - Native Access"
dprint ">      - IK Product Manager"
dprint "> 3. Install Vulkan SDK: https://vulkan.lunarg.com/sdk/home"
dprint "> 4. Build whisper.cpp manually: https://github.com/ggml-org/whisper.cpp"
dprint "> 5. Install uBlock Origin in Firefox"

############################################################
# Complete!                                                #
############################################################

dprint "🏖️  MacOS Post-Install complete!"
