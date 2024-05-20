#!/bin/bash

# in case build is executed from outside current dir be a gem and change the dir
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd -P)"
cd $SCRIPT_DIR

CROSS_PREFIX=
CROSS_PREFIX_ARG=
if [ "$1" = "host" ]; then
    export CROSS_PREFIX=mips-linux-gnu-
    CROSS_PREFIX_ARG="CROSS_PREFIX=$CROSS_PREFIX"

    if [ ! -f Makefile.backup ] && [ ! -f src/Makefile.backup ]; then
        cp Makefile Makefile.backup
        cp src/Makefile src/Makefile.backup
        sed -i 's/prtouch_v2_compile.c//g' src/Makefile
        sed -i 's/target-y += $(OUT)src\/prtouch_v2.o//g' Makefile
        sed -i 's/$(OUT)src\/prtouch_v2.o//g' Makefile
    fi
fi

cp .config.$1 .config
mkdir -p outfw
make ${CROSS_PREFIX_ARG} clean
make ${CROSS_PREFIX_ARG}

if [ "$1" = "host" ]; then
    if [ -f Makefile.backup ] && [ -f src/Makefile.backup ]; then
        mv Makefile.backup Makefile
        mv src/Makefile.backup src/Makefile
    fi
    if [ -f out/klipper.elf ]; then
        ${CROSS_PREFIX}strip out/klipper.elf -o outfw/klipper_mcu
        chmod ugo+x outfw/klipper_mcu
    fi
else
    mv out/klipper.bin outfw/${1}_klipper.bin
    mv out/${1}*.bin outfw/
fi
