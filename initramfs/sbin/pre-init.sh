#!/sbin/busybox sh
# Copyright 2010 Renaud Allard. All rights reserved.
#
# Ported to Samsung GT-I5800 by Sebastien Dadier - s.dadier@gmail.com (03/16/2011)
#
# Redistribution and use in source and binary forms, with or without modification, are
# permitted provided that the following conditions are met:
#
#    1. Redistributions of source code must retain the above copyright notice, this list of
#       conditions and the following disclaimer.
#
#    2. Redistributions in binary form must reproduce the above copyright notice, this list
#       of conditions and the following disclaimer in the documentation and/or other materials
#       provided with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY Renaud Allard ``AS IS'' AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
# FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Renaud Allard OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# The views and conclusions contained in the software and documentation are those of the
# authors and should not be interpreted as representing official policies, either expressed
# or implied, of Renaud Allard.

VERSION=2.4.beta2
FUGUDIR=/fugumod_sd/Android/data/fugumod

DATA2SD=

build_fs_current()
{
	echo 'DO NOT MODIFY THIS FILE, YOUR SYSTEM WOULD NOT BE ABLE TO BOOT' > $FUGUDIR/fs.current
	mkdir /fugu_mnt
	for DEVICE in mmcblk0p2 stl6 stl7 stl8
	do
		mount -o ro /dev/block/${DEVICE} /fugu_mnt
		mount | awk '/\/fugu_mnt/ { print $1 " " $5 }' | awk -F "/" '{ print $4 }' | sed 's/vfat/rfs/' >> $FUGUDIR/fs.current
		umount /fugu_mnt
	done
	rmdir /fugu_mnt
}


set_mount_options()
{
case $STL6_FS in
	jfs)
	STL6_MNT=',noatime,iocharset=utf8'
	;;
	ext4)
	STL6_MNT=',noatime,data=writeback,noauto_da_alloc,barrier=0,commit=20'
	;;
	ext2)
	STL6_MNT=''
	;;
	ext3)
	STL6_MNT=''
	;;
	reiserfs)
	STL6_MNT=',noatime,notail'
	;;
	rfs)
	STL6_MNT=',noatime,check=no'
	;;
esac
case $STL7_FS in
	jfs)
	STL7_MNT=',noatime,iocharset=utf8'
	;;
	ext4)
	STL7_MNT=',noatime,nodelalloc,data=ordered,noauto_da_alloc,barrier=0,commit=20'
	;;
	ext2)
	STL7_MNT=''
	;;
	ext3)
	STL7_MNT=''
	;;
	reiserfs)
	STL7_MNT=',noatime,notail'
	;;
	tmpfs)
	STL7_MNT=',size=200m'
	;;
	rfs)
	STL7_MNT=',noatime,check=no'
	;;
esac
case $STL8_FS in
	jfs)
	STL8_MNT=',noatime,iocharset=utf8'
	;;
	ext4)
	STL8_MNT=',noatime,data=writeback,noauto_da_alloc,barrier=0,commit=20'
	;;
	ext2)
	STL8_MNT=''
	;;
	ext3)
	STL8_MNT=''
	;;
	reiserfs)
	STL8_MNT=',noatime,notail'
	;;
	tmpfs)
	STL8_MNT=',size=32m'
	;;
	rfs)
	STL8_MNT=',noatime,check=no'
	;;
esac
case $MMC_FS in
	jfs)
	MMC_MNT=',noatime,iocharset=utf8'
	;;
	ext4)
	MMC_MNT=',noatime,data=ordered,noauto_da_alloc,barrier=1,commit=20'
	;;
	ext2)
	MMC_MNT=''
	;;
	ext3)
	MMC_MNT=''
	;;
	reiserfs)
	MMC_MNT=',noatime,notail'
	;;
	btrfs)
	MMC_MNT=',nodatacow,compress,ssd'
	;;
	tmpfs)
	MMC_MNT=',size=200m'
	;;
	rfs)
	MMC_MNT=',noatime,check=no'
	;;
esac
}

