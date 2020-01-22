FILES=Brewfile Brewfile.development Brewfile.entertainment

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

__brew:
	cat $(FILES) | brew bundle --file=-

run: __brew __setup-dock

cleanup:
	cat $(FILES) | brew bundle cleanup --file=-

cleanup-force:
	cat $(FILES) | brew bundle cleanup --force --zap --file=-