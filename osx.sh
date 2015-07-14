# include my library helpers for colorized echo and require_brew, etc
source ./lib.sh

# Ask for computer name
bot "OSX Setup:"
read -r -p  "What do you want to name this machine? " machinename

# Ask for the administrator password upfront
bot "Enter your sudo password so I can install some things: "
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

bot "OK, let's start."

################################################################################
# install homebrew, cask, pip, and node/npm                                    #
################################################################################

running "checking homebrew install"
brew_bin=$(which brew) 2>&1 > /dev/null
if [[ $? != 0 ]]; then
  action "Installing homebrew."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    if [[ $? != 0 ]]; then
      error "unable to install homebrew, script $0 abort!"
      exit -1
  fi
fi
ok

running "checking brew-cask install"
output=$(brew tap | grep cask)
if [[ $? != 0 ]]; then
  action "installing brew-cask"
  require_brew caskroom/cask/brew-cask
fi
ok

running "checking pip install"
output=$(which pip) 2>&1 > /dev/null
if [[ $? != 0 ]]; then
  action "installing pip"
  sudo easy_install pip
  if [[ $? != 0 ]]; then
    error "unable to install pip"
  fi
fi
ok

running "checking npm install"
output=$(which npm) 2>&1 > /dev/null
if [[ $? != 0 ]]; then
  action "installing node and npm"
  require_brew node
fi
ok

bot "Installing vundle for vim."


###############################################################################
# Install command-line tools using Homebrew                                   #
###############################################################################
# Make sure we’re using the latest Homebrew
running "updating homebrew"
brew update
ok

running "upgrading homebrew packages"
brew upgrade
ok

# Tasty brews
bot "Installing homebrew command-line tools."
require_brew git
require_brew homebrew/dupes/grep
require_brew docker
require_brew docker-machine
require_brew vim --override-system-vi
require_brew httpie

bot "Installing homebrew language packages."
require_brew elm-platform
require_brew haskell-platform

###############################################################################
# Native Apps (via brew cask)                                                 #
###############################################################################
bot "Installing GUI tools via homebrew casks..."
brew tap caskroom/versions > /dev/null 2>&1

# cloud storage
require_cask dropbox

# communication
require_cask slack
require_cask limechat
require_cask skype

# tools
require_cask iterm2
require_cask sublime-text3
require_cask the-unarchiver
require_cask transmission
require_cask vlc
require_cask alfred
require_cask processing
require_cask bettertouchtool
require_cask calibre

# tunes
require_cask spotify

# browsers
require_cask firefox
require_cask google-chrome
require_cask google-chrome-canary

bot "Cleaning up homebrew cache..."
# Remove outdated versions from the cellar
brew cleanup > /dev/null 2>&1
bot "All clean"

###############################################################################
bot "Configuring General System UI/UX..."
###############################################################################


###############################################################################
# SSD-specific tweaks                                                         #
###############################################################################

running "disable local Time Machine snapshots"
sudo tmutil disablelocal;ok

################################################
# Optional / Experimental                      #
################################################

# running "Set computer name (as done via System Preferences → Sharing)"
sudo scutil --set ComputerName $machinename
sudo scutil --set HostName $machinename
sudo scutil --set LocalHostName $machinename
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $machinename

# running "Stop iTunes from responding to the keyboard media keys and delete it"
launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null;ok
sudo rm -rf /Applications/iTunes.app

# running "Enable the MacBook Air SuperDrive on any Mac"
# sudo nvram boot-args="mbasd=1";ok

# running "Remove Dropbox’s green checkmark icons in Finder"
file=/Applications/Dropbox.app/Contents/Resources/emblem-dropbox-uptodate.icns
[ -e "${file}" ] && mv -f "${file}" "${file}.bak";ok

# running "Wipe all (default) app icons from the Dock"
defaults write com.apple.dock persistent-apps -array "";ok