get_filesystems() {
	STL6_FS=`grep stl6 $FUGUDIR/fs.current | awk '{ print $2 }'`
	STL7_FS=`grep stl7 $FUGUDIR/fs.current | awk '{ print $2 }'`
	STL8_FS=`grep stl8 $FUGUDIR/fs.current | awk '{ print $2 }'`
	MMC_FS=`grep mmcblk0p2 $FUGUDIR/fs.current | awk '{ print $2 }'`
}

echo "Fugumod - GT-I5800 version : " $VERSION

export PATH=/sbin:/system/sbin:/system/bin:/system/xbin
export LD_LIBRARY_PATH=/system/lib
export ANDROID_BOOTLOGO=1
export ANDROID_ROOT=/system
export ANDROID_ASSETS=/system/app
export ANDROID_DATA=/data
export EXTERNAL_STORAGE=/mnt/sdcard
export ASEC_MOUNTPOINT=/mnt/asec
export BOOTCLASSPATH=/system/framework/core.jar:/system/framework/ext.jar:/system/framework/framework.jar:/system/framework/android.policy.jar:/system/framework/services.jar

export TMPDIR=/data/local/tmp

/sbin/busybox sh /sbin/initbbox.sh

uname -a

insmod /lib/modules/fsr.ko
insmod /lib/modules/fsr_stl.ko

mkdir /proc
mkdir /sys

mount -t proc proc /proc
mount -t sysfs sys /sys

# standard
mkdir /dev
mknod /dev/null c 1 3
mknod /dev/zero c 1 5
mknod /dev/urandom c 1 9

# internal & external SD
mkdir /dev/block
mknod /dev/block/mmcblk0 b 179 0
mknod /dev/block/mmcblk0p1 b 179 1
mknod /dev/block/mmcblk0p2 b 179 2
mknod /dev/block/mmcblk0p3 b 179 3
mknod /dev/block/mmcblk0p4 b 179 4
mknod /dev/block/mmcblk1 b 179 8
mknod /dev/block/stl1 b 138 1
mknod /dev/block/stl2 b 138 2
mknod /dev/block/stl3 b 138 3
mknod /dev/block/stl4 b 138 4
mknod /dev/block/stl5 b 138 5
mknod /dev/block/stl6 b 138 6
mknod /dev/block/stl7 b 138 7
mknod /dev/block/stl8 b 138 8
mknod /dev/block/stl9 b 138 9
mknod /dev/block/stl10 b 138 10
mknod /dev/block/stl11 b 138 11
mknod /dev/block/stl12 b 138 12
mknod /dev/block/bml0!c b 137 0
mknod /dev/block/bml1 b 137 1
mknod /dev/block/bml2 b 137 2
mknod /dev/block/bml3 b 137 3
mknod /dev/block/bml4 b 137 4
mknod /dev/block/bml5 b 137 5
mknod /dev/block/bml6 b 137 6
mknod /dev/block/bml7 b 137 7
mknod /dev/block/bml8 b 137 8
mknod /dev/block/bml9 b 137 9
mknod /dev/block/bml10 b 137 10
mknod /dev/block/bml11 b 137 11
mknod /dev/block/bml12 b 137 12

insmod /lib/modules/param.ko
# insmod /lib/modules/logger.ko

mkdir /system

# Mounting sdcard on fugumod_sd
mkdir /fugumod_sd
mount -t vfat -o utf8 /dev/block/mmcblk0p1 /fugumod_sd

# Check if conf directory exists, if not create one
if ! test -d $FUGUDIR
then

	rm -rf $FUGUDIR
	mkdir -p $FUGUDIR

	# Check if there is an old fs.current
	if test -f /fugumod_sd/fugumod/fs.current
	then
		mv /fugumod_sd/fugumod/fs.current $FUGUDIR/fs.current
	fi
	if test -f /fugumod_sd/fugumod/fs.convert
	then
		mv /fugumod_sd/fugumod/fs.convert $FUGUDIR/fs.convert
	fi
	if test -f /fugumod_sd/fugumod/fs.options
	then
		mv /fugumod_sd/fugumod/fs.options $FUGUDIR/fs.options
	fi
	rm -rf /fugumod_sd/fugumod

	sync

fi


