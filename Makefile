setup: setup-dirs
	stow -d stow -t "$(HOME)" common

setup-dirs:
	mkdir -p "$(HOME)/bin"

