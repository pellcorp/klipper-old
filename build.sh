#!/bin/bash

# in case build is executed from outside current dir be a gem and change the dir
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd -P)"
cd $SCRIPT_DIR

rm -rf outfw
./_build.sh bed || exit $?
./_build.sh noz || exit $?
./_build.sh mcu || exit $?

# can't build the host firmware due to 
#out/src/spicmds.o: In function `spidev_transfer':
#/home/jason/Development/klipper/src/spicmds.c:96: undefined reference to `spi_software_prepare'
#/home/jason/Development/klipper/src/spicmds.c:104: undefined reference to `spi_software_transfer'
#collect2: error: ld returned 1 exit status
#make: *** [Makefile:109: out/klipper.elf] Error 1
#./_build.sh host || exit $?

