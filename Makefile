all:
	./configure_system.sh
	stow --verbose --target=$$HOME --restow */ --adopt
	@if [ "$$SHELL" != "/bin/zsh" ]; then \
		chsh -s /bin/zsh; \
	fi