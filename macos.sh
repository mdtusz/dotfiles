#!/usr/bin/env bash

source ./lib.sh

# Start, and maintain sudo
running "Setting up macOS. Enter your password."
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

read -rp "Machine name: " MACHINE_NAME

running "Setting computer name."
sudo scutil --set ComputerName $MACHINE_NAME
sudo scutil --set HostName $MACHINE_NAME
sudo scutil --set LocalHostName $MACHINE_NAME
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server\
  NetBIOSName -string $MACHINE_NAME
ok "Computer name set to $MACHINE_NAME."

running "Applying system changes."
action "Killing iTunes with fire."
launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null
sudo rm -rf /Applications/iTunes.app

action "Cleaning the dock."
defaults write com.apple.dock persistent-apps -array ""
defaults write com.apple.dock no-class -bool true

action "Disabling launchpad."
defaults write com.apple.dock showLaunchpadGestureEnabled -int 0A

action "Making startup silent."
sudo nvram SystemAudioVolume=" "

action "Disabling menu bar transparency."
defaults write NSGlobalDomain AppleEnableMenuBarTransparency -bool false

action "Setting sidebar icon size to small."
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 1

action "Setting scrollbar display while scrolling."
defaults write NSGlobalDomain AppleShowScrollBars -string "WhenScrolling"

action "Increasing window resize speed for Cocoa Apps."
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

action "Setting expanded save panel as default."
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

action "Setting smart print defaults."
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

action "Setting daily check for software updates."
defaults.write com.apple.SoftwareUpdate ScheduleFrequency -int 1

action "Setting smart defaults for trackpad and scrolling."
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehaviour -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehaviour -int 1
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool ture
defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144
defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true

action "Setting a useful key repeat rate."
defaults write NSGlobalDomain KeyRepeat -int 0.02
defaults write NSGlobalDomain InitialKeyRepeat -int 12

action "Setting security preferences."
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

action "Setting sensible Finder preferences."
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathBar -bool true
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write NSGlobalDomain com.apple.springing.enabled -bool true
defaults write NSGlobalDomain com.apple.springing.delay -float 0
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
defaults write com.apple.finder EmptyTrashSecurely -bool true

action "Making `~/Library` visible."
chflags nohidden ~/Library

action "Setting Dock preferences."
defaults write com.apple.dock mineffect -string "scale"
defaults write com.apple.dock minimize-to-application -bool true
defaults write com.apple.dock show-process-indicators -bool true
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true
defaults write com.apple.dock launchanim -bool false
defaults write com.apple.dock expose-animation-duration -float 0.1
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock showhidden -bool true
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dashboard mcx-disabled -bool true

for app in "cfprefsd" "Dock" "Finder" "SystemUIServer"; do
  killall $app
done

ok "Successfully seup macOS. Log out and back in again to finalize changes."