#running "Enable the 2D Dock"
defaults write com.apple.dock no-glass -bool true;ok

#running "Disable the Launchpad gesture (pinch with thumb and three fingers)"
defaults write com.apple.dock showLaunchpadGestureEnabled -int 0;ok

#running "Add a spacer to the left side of the Dock (where the applications are)"
#defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}';ok
#running "Add a spacer to the right side of the Dock (where the Trash is)"
#defaults write com.apple.dock persistent-others -array-add '{tile-data={}; tile-type="spacer-tile";}';ok

################################################
bot "Standard System Changes."
################################################
running "always boot in verbose mode (not OSX GUI mode)"
sudo nvram boot-args="-v";ok

# running "Set standby delay to 2 hours (default is 1 hour)"
# sudo pmset -a standbydelay 7200;ok

# running "Disable the sound effects on boot"
# sudo nvram SystemAudioVolume=" ";ok

running "menu bar: disable transparency"
defaults write NSGlobalDomain AppleEnableMenuBarTransparency -bool false;ok

# running "Set highlight color to green"
# defaults write NSGlobalDomain AppleHighlightColor -string "0.764700 0.976500 0.568600";ok

running "set sidebar icon size to small"
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 1;ok

running "show scrollbars when scrolling"
defaults write NSGlobalDomain AppleShowScrollBars -string "WhenScrolling";ok
# Possible values: `WhenScrolling`, `Automatic` and `Always`

running "increase window resize speed for Cocoa applications"
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001;ok

running "expand save panel by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true;ok

running "expand print panel by default"
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true;ok

running "save to disk (not to iCloud) by default"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false;ok

running "automatically quit printer app once the print jobs complete"
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true;ok

running "disable the “Are you sure you want to open this application?” dialog"
defaults write com.apple.LaunchServices LSQuarantine -bool false;ok

running "remove duplicates in the “Open With” menu (also see 'lscleanup' alias)"
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user;ok

running "display ASCII control characters using caret notation in standard text views"
# Try e.g. `cd /tmp; unidecode "\x{0000}" > cc.txt; open -e cc.txt`
defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true;ok

running "disable automatic termination of inactive apps"
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true;ok

running "disable the crash reporter"
defaults write com.apple.CrashReporter DialogType -string "none";ok

running "check for software updates daily, not just once per week"
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1;ok

running "disable Notification Center and remove the menu bar icon"
launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist > /dev/null 2>&1;ok

running "disable smart quotes as they’re annoying when typing code"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false;ok

running "disable smart dashes as they’re annoying when typing code"
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false;ok


###############################################################################
bot "Trackpad, mouse, keyboard, Bluetooth accessories, and input."
###############################################################################

running "trackpad: enable tap to click for this user and for the login screen"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1;ok

running "disable “natural” (Lion-style) scrolling"
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false;ok

running "increase sound quality for Bluetooth headphones/headsets"
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40;ok

running "enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)"
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3;ok

running "use scroll gesture with the Ctrl (^) modifier key to zoom"
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144;ok
running "follow the keyboard focus while zoomed in"
defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true;ok

running "disable press-and-hold for keys in favor of key repeat"
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false;ok

running "set a blazingly fast keyboard repeat rate"
defaults write NSGlobalDomain KeyRepeat -int 0;

running "set language and text formats (english/US)"
defaults write NSGlobalDomain AppleLanguages -array "en"
defaults write NSGlobalDomain AppleLocale -string "en_US@currency=CAD"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true;ok

running "disable auto-correct"
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false;ok

###############################################################################
bot "Configuring the Screen."
###############################################################################

running "require password immediately after sleep or screen saver begins"
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0;ok

running "save screenshots to better location"
defaults write com.apple.screencapture location ${HOME}/Pictures/Screenshots/;ok

running "save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)"
defaults write com.apple.screencapture type -string "png";ok

running "disable shadow in screenshots"
defaults write com.apple.screencapture disable-shadow -bool true;ok

