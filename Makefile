push:
	$(call spacer)
	alejandra *
	$(call spacer)
	nix flake check --refresh
	$(call spacer)
	git add . 
	$(call spacer)
	git commit -m "u" 
	$(call spacer)
	git push

define spacer
	@echo -e "\n\n # # # # # # # # # \n\n"
endef