# if mounting system fails this will allow adb to run
mkdir /system/bin

echo "Build fs_current"
build_fs_current

insmod /rfs/rfs_glue.ko
insmod /rfs/rfs_fat.ko

echo "fsck filesystems"
for DEVICE in stl7 stl8 stl6 mmcblk0p2 
do
	case `grep ${DEVICE} $FUGUDIR/fs.current | awk '{ print $2 }'` in
jfs)
	/sbin/jfs_fsck -p /dev/block/${DEVICE}
;;
ext*)
	/sbin/e2fsck -p /dev/block/${DEVICE}
;;
reiserfs)
	echo /sbin/reiserfsck /dev/block/${DEVICE}
;;
btrfs)
	/sbin/btrfsck /dev/block/${DEVICE}
;;
	esac
done

umount /sdcard /cache /system /data

#fsck filesystems
for DEVICE in mmcblk0p2 stl6 stl7 stl8
do
	echo "Checking ${DEVICE}" >>/fugumod.log
	case `grep ${DEVICE} $FUGUDIR/fs.current | awk '{ print $2 }'` in
	jfs)
	/sbin/jfs_fsck -p /dev/block/${DEVICE} >>/fugumod.log 2>>/fugumod.log
	;;
	ext*)
	/sbin/e2fsck -p /dev/block/${DEVICE} >>/fugumod.log 2>>/fugumod.log
	;;
	reiserfs)
	echo "reiserfs, not checking" >>/fugumod.log 2>>/fugumod.log
	;;
	btrfs)
	/sbin/btrfsck /dev/block/${DEVICE} >>/fugumod.log 2>>/fugumod.log
	;;
	rfs)
	echo "rfs, not checking" >>/fugumod.log 2>>/fugumod.log
	;;
	esac
done

rm /fugumod_sd/fugumod_data.tar

if test -f $FUGUDIR/fs.data2sd
then
  DATA2SD=mmcblk0p2
else
  DATA2SD=stl7
fi

#check if we need to convert something (from sanitized output)
if test -f $FUGUDIR/fs.convert
then
	mkdir /fugumod_data
	egrep "stl|mmc" $FUGUDIR/fs.convert | tr '\011' ' ' | sed 's/ */ /g' | sed 's/^ *//g' | awk '{ print $1 " " $2 }' | while read DEVICE NEW_FS
	do
		CUR_FS=`grep ${DEVICE} $FUGUDIR/fs.current | awk '{ print $2 }'`
		if [ "${CUR_FS}" != "${NEW_FS}" ]
		then
			echo "$DEVICE is in $CUR_FS and needs to be converted to $NEW_FS" >> /fugumod.log
			case ${NEW_FS} in
			jfs)
			MKFS='/sbin/jfs_mkfs -q '
			;;
			ext4)
			MKFS='/sbin/mke2fs -J size=4 -T ext4 -b 4096 -O ^resize_inode,^ext_attr,^huge_file '
			;;
			ext3)
			MKFS='/sbin/mke2fs -J size=4 -T ext3 -b 4096 -O ^resize_inode,^ext_attr,^huge_file '
			;;
			ext2)
			MKFS='/sbin/mke2fs -T ext2 -b 4096 -O ^resize_inode,^ext_attr,^huge_file '
			;;
			reiserfs)
			MKFS='/sbin/mkreiserfs -q -b 4096 -s 1000 '
			;;
			btrfs)
			MKFS='/sbin/mkfs.btrfs -d single '
			;;
			rfs)
			MKFS='/sbin/fat.format '
			;;
			esac
			if [ "${CUR_FS}" == "rfs" ]
			then
				mount -t ${CUR_FS} -o ro,check=no /dev/block/${DEVICE} /fugumod_data 2>>/fugumod.log
			else
				mount -t ${CUR_FS} -o ro /dev/block/${DEVICE} /fugumod_data 2>>/fugumod.log
			fi
			echo "`date` : archiving ${DEVICE} for conversion" >>/fugumod.log
			mount |grep fugumod >>/fugumod.log
			cd /fugumod_data/
			tar cvf /fugumod_sd/fugumod_data.tar * >>/fugumod.log 2>>/fugumod.log
			cd /
			sync
			umount /dev/block/${DEVICE}
			echo "`date` : formatting ${DEVICE} for conversion" >>/fugumod.log			
			dd if=/dev/zero of=/dev/block/${DEVICE} bs=1024 count=10
			${MKFS} /dev/block/${DEVICE} >> /fugumod.log 2>> /fugumod.log
			if [ "${NEW_FS}" == "rfs" ]
			then
				mount -t ${NEW_FS} -o rw,noatime,nodiratime,check=no /dev/block/${DEVICE} /fugumod_data
			else
				mount -t ${NEW_FS} -o rw,noatime,nodiratime /dev/block/${DEVICE} /fugumod_data
			fi
			echo "`date` : unarchiving ${DEVICE}" >>/fugumod.log
			cd /fugumod_data/
			tar xvf /fugumod_sd/fugumod_data.tar >>/fugumod.log 2>>/fugumod.log
			cd /
			sync
			umount /dev/block/${DEVICE}
		fi
	done
	rm $FUGUDIR/fs.convert
	rmdir /fugumod_data
	#regenerate a fs.current
	build_fs_current
	rm /fugumod_sd/fugumod_data.tar
