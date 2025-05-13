# Handy script to install homebrew and some common packages
# This script is intended to be run on a MacOSX system

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install firefox
brew install visual-studio-code
brew install git
brew install --cask microsoft-office
brew install ansible
brew install onedrive
brew install --cask drawio
brew install docker
brew install --cask powershell
brew install --cask vmware-fusion
brew install --cask bitwarden
brew install azure-cli
brew install spotify
Install-Module -Name Az -Repository PSGallery -Force

brew tap hashicorp/tap
brew install hashicorp/tap/terraform
brew update
