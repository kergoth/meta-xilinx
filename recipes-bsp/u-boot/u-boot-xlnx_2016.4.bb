include u-boot-xlnx.inc
include u-boot-spl-zynq-init.inc

XILINX_RELEASE_VERSION = "v2016.4"
SRCREV = "0b94ce5ed4a6c2cd0fec7b8337e776b03e387347"
PV = "v2016.07-xilinx-${XILINX_RELEASE_VERSION}+git${SRCPV}"

SRC_URI_append = " \
		file://0001-fdt-add-memory-bank-decoding-functions-for-board-set.patch \
		file://0002-ARM-zynq-Replace-board-specific-with-generic-memory-.patch \
		file://0003-ARM64-zynqmp-Replace-board-specific-with-generic-mem.patch \
		file://arm-zynqmp-xilinx_zynqmp.h-Auto-boot-in-JTAG-if-imag.patch \
		"

SRC_URI_append_kc705-microblazeel = " file://microblaze-kc705-Convert-microblaze-generic-to-k.patch"

LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://README;beginline=1;endline=6;md5=157ab8408beab40cd8ce1dc69f702a6c"

# u-boot 2016.07 has support for these
HAS_PLATFORM_INIT ?= " \
		zynq_microzed_config \
		zynq_zed_config \
		zynq_zc702_config \
		zynq_zc706_config \
		zynq_zybo_config \
		xilinx_zynqmp_zcu102_config \
		"

