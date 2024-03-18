#!/bin/bash

echo "Torghost installer v3.0"
echo "Installing prerequisites"
sudo apt install tor python3-pip cython3 -y
echo "Installing dependencies"
sudo pip3 install -r requirements.txt
mkdir build
cd build
cython3 ../torghost.py --embed -o torghost.c --verbose

version=$(ls /usr/include | grep "python")

if [ $? -eq 0 ]; then
    echo "[SUCCESS] Generated C code"
else
    echo "[ERROR] Build failed. Unable to generate C code using cython3"
    exit 1
fi

gcc -Os -I /usr/include/$version -o torghost torghost.c -l$version -lpthread -lm -lutil -ldl
if [ $? -eq 0 ]; then
    echo "[SUCCESS] Compiled to static binary"
else
    echo "[ERROR] Build failed"
    exit 1
fi

sudo cp -r torghost /usr/bin/
if [ $? -eq 0 ]; then
    echo "[SUCCESS] Copied binary to /usr/bin"
else
    echo "[ERROR] Unable to copy"
    exit 1
fi
