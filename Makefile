


push:
	alejandra * && nix flake check --refresh && git add . && git commit -m "u" && git push
