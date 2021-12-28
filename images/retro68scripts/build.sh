if [ $# -ne 1 ] ; then
    echo 'Syntax: ./build.sh [project_name]'
    exit 1
fi

if [ ! -d "$1" ]; then
    echo 'The specified folder does not exist'
    exit 1
fi

cd "$1"
rm -rf build
mkdir build
cd build
cmake .. -DCMAKE_TOOLCHAIN_FILE=~/Retro68-build/toolchain/m68k-apple-macos/cmake/retro68.toolchain.cmake
make
