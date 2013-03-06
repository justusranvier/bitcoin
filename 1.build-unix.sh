#!/bin/bash
procParmL()
{ 
   [ -z "$1" ] && return 1 
   if [ "${2#$1=}" != "$2" ] ; then 
      cRes="${2#$1=}" 
      return 0 
   fi 
   return 1 
}

while [ 1 ] ; do 
   if procParmL "--threads" "$1" ; then 
      THREADS="$cRes" 
   elif [ -z "$1" ] ; then 
      break
   else 
      echo "Error: Invalid key" 1>&2 
      exit 1 
   fi 
   shift 
done

if [ "${!THREADS[@]}" ]; then
    JOB_FLAG="-j"
    if [ $THREADS ]; then
        echo "Build using $THREADS threads"
    else
        echo "Build using MAX threads"
    fi
else
    echo "Build using single thread."
fi

mkdir -p release
rm -f release/bitcoin-qt
rm -f release/bitcoind

echo "Building gui client..."
make distclean
make -C bitcoin-qt/src -f makefile.unix clean USE_NATIVE_I2P=1
make -C bitcoin-qt/src -f makefile.linux-mingw clean USE_NATIVE_I2P=1
qmake
make $JOB_FLAG $THREADS

if [ ! -f bitcoin-qt/bitcoin-qt ]; then
    echo "UNABLE TO FIND generated bitcoin-qt"
    exit 1
fi
cp -f bitcoin-qt/bitcoin-qt release

echo "Building headless daemon..."
make distclean
make -C bitcoin-qt/src -f makefile.unix clean USE_NATIVE_I2P=1
make -C bitcoin-qt/src -f makefile.linux-mingw clean USE_NATIVE_I2P=1
make $JOB_FLAG $THREADS -C bitcoin-qt/src -f makefile.unix USE_NATIVE_I2P=1

if [ ! -f bitcoin-qt/src/bitcoind ]; then
    echo "UNABLE TO FIND generated bitcoind"
    exit 1
fi
strip bitcoin-qt/src/bitcoind
cp -f bitcoin-qt/src/bitcoind release