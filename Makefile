all:
	./configure_system.sh
	stow --verbose --target=$$HOME --restow */ --adopt
	@if [ "$$SHELL" != "/bin/zsh" ]; then \
		chsh -s /bin/zsh; \
	fi
reset:
	stow --verbose --target=$$HOME --delete */ --adopt