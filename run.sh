#!/bin/bash

# Install ansible for the localuser if it's not already available

# Handle Options
# TODO: I need to move the functions out of options handling so that I control
#       order of execution.
while test $# -gt 0
do
  case "$1" in
    --update)
      echo "Updating remote-roles"
      ansible-galaxy install -r requirements.yml -f -n
      ;;
    --test)
      echo "Testing ansible playbook"
      ansible-playbook -i inventory --check --diff main.yml
      ;;
    --run)
      echo "Running ansible playbook"
      ansible-playbook -i inventory main.yml
      ;;
    --source)
      echo "Sourcing ~/.bash_profile"
      echo "TODO: I'm not sure how to call source for the parent shell."
      echo "Until then run"
      echo "  . ~/.bash_profile"
      ;;
    --*)
      echo "bad option $1"
      help
      ;;
    *) help
      ;;
  esac
  shift
done
