#!/bin/bash

## capture VCSA iso filename
REGEX="^VMware-VCSA.*iso$"
for FILE in *; do
	if [[ $FILE =~ $REGEX ]]; then
		echo ${FILE}
		break
	fi
done

## set vcsa directory name
BASEDIR="${PWD}"
VCSADIR="${PWD}/vcsa"
echo "ISO: "$FILE

# check for old directories and remove
regex="vcsa"
for DIR in ${BASEDIR}/*; do
	if [[ -d "$DIR" && ! -L "$DIR" ]]; then
		if [[ $DIR =~ $REGEX ]]; then
			echo "UMOUNT & DELETE: "$DIR
			umount $DIR
			rm -rf $DIR
		fi
	fi
done

# create and mount new directory
echo "CREATE & MOUNT: "$VCSADIR $FILE
mkdir -p $VCSADIR
mount -o loop,ro $FILE $VCSADIR

$VCSADIR/vcsa-cli-installer/lin64/vcsa-deploy install -v --no-ssl-certificate-verification $BASEDIR/vcsa.json --accept-eula
#$VCSADIR/vcsa-cli-installer/lin64/vcsa-deploy install -v --no-ssl-certificate-verification $BASEDIR/vcsa.json --accept-eula --precheck-only
#type infrastructure
#umount $vcsadir
