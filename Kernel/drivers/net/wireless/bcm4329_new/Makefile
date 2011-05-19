# bcm4329
DHDCFLAGS = -DLINUX -DBCMDRIVER -DBCMDONGLEHOST -DDHDTHREAD                   \
	-DBCMWPA2 \
	-DDHD_GPL -DBDC-DDHD_BCMEVENTS -DREAD_MACADDR      \
	-DSHOW_EVENTS -DSDIO_ISR_THREAD -DBCMSDIO -DDHD_GPL  -DBCM_HOSTWAKE   \
	-DBCMLXSDMMC -DBCMPLATFORM_BUS -DEMBEDDED_PLATFORM -DOEM_ANDROID      \
	-DCUSTOMER_HW_SAMSUNG \
	-DSOFTAP -Wall -Wstrict-prototypes                                    \
	-Idrivers/net/wireless/bcm4329 -Idrivers/net/wireless/bcm4329/include

#  -DTOE -DDHD_SCHED -DMMC_SDIO_FORCE_PULLUP    -DBCMWAPI_WPI  -DARP_OFFLOAD_SUPPORT -DPKT_FILTER_SUPPORT 

DHDOFILES = dhd_linux.o linux_osl.o bcmutils.o dhd_common.o dhd_custom_gpio.o \
	siutils.o sbutils.o aiutils.o hndpmu.o dhd_linux_sched.o bcmwifi.o    \
	wl_iw.o dhd_cdc.o dhd_sdio.o bcmsdh_sdmmc.o bcmsdh.o bcmsdh_linux.o   \
	bcmsdh_sdmmc_linux.o wlgpio.o

obj-$(CONFIG_BCM4329) += dhd.o
dhd-objs += $(DHDOFILES)
EXTRA_CFLAGS = $(DHDCFLAGS)
EXTRA_LDFLAGS += --strip-debug
