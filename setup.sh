#!/usr/bin/env sh
set -e

# Setup ssh-key if it doesn't already exist
ssh-keygen -t rsa -b 4096 -C "williamdweaver@gmail.com" -f $HOME/.ssh/id_rsa

# Install homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Create the Projects directory if it doesn't exist
mkdir -p ~/Projects
pushd ~/Projects

# Clone the git repo if it doesn't exist
folder="dotfiles"
url="https://github.com/funkymonkeymonk/dotfiles.git"

if ! git clone "${url}" "${folder}" 2>/dev/null && [ -d "${folder}" ] ; then
    echo "No need to clone: ${folder} exists"
fi

# Open dotfiles directory
cd dotfiles

# # Create a list of environments
# TODO: Add an all option
options=(`ls Brewfile* | grep -v *.json`)

menu() {
    echo "Avaliable options:"
    for i in ${!options[@]}; do 
        printf "%3d%s) %s\n" $((i+1)) "${choices[i]:- }" "${options[i]}"
    done
    if [[ "$msg" ]]; then echo "$msg"; fi
}

prompt="Check an option (again to uncheck, ENTER when done): "
while menu && read -rp "$prompt" num && [[ "$num" ]]; do
    [[ "$num" != *[![:digit:]]* ]] &&
    (( num > 0 && num <= ${#options[@]} )) ||
    { msg="Invalid option: $num"; continue; }
    ((num--)); msg="${options[num]} was ${choices[num]:+un}checked"
    [[ "${choices[num]}" ]] && choices[num]="" || choices[num]="+"
done

printf "You selected"; msg=" nothing"

for i in ${!options[@]}; do 
    [[ "${choices[i]}" ]] && { printf " %s" "${options[i]}"; msg=""; }
    # Write environment to temp file
    [[ "${choices[i]}" ]] && { echo "${options[i]}" >> temp ;}
done
echo "$msg"

# Move temp file to env file
## TODO prompt and diff
mv temp env

# Run make
echo "Starting install now" 
make run