#! /bin/bash

clear

c3c build -q
cp ../pleroma/build/libpleroma.so build/libpleroma.so
LD_LIBRARY_PATH=./build/ ./build/gnosis
