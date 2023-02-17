#!/bin/bash
# This file is meant to be included by the parent cppbuild.sh script
if [[ -z "$PLATFORM" ]]; then
    pushd ..
    bash cppbuild.sh "$@" libfreenect2
    popd
    exit
fi

NASM_VERSION=2.14
LIBUSB_VERSION=1.0.22
GLFW_VERSION=3.2.1
LIBJPEG=libjpeg-turbo-1.5.3
LIBFREENECT2_VERSION=0.2.0
CUDA_VERSION=11.8

download https://download.videolan.org/contrib/nasm/nasm-$NASM_VERSION.tar.gz nasm-$NASM_VERSION.tar.gz
download http://sourceforge.net/projects/libusb/files/libusb-1.0/libusb-$LIBUSB_VERSION/libusb-$LIBUSB_VERSION.tar.bz2/download libusb-$LIBUSB_VERSION.tar.bz2
download https://github.com/glfw/glfw/archive/$GLFW_VERSION.tar.gz glfw-$GLFW_VERSION.tar.gz
download http://downloads.sourceforge.net/project/libjpeg-turbo/1.5.3/$LIBJPEG.tar.gz $LIBJPEG.tar.gz
download https://github.com/OpenKinect/libfreenect2/archive/v$LIBFREENECT2_VERSION.tar.gz libfreenect2-$LIBFREENECT2_VERSION.tar.gz
if [[ $PLATFORM == windows* ]] || [[ $PLATFORM == linux-x86_64 ]]; then
    if [[ $PLATFORM == windows* ]]; then
        download https://github.com/OpenKinect/libfreenect2/releases/download/v$LIBFREENECT2_VERSION/libfreenect2-$LIBFREENECT2_VERSION-usbdk-vs2015-x64.zip libfreenect2-$LIBFREENECT2_VERSION-usbdk-vs2015-x64.zip
    fi
    download https://github.com/NVIDIA/cuda-samples/archive/refs/tags/10.1.2.tar.gz cuda-samples-10.1.2.tar.gz
fi
#download https://github.com/NVIDIA/cuda-samples/archive/v$CUDA_VERSION.tar.gz cuda-samples-$CUDA_VERSION.tar.gz

mkdir -p $PLATFORM
cd $PLATFORM
INSTALL_PATH=`pwd`
echo "Decompressing archives..."
mkdir -p include lib bin
tar --totals -xzf ../nasm-$NASM_VERSION.tar.gz
tar --totals -xjf ../libusb-$LIBUSB_VERSION.tar.bz2
tar --totals -xzf ../glfw-$GLFW_VERSION.tar.gz
tar --totals -xzf ../$LIBJPEG.tar.gz
tar --totals -xzf ../libfreenect2-$LIBFREENECT2_VERSION.tar.gz
#tar --totals -xzf ../cuda-samples-$CUDA_VERSION.tar.gz
if [[ $PLATFORM == windows* ]] || [[ $PLATFORM == linux-x86_64 ]]; then
    if [[ $PLATFORM == windows* ]]; then
        unzip -o ../libfreenect2-$LIBFREENECT2_VERSION-usbdk-vs2015-x64.zip
    fi
    tar --totals -xzf ../cuda-samples-10.1.2.tar.gz
fi

cd nasm-$NASM_VERSION
# fix for build with GCC 8.x
sedinplace 's/void pure_func/void/g' include/nasmlib.h
./configure --prefix=$INSTALL_PATH
make -j $MAKEJ V=0
make install
export PATH=$INSTALL_PATH/bin:$PATH
cd ..
echo "x-={[X]}=-x Building '$PLATFORM' from '$INSTALL_PATH'"
#rm -r cuda-samples-$CUDA_VERSION/Samples/4_CUDA_Libraries/watershedSegmentationNPP
# NOTE: CUDA VARS /// CUDA_TOOLKIT_ROOT_DIR CUDA_NVCC_EXECUTABLE CUDA_INCLUDE_DIRS CUDA_CUDART_LIBRARY

