FILES=`cat env`
.PHONY: env

list:
	@sh -c "$(MAKE) -p no_op__ | \
		awk -F':' '/^[a-zA-Z0-9][^\$$#\/\\t=]*:([^=]|$$)/ {split(\$$1,A,/ /);\
		for(i in A)print A[i]}' | \
		grep -v '__\$$' | \
		grep -v 'make\[1\]' | \
		grep -v 'Makefile' | \
		sort"

# required for list
no_op__:

__setup-dock:
	# Only show running applications in the dock
	defaults write com.apple.dock static-only -bool TRUE
	# Autohide the dock
	defaults write com.apple.dock autohide -bool TRUE
	# Restart dock
	killall Dock

__setup-screenshot-location:
	# Configure screenshots to save to
	mkdir -p ~/Pictures/Screenshots/
	defaults write com.apple.screencapture location "~/Pictures/Screenshots"

__setup-finder:
	# Configure finder to show the path
	defaults write com.apple.finder ShowPathbar -bool true
	killall Finder

__osx-preferences: __setup-dock __setup-screenshot-location __setup-finder

__brew:
	cat $(FILES) | brew bundle --file=-

__xbar:
	rm -rf ~/Library/Application\ Support/xbar/plugins
	ln -sf $(PWD)/files/xbar ~/Library/Application\ Support/xbar/plugins
	# Refresh xbar
	open xbar://app.xbarapp.com/refreshAllPlugins

__gitconfig:
	# This could use a more complex merge strategy but this will
	# prevent me from blowing away local changes
	rsync --ignore-existing ./files/.gitconfig ~/.gitconfig
	rsync --ignore-existing ./files/.gitignore_global ~/.gitignore_global

__install_divvy_preferences:
	# Someday I will probably make a change and this will override it.
    # TODO: Request permission before overwriting
	open `cat ./files/divvy_preferences`
	#osascript -e 'tell application "Divvy" to quit' -e 'delay 2' -e 'tell application "Divvy" to activate'

__copy-files: __xbar __gitconfig __install_divvy_preferences

__switch-remote-to-ssh:
	git remote set-url origin git@github.com:funkymonkeymonk/dotfiles.git

__copy_sourced_configs: ./files/sourced_configs/*
	mkdir -p ~/dotfiles
	for file in $^; do \
		rsync --ignore-existing $${file} ~/dotfiles/; \
	done

__zshrc:
	# This could use a more complex merge strategy but this will
	# prevent me from blowing away local changes
	rsync --ignore-existing ./files/.zshrc ~/.zshrc

__p10k:
	# This could use a more complex merge strategy but this will
	# prevent me from blowing away local changes
	rsync --ignore-existing ./files/.p10k.zsh ~/.p10k.zsh

__shell-config: __copy_sourced_configs __p10k __zshrc

env:
	@echo $(FILES)

run: __brew __copy-files __shell-config __osx-preferences __switch-remote-to-ssh

cleanup:
	cat $(FILES) | brew bundle cleanup --file=-

cleanup-force:
	cat $(FILES) | brew bundle cleanup --force --zap --file=-
