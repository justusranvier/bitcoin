#!/usr/bin/env bash
#
# 2.build-deps.sh :
#
# Build project, including dependencies for given platform (1st argument)
# (for a list of valid platforms, see 1.env-setup.sh)
#

LINK=`readlink -f $0`
if [[ -z ${LINK} ]]; then
LINK=$0
fi
DIRNAME=`dirname ${LINK}`

RELEASE_VERSION="0.8.0"
SOURCE_DESTDIR=${DIRNAME}/dependencies
RELEASE_PUBLISH_DIR=releases
TARGET_PLATFORMS=("mingw32")
WORKSPACE=${DIRNAME}

exit_error() {
    echo $1;
    exit 1;
}

for CUR_PLATFORM in ${TARGET_PLATFORMS}; do
    if [ -z ${CUR_PLATFORM} ]; then
        exit_error "NO target platform given."
    fi

    # ensure platform base directory exist:
    platform_src_dir=${SOURCE_DESTDIR}/$CUR_PLATFORM
    [ -d ${platform_src_dir} ] || exit_error "INVALID platform given, or missing platformdir"

    # quite ugly case...
    case "${CUR_PLATFORM}" in
        mingw32)      
            echo "Building dependencies for mingw32 platform..."

            # qrencode
            # first check if we really want to rebuilt this (70 days old):
            need_rebuild=1
            if [ -f ${platform_src_dir}/qrencode-3.4.2/.libs/libqrencode.a ]; then
                echo "libqrencode.a already built, checking its oldness..."
                last_mtime=`stat -c "%Z" ${platform_src_dir}/qrencode-3.4.2/.libs/libqrencode.a`
                now_time=`date +"%s"`
                let now_time=now_time-6048000
                if [ ${last_mtime} -gt ${now_time} ]; then
                    echo "libqrencode.a generated less than 70 days ago, not rebuilding..."
                    need_rebuild=0
                fi

            fi
            if [ ${need_rebuild} -eq 1 ]; then
                echo "Building qrencode..."
                cd ${platform_src_dir}/qrencode-3.4.2/ || exit_error "Failed to change to qrencode-3.4.2/ dir"
                PATH=$PATH:/usr/i586-mingw32msvc/bin ./configure --host=i586-mingw32msvc --prefix=/usr/i586-mingw32msvc --disable-sdltest --without-tools --without-tests || exit_error "configure failed"
                PATH=$PATH:/usr/i586-mingw32msvc/bin make || exit_error "make failed"
                if [ ! -f ${platform_src_dir}/qrencode-3.4.2/.libs/libqrencode.a ]; then
                    exit_error "UNABLE TO FIND generated libqrencode.a"
                fi
            fi

            # openssl
            # first check if we really want to rebuilt this (70 days old):
            need_rebuild=1
            if [ -f ${platform_src_dir}/openssl-1.0.1c/libcrypto.a ]; then
                echo "libcrypto.a already built, checking its oldness..."
                last_mtime=`stat -c "%Z" ${platform_src_dir}/openssl-1.0.1c/libcrypto.a`
                now_time=`date +"%s"`
                let now_time=now_time-6048000
                if [ ${last_mtime} -gt ${now_time} ]; then
                    echo "libcrypto.a generated less than 70 days ago, not rebuilding..."
                    need_rebuild=0
                fi

            fi
            if [ ${need_rebuild} -eq 1 ]; then
                echo "Building openssl..."
                cd ${platform_src_dir}/openssl-1.0.1c/ || exit_error "Failed to change to openssl-1.0.1c/ dir"
                CROSS_COMPILE="i586-mingw32msvc-" ./Configure mingw no-asm no-shared --prefix=/usr/i586-mingw32msvc || exit_error "configure failed"
                PATH=$PATH:/usr/i586-mingw32msvc/bin make depend || exit_error "depend failed"
                PATH=$PATH:/usr/i586-mingw32msvc/bin make || exit_error "make failed"
                if [ ! -f ${platform_src_dir}/openssl-1.0.1c/libcrypto.a ]; then
                    exit_error "UNABLE TO FIND generated libcrypto.a"
                fi
            fi

            # berkeley DB
            need_rebuild=1
            if [ -f ${platform_src_dir}/db-4.8.30.NC/build_unix/libdb_cxx.a ]; then
                echo "libdb_cxx.a already built, checking its oldness..."
                last_mtime=`stat -c "%Z" ${platform_src_dir}/db-4.8.30.NC/build_unix/libdb_cxx.a`
                now_time=`date +"%s"`
                let now_time=now_time-6048000
                if [ ${last_mtime} -gt ${now_time} ]; then
                    echo "libdb_cxx.a generated less than 70 days ago, not rebuilding..."
                    need_rebuild=0
                fi
            fi
            if [ ${need_rebuild} -eq 1 ]; then
                echo "Building libdb_cxx..."
                cd ${platform_src_dir}/db-4.8.30.NC/build_unix/ || exit_error "Failed to chainge to db-4.8.30.NC/build_unix/ dir"
                sh ../dist/configure --host=i586-mingw32msvc --enable-cxx --enable-mingw || exit_error "configure failed"
                make || exit_error "make failed"
                if [ ! -f ${platform_src_dir}/db-4.8.30.NC/build_unix/libdb_cxx.a ]; then
                    exit_error "UNABLE TO FIND generated libdb_cxx.a"
                fi
            fi

            # miniupnpc
            need_rebuild=1
            if [ -f ${platform_src_dir}/miniupnpc-1.6/libminiupnpc.a ]; then
                echo "libminiupnpc.a already built, checking its oldness..."
                last_mtime=`stat -c "%Z" ${platform_src_dir}/miniupnpc-1.6/libminiupnpc.a`
                now_time=`date +"%s"`
                let now_time=now_time-6048000
                if [ ${last_mtime} -gt ${now_time} ]; then
                    echo "libminiupnpc.a generated less than 70 days ago, not rebuilding..."
                    need_rebuild=0
                fi
            fi
            if [ ${need_rebuild} -eq 1 ]; then
                echo "Building miniupnpc..."
                cd ${platform_src_dir}/miniupnpc-1.6/ || exit_error "Failed to change to miniupnpc-1.6/ dir"
                sed -i 's/CC = gcc/CC = i586-mingw32msvc-gcc/' Makefile.mingw
