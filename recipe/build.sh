#!/bin/bash

set -eux

# r-base depends on make, which is therefore installed in the host environment.
# When cross-compiling, cmake picks up the version of make installed in the host
# environment to compile the test program.
if [[ "${build_platform}" != "${target_platform}" ]]; then
    CMAKE_ARGS="${CMAKE_ARGS} -DCMAKE_MAKE_PROGRAM=${BUILD_PREFIX}/bin/make"

    pushd hera
        ${R} CMD INSTALL --build . ${R_ARGS} --library=${PREFIX}/lib/R/library
    popd
    export INSTALL_HERA="OFF"
else
    export INSTALL_HERA="ON"
fi

mkdir build && cd build

cmake ${CMAKE_ARGS} \
      -DCMAKE_BUILD_TYPE=Release      \
      -DCMAKE_INSTALL_PREFIX=$PREFIX  \
      -DCMAKE_PREFIX_PATH=$PREFIX     \
      -DCMAKE_INSTALL_LIBDIR=lib      \
      -DINSTALL_HERA=${INSTALL_HERA}  \
      $SRC_DIR

make install
