# allows running lua modules directly
export PATH := lua_modules/bin:$(PATH)

init: hooks install

hooks:
	git config core.hooksPath .githooks

clear:
	rm -rf lua_modules
	

install:
	luarocks --tree=lua_modules install --only-deps nvim-java-utils-dev-1.rockspec

lint:
	luacheck --config .luacheckrc ./lua/**/*.lua

neovim-build: clear install
	cp -r lua_modules/share/lua/5.4/* lua/