case $PLATFORM in
    linux-x86)
        #yum -y install tree
        #echo "x-={[X]}=-x"
        #tree -a
        #echo "x-={[X]}=-x"
        export CC="gcc -m32 -fPIC"
        cd libusb-$LIBUSB_VERSION
        CC="gcc -m32" CXX="g++ -m32" ./configure --prefix=$INSTALL_PATH --disable-shared --with-pic --host=i686-linux --disable-udev
        make -j $MAKEJ
        make install
        cd ../glfw-$GLFW_VERSION
        CC="gcc -m32" CXX="g++ -m32" $CMAKE -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=.. .
        make -j $MAKEJ
        make install
        cd ../$LIBJPEG
        ./configure --prefix=$INSTALL_PATH --disable-shared --with-pic --host=i686-linux
        make -j $MAKEJ
        make install
        # NOTE: DEPLOY_CUDA CURRENTLY DOESN'T SUPPORT x86 LINUX
        #cd ../cuda-samples-$CUDA_VERSION
        #make -j $MAKEJ
        #make install
        cd ../libfreenect2-$LIBFREENECT2_VERSION
        patch -Np1 < ../../../libfreenect2.patch
        CC="gcc -m32" CXX="g++ -m32" $CMAKE -DCMAKE_BUILD_TYPE=Release -DBUILD_EXAMPLES=OFF -DBUILD_OPENNI_DRIVER=OFF -DENABLE_CUDA=OFF -DENABLE_CXX11=OFF -DENABLE_OPENCL=OFF -DENABLE_VAAPI=OFF -DENABLE_TEGRAJPEG=OFF -DCMAKE_INSTALL_PREFIX=.. -DLibUSB_INCLUDE_DIRS=../include/libusb-1.0 -DLibUSB_LIBRARIES=../lib/libusb-1.0.a -DGLFW3_INCLUDE_DIRS=../include -DGLFW3_LIBRARY=../lib/libglfw3.a -DTurboJPEG_INCLUDE_DIRS=../include -DTurboJPEG_LIBRARIES=../lib/libturbojpeg.a -DCMAKE_SHARED_LINKER_FLAGS="-lX11 -lXrandr -lXinerama -lXxf86vm -lXcursor" .
        make -j $MAKEJ
        make install
        ;;
    linux-x86_64)
        #yum -y install tree
        #echo "x-={[X]}=-x"
        #tree -a
        #echo "x-={[X]}=-x"
        export CC="gcc -m64 -fPIC"
        cd libusb-$LIBUSB_VERSION
        CC="gcc -m64" CXX="g++ -m64" ./configure --prefix=$INSTALL_PATH --disable-shared --with-pic --host=x86_64-linux --disable-udev
        make -j $MAKEJ
        make install
        cd ../glfw-$GLFW_VERSION
        CC="gcc -m64" CXX="g++ -m64" $CMAKE -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=.. .
        make -j $MAKEJ
        make install
        cd ../$LIBJPEG
        ./configure --prefix=$INSTALL_PATH --disable-shared --with-pic --host=x86_64-linux
        make -j $MAKEJ
        make install
        cd ../cuda-samples-10.1.2
        find . -maxdepth 2 | grep "\.h$" | tr '\n' '\0' | xargs -0 -I {} cp "{}" ../include
        #find -D exec . -maxdepth 2 -type f -name '*.h' -exec "mv '{}' ../include"
        #cd ../cuda-samples-$CUDA_VERSION
        #make -j $MAKEJ
        #make install
        cd ../libfreenect2-$LIBFREENECT2_VERSION
        patch -Np1 < ../../../libfreenect2.patch
        CC="gcc -m64 -std=c17" CXX="g++ -m64 -std=c++17" $CMAKE -DCMAKE_BUILD_TYPE=Release -DBUILD_EXAMPLES=OFF -DBUILD_OPENNI_DRIVER=OFF -DENABLE_CUDA=ON -DENABLE_CXX17=OFF -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda-$CUDA_VERSION -DCUDA_NVCC_EXECUTABLE=/usr/local/cuda-$CUDA_VERSION/bin/nvcc -DENABLE_OPENCL=OFF -DENABLE_VAAPI=OFF -DENABLE_TEGRAJPEG=OFF -DCMAKE_INSTALL_PREFIX=.. -DLibUSB_INCLUDE_DIRS=../include/libusb-1.0 -DLibUSB_LIBRARIES=../lib/libusb-1.0.a -DGLFW3_INCLUDE_DIRS=../include -DGLFW3_LIBRARY=../lib/libglfw3.a -DTurboJPEG_INCLUDE_DIRS=../include -DTurboJPEG_LIBRARIES=../lib/libturbojpeg.a -DCMAKE_SHARED_LINKER_FLAGS="-lX11 -lXrandr -lXinerama -lXxf86vm -lXcursor" .
        make -j $MAKEJ
        make install
        ;;
    macosx-x86_64)
        #brew install tree
        #echo "x-={[X]}=-x"
        #tree -a
        #echo "x-={[X]}=-x"
        cd glfw-$GLFW_VERSION
        $CMAKE -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=.. .
        make -j $MAKEJ
        make install
        cd ../$LIBJPEG
        ./configure --prefix=$INSTALL_PATH --disable-shared --with-pic
        make -j $MAKEJ
        make install
        # NOTE: DEPLOY_CUDA CURRENTLY DOESN'T SUPPORT MAC
        #cd ../cuda-samples-$CUDA_VERSION
        #make -j $MAKEJ
        #make install
        cd ../libfreenect2-$LIBFREENECT2_VERSION
        patch -Np1 < ../../../libfreenect2.patch
        LDFLAGS="-framework Cocoa -framework IOKit -framework CoreFoundation -framework CoreVideo" $CMAKE -DCMAKE_BUILD_TYPE=Release -DBUILD_EXAMPLES=OFF -DBUILD_OPENNI_DRIVER=OFF -DENABLE_CUDA=OFF -DENABLE_CXX17=ON -DENABLE_OPENCL=OFF -DENABLE_VAAPI=OFF -DENABLE_TEGRAJPEG=OFF -DCMAKE_INSTALL_PREFIX=.. -DLibUSB_INCLUDE_DIRS=/usr/local/include/libusb-1.0 -DLibUSB_LIBRARIES=/usr/local/lib/libusb-1.0.dylib -DGLFW3_INCLUDE_DIRS=../include -DGLFW3_LIBRARY=../lib/libglfw3.a -DTurboJPEG_INCLUDE_DIRS=../include -DTurboJPEG_LIBRARIES=../lib/libturbojpeg.a -DCMAKE_MACOSX_RPATH=ON .
        make -j $MAKEJ
        make install
        install_name_tool -change /usr/local/opt/libusb/lib/libusb-1.0.0.dylib @rpath/libusb-1.0.0.dylib ../lib/libfreenect2.dylib
        ;;
    windows-x86_64)
        #echo "x-={[X]}=-x"
        #tree.com //a //f
        #echo "x-={[X]}=-x"
        cd cuda-samples-10.1.2
        powershell -command "Get-ChildItem -Recurse -Force -Depth 2 -Include *.h | Move-Item -Destination '..\include' -Force"
        cd ..
        #cd cuda-samples-$CUDA_VERSION
        #make -j $MAKEJ
        #make install
        #cd ..
        echo "CMake - \"$CMAKE\""
        cp -a libfreenect2-$LIBFREENECT2_VERSION-usbdk-vs2015-x64/include/* include
        cp -a libfreenect2-$LIBFREENECT2_VERSION-usbdk-vs2015-x64/lib/* lib
        cp -a libfreenect2-$LIBFREENECT2_VERSION-usbdk-vs2015-x64/bin/* bin
        cd libfreenect2-$LIBFREENECT2_VERSION
        CC="cl freenect2.lib" CXX="cl freenect2.lib" $CMAKE /I ../include /DCMAKE_BUILD_TYPE=Release /DBUILD_EXAMPLES=OFF /DBUILD_OPENNI_DRIVER=OFF /DENABLE_CUDA=ON /DENABLE_CXX11=OFF /DCUDA_TOOLKIT_ROOT_DIR=$CUDA_PATH /DENABLE_OPENCL=OFF /DENABLE_VAAPI=OFF /DENABLE_TEGRAJPEG=OFF /DCMAKE_INSTALL_PREFIX=.. /DLibUSB_LIBRARIES=../bin/libusb-1.0.dll /DGLFW3_LIBRARY=../bin/glfw3.dll /DTurboJPEG_LIBRARIES=../bin/turbojpeg.dll /link /LIBPATH:../lib .
        make install
        ;;
    *)
        echo "Error: Platform \"$PLATFORM\" is not supported"
        ;;
esac

cd ../..