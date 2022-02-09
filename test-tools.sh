install-mpv() {
# only run these commands the first time
brew install --only-dependencies mpv
git clone https://github.com/mpv-player/mpv


cd mpv


# only run these commands if you want to update your older instance to the latest source
git reset --hard
git clean -f -d
git pull origin master


if [ -d "build" ]; then
	rm -r build
fi
./bootstrap.py
export PKG_CONFIG_PATH="$(brew --prefix luajit-openresty)/lib/pkgconfig"
if ! ./waf configure --lua=luajit; then
	exit 1
fi
if ! ./waf build; then
	exit 1
fi
./TOOLS/osxbundle.py -s build/mpv
}