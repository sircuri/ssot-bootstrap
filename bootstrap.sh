#!/bin/bash

echo -e "___  ____ ____ ___ ____ ___ ____ ____ ___     _   _ ____ _  _ ____    _  _ ____ ____ _  _ _ _  _ ____ \n|__] |  | |  |  |  [__   |  |__/ |__| |__]     \_/  |  | |  | |__/    |\/| |__| |    |__| | |\ | |___ \n|__] |__| |__|  |  ___]  |  |  \ |  | |         |   |__| |__| |  \    |  | |  | |___ |  | | | \| |___ \n                                                                                                      "

echo "Verify github private key is available..."

if [ ! -f ~/.ssh/github ]; then
	echo ""
	echo "Create the file ~/.ssh/github that contains the private key that can be used to access github in your name."
	echo "Restart this script to continue."
    exit
fi

echo ""
echo "This scripts need root permissions to continue. Please enter your root credentials..."
echo ""

sudo apt update

# Mark script as non interactive
export DEBIAN_FRONTEND=noninteractive

# If above does not work
if [ -f /etc/needrestart/needrestart.conf ]; then
  sudo sed -i 's/#$nrconf{restart} = '"'"'i'"'"';/$nrconf{restart} = '"'"'l'"'"';/g' /etc/needrestart/needrestart.conf
  echo "Updated /etc/needrestart/needrestart.conf and changed 'i) nteractive' to 'l) ist only'"
fi

sudo apt install git
eval "$(ssh-agent -s)"

chmod 600 ~/.ssh/github
echo "To use the private key for github, please provide your password of the private key."
ssh-add ~/.ssh/github
git clone git@github.com:sircuri/ssot-scripts.git
cd ssot-scripts

numer_of_branches=$(git branch -r | awk '{$1=$1;print $1}' | wc -l)
echo
echo "Which branch should be used?"
git branch -r | awk '{$1=$1;print $1}' | cut -d '/' -f 2 | nl -s ') '
read -p "Branch [1]: " branch
until [[ -z "$branch" || "$branch" =~ ^[0-9]+$ && "$branch" -le "$numer_of_branches" ]]; do
	echo "$branch: invalid selection."
	read -p "Branch [1]: " branch
done
[[ -z "$branch" ]] && branch="1"
checkout=$(git branch -r | awk '{$1=$1;print $1}' | cut -d '/' -f 2 | sed -n "$branch"p)
git checkout "$checkout"

cd ~/ssot-scripts/dotfiles/scripts
sudo bash install.sh