.PHONY: setup setup-dirs brew stow check

setup: setup-dirs brew stow

setup-dirs:
	@mkdir -p "$(HOME)/bin"

stow: setup-dirs
	stow -d stow -t "$(HOME)" common

brew:
	brew bundle --file=Brewfile

check:
	brew bundle check --file=Brewfile || true
