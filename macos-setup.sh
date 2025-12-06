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

dprint "General CLI Tools..."
brew install coreutils
brew install git
brew install rsync
brew install syncthing
brew install wget
brew install ffmpeg
brew install yt-dlp

dprint "Node..."
brew install node

dprint "Python..."
brew install python

############################################################
# Software CLI Tools                                       #
############################################################

dprint "Software CLI Tools"
brew install rg
brew install jq
brew install cmake

############################################################
# Basic Applications                                       #
############################################################

dprint "(Brew Cask) Basic Applications..."

brew install --cask discord
brew install --cask fastmail
brew install --cask firefox
brew install --cask paragon-ntfs
brew install --cask slack
brew install --cask vlc

############################################################
# Musical Applications                                     #
############################################################

dprint "(Brew Cask) Musical Applications..."

brew install --cask ableton-live-suite
brew install --cask audacity
brew install --cask audio-modeling-software-center
brew install --cask ik-product-manager
brew install --cask focusrite-control-2
brew install --cask musescore
brew install --cask native-access
brew install --cask vcv-rack

############################################################
# Code & Writing Applications                              #
############################################################

dprint "(Brew Cask) Coding, Writing and Reading Applications..."

brew install --cask calibre
brew install --cask clion
brew install --cask inky
brew install --cask sublime-text
brew install --cask visual-studio-code

############################################################
# Video and Games                                          #
############################################################

dprint "(Brew Cask) Games and Streaming Applications..."

brew install --cask steam
brew install --cask openemu
brew install --cask obs

############################################################
# Home Directory Folders are local, iCLoud is separate     #
############################################################

dprint "Symlink iCloud Drive..."
ln -s "$HOME/Library/Mobile Documents/com~apple~CloudDocs/David" "$HOME/David"
ln -s "$HOME/Library/Mobile Documents/com~apple~CloudDocs/David" "$HOME/Desktop/David"

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

dprint "Show Macintosh HD on Desktop"
defaults write com.apple.dock "show-recents" -bool "false" && killall Dock

dprint "TextEdit default to plain text"
defaults write com.apple.TextEdit "RichText" -bool "false" && killall TextEdit

dprint "Catppuccin-Latte Terminal theme (requires manual post-install in Terminal settings)"
curl -o ~/Downloads/Catppuccin-Latte.terminal https://raw.githubusercontent.com/davidrpiper/Terminal.app/main/themes/catppuccin-latte.terminal

############################################################
# Git config (don't specify username or email by default)  #
############################################################
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status

############################################################
# Zsh config (can't do Oh-My-Zsh as it quits the script)   #
############################################################
dprint "Aliases for .zprofile"
cat <<EOF >> ~/.zprofile

# Aliases
alias la="ls -lAh"
alias sub="open -a Sublime\ Text"
alias yt="yt-dlp -S res,vcodec:h264,acodec:m4a"
alias ytyt="yt-dlp -S res,vcodec:h264,acodec:m4a -o \"%(title)s.%(ext)s\" --embed-thumbnail"
alias yt1080="yt-dlp -S res,vcodec:h264,res:1080,acodec:m4a"
alias yt720="yt-dlp -S res,vcodec:h264,res:720,acodec:m4a"
EOF

############################################################
# Manual Setup Remaining                                   #
############################################################

dprint "🚶🏻‍♂️ A few remaining manual steps are needed, while the Mac App Store apps install:"
dprint "> 1. Install uBlock Origin and Multi-Account Containers in Firefox"
dprint "> 2. Set up the Catppuccin Latte theme for the Terminal (it's in Downloads), and IDEs"
dprint "> 3. Install Sony Digital Paper App: https://www.sony.com/electronics/support/articles/S1F1667"
dprint "> 4. Build and install whisper.cpp manually: https://github.com/ggml-org/whisper.cpp"
dprint "> 5. Install Vulkan SDK: https://vulkan.lunarg.com/sdk/home"
dprint "> 6. Install products / plugins from Musical Tools:"
dprint ">      - FabFilter (get from backup)"
dprint ">      - Native Access"
dprint ">      - IK Product Manager"
dprint ">      - UVI.net"
dprint ">      - Audio Modeling"
dprint ">      - Orchestra Tools SINEplayer for Berlin Orchestra"
dprint ">      - Continuata for Berlin Orchestra: https://continuata.com/download-app"
dprint "> 7. Set up a GitHub SSH Key and other auth stuff"
dprint "> ... And now we wait:"

############################################################
# Mac App Store                                            #
############################################################

dprint "Mac App Store Apps..."

dprint "Installing mas"
brew install mas

dprint "Monodraw..."
mas install 920404675

dprint "Scrivener..."
mas install 1310686187

dprint "Pixelmator Pro..."
mas install 1289583905

dprint "Pages, Numbers, Keynote..."
mas install 409201541
mas install 409203825
mas install 409183694

dprint "Logic Pro..."
mas install 634148309

dprint "Final Cut Pro..."
mas install 424389933

dprint "And of course, Xcode..."
mas install 497799835

dprint "Uninstalling mas"
brew uninstall mas

############################################################
# Complete!                                                #
############################################################

dprint "🏖️  MacOS Post-Install complete!"
