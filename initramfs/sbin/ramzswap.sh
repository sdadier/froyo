#!/sbin/busybox sh

insmod /lib/modules/ramzswap.ko

/sbin/rzscontrol /dev/block/ramzswap0 --init
/sbin/swapon /dev/block/ramzswap0



