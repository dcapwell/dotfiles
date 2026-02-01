.PHONY: setup setup-dirs brew stow check

setup: setup-dirs brew stow

setup-dirs:
	@mkdir -p "$(HOME)/bin"
	# in order to have local overrides, need to make this dir so files are linked and not this dir
	@mkdir -p "$(HOME)/.oh-my-zsh/custom"

stow: setup-dirs
	stow -d stow -t "$(HOME)" common

brew:
	brew bundle --file=Brewfile

check:
	brew bundle check --file=Brewfile || true