#                sed -i 's/wingenminiupnpcstrings \$/wine \.\/wingenminiupnpcstrings \$/' Makefile.mingw
                sed -i '/\twingenminiupnpcstrings $< $@/d' Makefile.mingw
                echo "#ifndef __MINIUPNPCSTRINGS_H__" > miniupnpcstrings.h
                echo "#define __MINIUPNPCSTRINGS_H__" >> miniupnpcstrings.h
                echo "#define OS_STRING \"MSWindows/5.1.2600\"" >> miniupnpcstrings.h
                echo "#define MINIUPNPC_VERSION_STRING \"1.6\"" >> miniupnpcstrings.h
                echo "#endif" >> miniupnpcstrings.h
                
                sed -i 's/\tdllwrap/\ti586-mingw32msvc-dllwrap/' Makefile.mingw
                sed -i 's/driver-name gcc/driver-name i586-mingw32msvc-gcc/' Makefile.mingw
                AR=i586-mingw32msvc-ar make -f Makefile.mingw
                if [ ! -f ${platform_src_dir}/miniupnpc-1.6/libminiupnpc.a ]; then
                    exit_error "UNABLE TO FIND generated libminiupnpc.a"
                fi
            fi
            [ -h ${platform_src_dir}/miniupnpc ] || ln -s ${platform_src_dir}/miniupnpc-1.6 ${platform_src_dir}/miniupnpc
            
            # boost
            need_rebuild=1
            if [ -f ${platform_src_dir}/boost_1_50_0/stage/lib/libboost_system-mt.a ]; then
                echo "libboost_system-mt.a already built, checking its oldness..."
                last_mtime=`stat -c "%Z" ${platform_src_dir}/boost_1_50_0/stage/lib/libboost_system-mt.a`
                now_time=`date +"%s"`
                let now_time=now_time-6048000
                if [ ${last_mtime} -gt ${now_time} ]; then
                    echo "libboost_system-mt.a generated less than 70 days ago, not rebuilding..."
                    need_rebuild=0
                fi
            fi
            if [ ${need_rebuild} -eq 1 ]; then
                echo "Building boost..."
                cd ${platform_src_dir}/boost_1_50_0/ || exit_error "Failed to change to boost_1_50_0/ dir"
                ./bootstrap.sh --without-icu || exit_error "bootstrap failed"
                echo "using gcc : 4.4 : i586-mingw32msvc-g++ : <rc>i586-mingw32msvc-windres <archiver>i586-mingw32msvc-ar ;" > user-config.jam
                ./bjam toolset=gcc target-os=windows variant=release threading=multi threadapi=win32 --user-config=user-config.jam -j 2 --without-mpi --without-python -sNO_BZIP2=1 -sNO_ZLIB=1 --layout=tagged stage
            fi

            # qt
            need_rebuild=1
            if [ -f ${platform_src_dir}/qt/lib/libQtCore.a ]; then
                echo "libQtCore.a already built, checking its oldness..."
                last_mtime=`stat -c "%Z" ${platform_src_dir}/qt/lib/libQtCore.a`
                now_time=`date +"%s"`
                let now_time=now_time-6048000
                if [ ${last_mtime} -gt ${now_time} ]; then
                    echo "libQtCore.a generated less than 70 days ago, not rebuilding..."
                    need_rebuild=0
                fi
            fi

            if [ ${need_rebuild} -eq 1 ]; then
                echo "Building qt..."
                cd ${platform_src_dir}/qt-everywhere-opensource-src-4.8.3/ || exit_error "Failed to change to qt source dir"
                sed 's/$TODAY/2011-01-30/' -i configure
                sed 's/i686-pc-mingw32-/i586-mingw32msvc-/' -i mkspecs/unsupported/win32-g++-cross/qmake.conf
                sed --posix 's|QMAKE_CFLAGS\t\t= -pipe|QMAKE_CFLAGS\t\t= -pipe -isystem /usr/i586-mingw32msvc/include/ -frandom-seed=qtbuild|' -i mkspecs/unsupported/win32-g++-cross/qmake.conf
                sed 's/QMAKE_CXXFLAGS_EXCEPTIONS_ON = -fexceptions -mthreads/QMAKE_CXXFLAGS_EXCEPTIONS_ON = -fexceptions/' -i mkspecs/unsupported/win32-g++-cross/qmake.conf
                sed 's/QMAKE_LFLAGS_EXCEPTIONS_ON = -mthreads/QMAKE_LFLAGS_EXCEPTIONS_ON = -lmingwthrd/' -i mkspecs/unsupported/win32-g++-cross/qmake.conf
                sed --posix 's/QMAKE_MOC\t\t= i586-mingw32msvc-moc/QMAKE_MOC\t\t= moc/' -i mkspecs/unsupported/win32-g++-cross/qmake.conf
                sed --posix 's/QMAKE_RCC\t\t= i586-mingw32msvc-rcc/QMAKE_RCC\t\t= rcc/' -i mkspecs/unsupported/win32-g++-cross/qmake.conf
                sed --posix 's/QMAKE_UIC\t\t= i586-mingw32msvc-uic/QMAKE_UIC\t\t= uic/' -i mkspecs/unsupported/win32-g++-cross/qmake.conf

                [ -d ${platform_src_dir}/qt ] || mkdir ${platform_src_dir}/qt
                ./configure -prefix ${platform_src_dir}/qt -confirm-license -release -opensource -static -no-qt3support -xplatform unsupported/win32-g++-cross -no-multimedia -no-audio-backend -no-phonon -no-phonon-backend -no-declarative -no-script -no-scripttools -no-javascript-jit -no-webkit -no-svg -no-xmlpatterns -no-sql-sqlite -no-nis -no-cups -no-dbus -no-gif -no-libtiff -no-opengl -nomake examples -nomake demos -nomake docs -no-feature-style-plastique -no-feature-style-cleanlooks -no-feature-style-motif -no-feature-style-cde -no-feature-style-windowsce -no-feature-style-windowsmobile -no-feature-style-s60 || exit_error "configure failed"
                make || exit_error "make failed"
                make install || exit_error "make install failed"


            fi

        ;;

        *)
            exit_error "Not Yet Implemented"
        ;;
    esac

done