#!/bin/bash
if [[ ! -d builddir ]]; then
    mkdir builddir
    meson setup builddir
fi

cd builddir
meson compile

echo "Done!"
