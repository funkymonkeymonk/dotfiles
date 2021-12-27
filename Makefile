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

__brew:
	cat $(FILES) | brew bundle --file=-

__bitbar:
	rsync -r ./files/bitbar ~

__gitconfig:
	# This could use a more complex merge strategy but this will
	# prevent me from blowing away local changes
	rsync --ignore-existing ./files/.gitconfig ~/.gitconfig

__zshrc:
	# This could use a more complex merge strategy but this will
	# prevent me from blowing away local changes
	rsync --ignore-existing ./files/.zshrc ~/.zshrc

# Someday I will probably make a change and this will override it.
# TODO: Request permission before overwriting
__install_divvy_preferences:
	open `cat ./files/divvy_preferences`
	#osascript -e 'tell application "Divvy" to quit' -e 'delay 2' -e 'tell application "Divvy" to activate'

__copy-files: __bitbar __gitconfig __zshrc __install_divvy_preferences

env:
	@echo $(FILES)

run: __brew __copy-files __setup-dock __setup-screenshot-location

cleanup:
	cat $(FILES) | brew bundle cleanup --file=-

cleanup-force:
	cat $(FILES) | brew bundle cleanup --force --zap --file=-
