#!/usr/bin/env sh
set -e
function install_homebrew() {
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

function setup_project_directory() {
  # Create the Projects directory if it doesn't exist
  mkdir -p ~/Projects
  pushd ~/Projects

  # Clone the git repo if it doesn't exist
  folder="dotfiles"
  url="https://github.com/funkymonkeymonk/dotfiles.git"

  if ! git clone "${url}" "${folder}" 2>/dev/null && [ -d "${folder}" ] ; then
      echo "No need to clone: ${folder} exists"
  fi

  popd
}

function build_environment_list() {
  # TODO: Add an all option
  options=(`ls Brewfile.* | grep -v site-specific | grep -v *.json`)
  touch Brewfile.site-specific

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
  echo "Brewfile" >> temp
  echo "Brewfile.site-specific" >> temp

  for i in ${!options[@]}; do
      [[ "${choices[i]}" ]] && { printf " %s" "${options[i]}"; msg=""; }
      # Write environment to temp file
      [[ "${choices[i]}" ]] && { echo "${options[i]}" >> temp ;}
  done
  echo "$msg"

  # Move temp file to env file
  ## TODO prompt and diff
  mv temp env
}

function run_install() {
  echo "Starting install now"
  make run
}


install_homebrew
setup_project_directory
pushd ~/Projects/dotfiles
build_environment_list
run_install
