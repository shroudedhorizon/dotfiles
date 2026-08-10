install:
	./configure_system.sh
reset:
	stow --verbose --target=$$HOME --delete */ --adopt