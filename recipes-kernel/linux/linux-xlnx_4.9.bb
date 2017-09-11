LINUX_VERSION = "4.9"
XILINX_RELEASE_VERSION = "v2017.2"
LICENSE = "GPLv2"
SRCREV ?= "5d029fdc257cf88e65500db348eda23040af332b"
require recipes-kernel/linux/linux-xlnx.inc

SRC_URI_append = " \
    file://enable_tracing.cfg \
    file://enable_nfs_server.cfg \
    file://enable_usb_ulpi.cfg \
    file://enable_autofs.cfg \
    file://enable_squashfs.cfg \
    file://enable_quota.cfg \
    file://enable_wlan.cfg \
    file://enable_wlan_generic_devices.cfg \
    file://enable_bluetooth.cfg \
    file://enable_kgboc.cfg \
    file://enable_kgboc_kdb_disable.cfg \
    file://enable_debug_info.cfg \
    file://0001-Makefile-Link-kgdoc-after-the-UART-driver.patch \
"
