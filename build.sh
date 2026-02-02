#!/bin/sh
set -e

cd ~/mochi-src
git pull

cd lib/libelf
make
make DESTDIR=../mochifs install
