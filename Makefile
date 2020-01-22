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

run:
	cat $(FILES) | brew bundle --file=-

cleanup:
	cat $(FILES) | brew bundle cleanup --file=-

cleanup-force:
	cat $(FILES) | brew bundle cleanup --force --zap --file=-