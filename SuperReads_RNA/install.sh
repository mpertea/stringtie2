#!/bin/sh

set -xe

ROOT=`pwd`
[ -z "$DEST" ] && DEST="$ROOT"

###################
# Check for gmake #
###################
mkdir -p dist-bin
PATH=$PATH:$ROOT/dist-bin
ln -sf $(which make) $ROOT/dist-bin/gmake
ln -sf $ROOT/PkgConfig.pm $ROOT/dist-bin/pkg-config

export NUM_THREADS=`grep -c '^processor' /proc/cpuinfo 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 1`;
BINDIR=$DEST/bin
LIBDIR=$DEST/lib
export PKG_CONFIG_PATH=$LIBDIR/pkgconfig:$PKG_CONFIG_PATH
(cd global-1 && autoreconf -f -i && \
 ./configure --prefix=$DEST --bindir=$BINDIR --libdir=$LIBDIR && make -j $NUM_THREADS install-special)

echo "creating sr_config_example.txt with correct PATHS"
$BINDIR/createSuperReads_RNA -g sr_config_example.txt
