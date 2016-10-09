#!/bin/sh -x

SIGNING_KEY=AED093E5

for ARCH in amd64 i386; do
    rm -rf build.$ARCH.sig
    mkdir -p build.$ARCH.sig
    cp -a build.$ARCH/speech-dispatcher-voxin* build.$ARCH.sig
    cd build.$ARCH.sig
#    dpkg-sig --verbose -k $SIGNING_KEY --sign builder --sign-changes full *.changes
    dpkg-sig --verbose -k $SIGNING_KEY --sign builder *deb
    cd ..
done

