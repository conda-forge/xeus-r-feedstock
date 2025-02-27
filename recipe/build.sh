#!/bin/bash

set -eux

# r-base depends on make, which is therefore installed in the host environment.
# When cross-compiling, cmake picks up the version of make installed in the host
# environment to compile the test program.
if [[ "${build_platform}" != "${target_platform}" ]]; then
    CMAKE_ARGS="${CMAKE_ARGS} -DCMAKE_MAKE_PROGRAM=${BUILD_PREFIX}/bin/make"

    $BUILD_PREFIX/bin/R CMD INSTALL ./hera --no-byte-compile --no-test-load \
        --library=${PREFIX}/lib/R/library
fi

mkdir build && cd build

cmake ${CMAKE_ARGS} \
      -DCMAKE_BUILD_TYPE=Release      \
      -DCMAKE_INSTALL_PREFIX=$PREFIX  \
      -DCMAKE_PREFIX_PATH=$PREFIX     \
      -DCMAKE_INSTALL_LIBDIR=lib      \
      $SRC_DIR

make install
