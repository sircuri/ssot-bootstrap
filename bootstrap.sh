#!/bin/bash

if [ ! -f ~/.ssh/github ]; then
	echo ""
	echo "Create the file ~/.ssh/github that contains the private key that can be used to access github in your name."
	echo "Restart this script to continue."
    exit
fi

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