running "enable subpixel font rendering on non-Apple LCDs"
defaults write NSGlobalDomain AppleFontSmoothing -int 2;ok

running "enable HiDPI display modes (requires restart)"
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true;ok

killall SystemUIServer

###############################################################################
bot "Finder configuration."
###############################################################################

running "set Home as the default location for new Finder windows"
# For other paths, use `PfLo` and `file:///full/path/here/`
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/";ok

# running "Show hidden files by default"
# defaults write com.apple.finder AppleShowAllFiles -bool true;ok

running "show all filename extensions"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true;ok

running "show status bar"
defaults write com.apple.finder ShowStatusBar -bool true;ok

running "show path bar"
defaults write com.apple.finder ShowPathbar -bool true;ok

running "allow text selection in Quick Look"
defaults write com.apple.finder QLEnableTextSelection -bool true;ok

running "display full POSIX path as Finder window title"
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true;ok

running "when performing a search, search the current folder by default"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf";ok

running "disable the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false;ok

running "enable spring loading for directories"
defaults write NSGlobalDomain com.apple.springing.enabled -bool true;ok

running "remove the spring loading delay for directories"
defaults write NSGlobalDomain com.apple.springing.delay -float 0;ok

running "avoid creating .DS_Store files on network volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true;ok

running "disable disk image verification"
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true;ok

running "automatically open a new Finder window when a volume is mounted"
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true;ok

running "use list view in all Finder windows by default"
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "clmv";ok

running "disable the warning before emptying the Trash"
defaults write com.apple.finder WarnOnEmptyTrash -bool false;ok

running "empty Trash securely by default"
defaults write com.apple.finder EmptyTrashSecurely -bool true;ok

running "enable AirDrop over Ethernet and on unsupported Macs running Lion"
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true;ok

running "show the ~/Library folder"
chflags nohidden ~/Library;ok

running "expand the following File Info panes: “General”, “Open with”, and “Sharing & Permissions”"
defaults write com.apple.finder FXInfoPanesExpanded -dict \
  General -bool true \
  OpenWith -bool true \
  Privileges -bool true;ok

###############################################################################
bot "Dock & Dashboard."
###############################################################################

running "enable highlight hover effect for the grid view of a stack (Dock)"
defaults write com.apple.dock mouse-over-hilite-stack -bool true;ok

running "set the icon size of Dock items to 36 pixels"
defaults write com.apple.dock tilesize -int 34;ok

running "change minimize/maximize window effect to scale"
defaults write com.apple.dock mineffect -string "scale";ok

running "minimize windows into their application’s icon"
defaults write com.apple.dock minimize-to-application -bool true;ok

running "enable spring loading for all Dock items"
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true;ok

running "show indicator lights for open applications in the Dock"
defaults write com.apple.dock show-process-indicators -bool true;ok

running "don’t animate opening applications from the Dock"
defaults write com.apple.dock launchanim -bool false;ok

running "speed up Mission Control animations"
defaults write com.apple.dock expose-animation-duration -float 0.1;ok

running "don’t group windows by application in Mission Control"
# (i.e. use the old Exposé behavior instead)
defaults write com.apple.dock expose-group-by-app -bool false;ok

running "disable Dashboard"
defaults write com.apple.dashboard mcx-disabled -bool true;ok

running "don’t show Dashboard as a Space"
defaults write com.apple.dock dashboard-in-overlay -bool true;ok

running "don’t automatically rearrange Spaces based on most recent use"
defaults write com.apple.dock mru-spaces -bool false;ok

running "remove the auto-hiding Dock delay"
defaults write com.apple.dock autohide-delay -float 0;ok
running "remove the animation when hiding/showing the Dock"
defaults write com.apple.dock autohide-time-modifier -float 0;ok

running "automatically hide and show the Dock"
defaults write com.apple.dock autohide -bool true;ok

running "make Dock icons of hidden applications translucent"
defaults write com.apple.dock showhidden -bool true;ok

