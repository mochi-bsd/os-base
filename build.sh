#!/bin/sh
set -e

cd ~/mochi-src
git pull

cd bin
make
make DESTDIR=../mochifs install
