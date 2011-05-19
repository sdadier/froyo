# bcm4329
DHDCFLAGS = -O3 -Dlinux -DLINUX -DBDC -DBCMDRIVER -DBCMDONGLEHOST -DDHDTHREAD -DBCMWPA2 \
    -DDHD_GPL -DBCMSDIO -DBCMLXSDMMC -DBCMPLATFORM_BUS -DDHD_BCMEVENTS      \
    -DSHOW_EVENTS -DANDROID_SPECIFIC -DENABLE_DEEP_SLEEP -DCUSTOMER_HW_SAMSUNG -DREAD_MACADDR -DSDIO_ISR_THREAD -DBCM_HOSTWAKE -Wall -Wstrict-prototypes  \
	-Idrivers/net/wireless/bcm4329 -Idrivers/net/wireless/bcm4329/include

#  -DTOE -DDHD_SCHED -DMMC_SDIO_FORCE_PULLUP    -DBCMWAPI_WPI  -DARP_OFFLOAD_SUPPORT -DPKT_FILTER_SUPPORT 

DHDOFILES = dhd_linux.o \
         dhd_common.o \
         dhd_cdc.o \
         dhd_linux_sched.o\
         dhd_sdio.o \
         dhd_custom_gpio.o \
         aiutils.o \
         bcmutils.o \
         bcmwifi.o \
         hndpmu.o \
         linux_osl.o \
         sbutils.o \
         siutils.o \
         bcmsdh_sdmmc.o \
         bcmsdh.o \
         bcmsdh_linux.o \
         bcmsdh_sdmmc_linux.o \
         wlgpio.o \
         wl_iw.o

obj-$(CONFIG_BCM4329) += dhd.o
dhd-objs += $(DHDOFILES)
EXTRA_CFLAGS = $(DHDCFLAGS)
EXTRA_LDFLAGS += --strip-debug 
