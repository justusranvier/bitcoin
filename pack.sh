#!/bin/bash
#
# Copyright (c) 2013 giv
#

cd release

if [ -f bitcoin-qt ]; then
	if [ -f bitcoind ]; then
		tar -cjvf btci2p-linux64.tar.bz2 bitcoin-qt bitcoind
		
		MD5linux=`md5sum -b btci2p-linux64.tar.bz2`
		SHA1linux=`sha1sum -b btci2p-linux64.tar.bz2`

		echo -n "MD5: "   > btci2p-linux64.sum; echo "$MD5linux"  >> btci2p-linux64.sum
		echo -n "SHA1: " >> btci2p-linux64.sum; echo "$SHA1linux" >> btci2p-linux64.sum
		
		gpg --output btci2p-linux64.sig --detach-sig btci2p-linux64.tar.bz2
	else
		echo "bitcoind is not found."
	fi
else
	echo "bitcoin-qt is not found."
fi

if [ -f bitcoin-qt.exe ]; then
	if [ -f bitcoind.exe ]; then
		zip -v -9 btci2p-win32.zip bitcoin-qt.exe bitcoind.exe
		
		MD5win=`md5sum -b btci2p-win32.zip`
		SHA1win=`sha1sum -b btci2p-win32.zip`

		echo -n "MD5: "   > btci2p-win32.sum; echo "$MD5win"  >> btci2p-win32.sum
		echo -n "SHA1: " >> btci2p-win32.sum; echo "$SHA1win" >> btci2p-win32.sum
		
		gpg --output btci2p-win32.sig --detach-sig btci2p-win32.zip
	else
		echo "bitcoind.exe is not found."
	fi
else
	echo "bitcoin-qt.exe is not found."
fi
