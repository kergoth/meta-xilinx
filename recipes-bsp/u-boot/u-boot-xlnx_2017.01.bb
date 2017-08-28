require recipes-bsp/u-boot/u-boot-xlnx.inc
PROVIDES += "virtual/bootloader"

XILINX_RELEASE_VERSION = "v2017.2"
SRCREV ?= "5290eb544b8659d957d3b8fd2ba890e9575007e4"
PV = "v2017.01-xilinx-${XILINX_RELEASE_VERSION}+git${SRCPV}"

SPL_BINARY = "boot.bin"

LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://README;beginline=1;endline=6;md5=157ab8408beab40cd8ce1dc69f702a6c"

do_compile_append() {
	cp ${WORKDIR}/build/spl/boot.bin ${WORKDIR}/build/boot.bin
}

UBOOT_ENV = "uEnv"
SRC_URI_append = " file://uEnv.txt"
