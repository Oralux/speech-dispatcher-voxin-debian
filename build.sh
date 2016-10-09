#!/bin/bash

unset PV

function build_pkg() {
	local ARCH=
	if [ -n "$1" ]; then
		ARCH="-a $1"
	fi
	rm -rf src
	cp -a src.orig src
	cp control changelog speech-dispatcher-voxin.install src/speech-dispatcher-$PV/debian

	cd src/speech-dispatcher-$PV
	dpkg-buildpackage -uc -us $ARCH
	cd ../..	
}

if [ ! -d src.orig ]; then
    mkdir src.orig
    cd src.orig
    apt-get source speech-dispatcher
    cd ..
    sudo apt-get build-dep speech-dispatcher
fi

cd src.orig
PV=$(find . -name "speech-dispatcher*" -type d | sed -e 's+./speech-dispatcher-++')
cd ..

if [ "$(uname -m)" = "x86_64" ]; then
	ARCH=amd64
else
	ARCH=i386
fi

rm -rf build.$ARCH
mkdir -p build.$ARCH
build_pkg $ARCH
find src -maxdepth 1 -name 'speech-dispatcher-voxin*' -type f -exec mv {} build.$ARCH \;

echo sudo apt-get remove speech-dispatcher-voxin
echo sudo dpkg -i build.$ARCH.sig/speech-dispatcher-voxin_${PV}-0voxin1_$ARCH.deb 
