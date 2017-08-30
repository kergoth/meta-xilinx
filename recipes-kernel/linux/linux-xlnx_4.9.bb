LINUX_VERSION = "4.9"
XILINX_RELEASE_VERSION = "v2017.2"
LICENSE = "GPLv2"
SRCREV ?= "5d029fdc257cf88e65500db348eda23040af332b"
require recipes-kernel/linux/linux-xlnx.inc

SRC_URI_append = " \
    file://enable_tracing.cfg \
    file://enable_nfs_server.cfg \
"
