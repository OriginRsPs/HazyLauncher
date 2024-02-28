#!/bin/bash

set -e

cmake -S liblauncher -B liblauncher/build32 -A Win32
cmake --build liblauncher/build32 --config Release

pushd native
cmake -B build-x86 -A Win32
cmake --build build-x86 --config Release
popd

source .jdk-versions.sh

rm -rf build/win-x86
mkdir -p build/win-x86

if ! [ -f win32_jre.zip ] ; then
    curl -Lo win32_jre.zip $WIN32_LINK
fi

echo "$WIN32_CHKSUM win32_jre.zip" | sha256sum -c

cp native/build-x86/src/Release/Hazy.exe build/win-x86/
cp target/Hazy.jar build/win-x86/
cp packr/win-x86-config.json build/win-x86/config.json
cp liblauncher/build32/Release/launcher_x86.dll build/win-x86/

unzip win32_jre.zip
mv jdk-$WIN32_VERSION-jre build/win-x86/jre

echo Hazy.exe 32bit sha256sum
sha256sum build/win-x86/Hazy.exe

dumpbin //HEADERS build/win-x86/Hazy.exe

# We use the filtered iss file
iscc target/filtered-resources/app32.iss