fi
#/sbin/mkfs.btrfs -d single /dev/block/mmcblk0p2

if test -f $FUGUDIR/fs.tmpfs
then
	for DEVICE in mmcblk0p2 stl7 stl8 
	do
		sed -i "s/$DEVICE.*/$DEVICE tmpfs/" $FUGUDIR/fs.current
	done
	rm  /fugumod_sd/Android/data/fugumod/fs.tmpfs
fi

if test -f $FUGUDIR/android.logger
then
   insmod /lib/modules/logger.ko
fi

# get filesystems
get_filesystems

if test -f $FUGUDIR/fs.options
then
	STL6_MNT=",`grep stl6 $FUGUDIR/fs.options | awk '{ print $2 }'`"
	STL7_MNT=",`grep stl7 $FUGUDIR/fs.options | awk '{ print $2 }'`"
	STL8_MNT=",`grep stl8 $FUGUDIR/fs.options | awk '{ print $2 }'`"
	MMC_MNT=",`grep mmcblk0p2 $FUGUDIR/fs.options | awk '{ print $2 }'`"
else
	set_mount_options
fi
	
echo "STL6 :" $STL6_FS
echo "STL7 :" $STL7_FS
echo "STL8 :" $STL8_FS
echo "MMC : " $MMC_FS

rm -rf /etc
sync
cd /

# modify mount options to inject in android inits
STL6_MNT=`echo ${STL6_MNT} | sed 's/\,/ /g'`
STL7_MNT=`echo ${STL7_MNT} | sed 's/\,/ /g'`
STL8_MNT=`echo ${STL8_MNT} | sed 's/\,/ /g'`
MMC_MNT=`echo ${MMC_MNT} | sed 's/\,/ /g'`

# Inline inject mountpoints
sed -i "s|fugu_mount_stl6|mount ${STL6_FS} /dev/block/stl6 /system nodev noatime nodiratime ro ${STL6_MNT}|" /init.rc
sed -i "s|fugu_mount_stl6|mount ${STL6_FS} /dev/block/stl6 /system nodev noatime nodiratime rw ${STL6_MNT}|" /recovery.rc
sed -i "s|fugu_mount_stl8|mount ${STL8_FS} /dev/block/stl8 /cache sync noexec noatime nodiratime nosuid nodev rw ${STL8_MNT}|" /init.rc /recovery.rc

if [ "$DATA2SD" == "stl7" ]
then
  sed -i "s|fugu_mount_stl7|mount ${STL7_FS} /dev/block/stl7 /data noatime nodiratime nosuid nodev rw ${STL7_MNT}|" /init.rc /recovery.rc
else
  sed -i "s|fugu_mount_stl7|mount ${MMC_FS} /dev/block/mmcblk0p2 /data noatime nodiratime nosuid nodev rw|" /init.rc /recovery.rc
fi

cd /

umount /fugumod_sd

rmdir /fugumod_sd

exec /init_samsung