running "make Dock more transparent"
defaults write com.apple.dock hide-mirror -bool true;ok

running "reset Launchpad, but keep the desktop wallpaper intact"
find "${HOME}/Library/Application Support/Dock" -name "*-*.db" -maxdepth 1 -delete;ok

###############################################################################
bot "Terminal & iTerm2."
###############################################################################

running "only use UTF-8 in Terminal.app"
defaults write com.apple.terminal StringEncodings -array 4;ok

running "don’t display the annoying prompt when quitting iTerm"
defaults write com.googlecode.iterm2 PromptOnQuit -bool false;ok
running "hide tab title bars"
defaults write com.googlecode.iterm2 HideTab -bool true;ok
running "set system-wide hotkey to show/hide iterm with ^\`"
defaults write com.googlecode.iterm2 Hotkey -bool true;
defaults write com.googlecode.iterm2 HotkeyChar -int 96;
defaults write com.googlecode.iterm2 HotkeyCode -int 50;
defaults write com.googlecode.iterm2 HotkeyModifiers -int 262401;
ok

# running "Make iTerm2 load new tabs in the same directory"
# defaults export com.googlecode.iterm2 /tmp/plist
# /usr/libexec/PlistBuddy -c "set \"New Bookmarks\":0:\"Custom Directory\" Recycle" /tmp/plist
# defaults import com.googlecode.iterm2 /tmp/plist;ok

###############################################################################
bot "Time Machine."
###############################################################################

running "prevent Time Machine from prompting to use new hard drives as backup volume"
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true;ok

running "disable local Time Machine backups"
hash tmutil &> /dev/null && sudo tmutil disablelocal;ok

###############################################################################
bot "Mac App Store."
###############################################################################

running "enable the WebKit Developer Tools in the Mac App Store"
defaults write com.apple.appstore WebKitDeveloperExtras -bool true;ok

running "enable Debug Menu in the Mac App Store"
defaults write com.apple.appstore ShowDebugMenu -bool true;ok

###############################################################################
bot "Google Chrome & Google Chrome Canary."
###############################################################################

running "allow installing user scripts via GitHub Gist or Userscripts.org"
defaults write com.google.Chrome ExtensionInstallSources -array "https://gist.githubusercontent.com/" "http://userscripts.org/*"
defaults write com.google.Chrome.canary ExtensionInstallSources -array "https://gist.githubusercontent.com/" "http://userscripts.org/*";ok

###############################################################################
bot "Sublime Text."
###############################################################################

running "install Sublime Text Package Control"
curl https://packagecontrol.io/Package%20Control.sublime-package > ~/Library/Application\ Support/Sublime\ Text\ 3/Installed\ Packages/Package\ Control.sublime-package;ok
running "install Sublime Text settings"
ln -s ./configs/Preferences.sublime-settings ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/Preferences.sublime-settings;ok
running "install Sublime Text packages"
ln -s ./configs/Package\ Control.sublime-settings ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/Package\ Control.sublime-settings;ok


###############################################################################
bot "NPM Globals..."
###############################################################################
require_npm bower
require_npm gulp
require_npm jshint
require_npm blastoff
require_npm nodemon
require_npm node-sass
require_npm localtunnel

###############################################################################
# bot "Ruby Gems..."
###############################################################################
# require_gem sass

###############################################################################
bot "Pip Packages..."
##############################################################################
# require_pip awscli
# require_pip awsebcli

###############################################################################
# Kill affected applications                                                  #
###############################################################################
bot "OK. Note that some of these changes require a logout/restart to take effect. Killing affected applications (so they can reboot)...."
for app in "Activity Monitor" "Address Book" "Calendar" "Contacts" "cfprefsd" \
  "Dock" "Finder" "Mail" "Messages" "Safari" "SizeUp" "SystemUIServer" \
  "iCal";do
  killall "${app}" > /dev/null 2>&1
done
