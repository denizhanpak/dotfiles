all: dootfiles

fix:
	(for bashrc in ~/.bashrc* ~/.bash_profile; do \
		if [[ "$$(readlink "$$bashrc")" =~ dotfiles/home ]]; then \
			ln -svTf "$$(readlink "$$bashrc" |sed -e 's,dotfiles/home,dotfiles/bash,')" "$$bashrc" ;\
		fi ;\
	done)
	(if [[ "$$(readlink ~/.ipager)" =~ dotfiles/home ]]; then \
		nl="$$(readlink ~/.ipager |sed -e 's,dotfiles/home/\.ipager,dotfiles/ipager,')" ;\
		rm ~/.ipager &&\
		ln -svTf "$$nl" ~/.ipager ;\
	fi)
	(if [[ "$$(readlink ~/.gitconfig)" =~ dotfiles/home ]]; then \
		nl="$$(readlink ~/.gitconfig |sed -e 's,dotfiles/home,dotfiles/git,')" ;\
		rm ~/.gitconfig &&\
		ln -svTf "$$nl" ~/.gitconfig ;\
	fi)

dootfiles:
	@echo "thank mr skeltal"

.PHONY: all fix dootfiles
