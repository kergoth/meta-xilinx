FILESEXTRAPATHS_prepend_zcu102-zynqmp-mel := "${THISDIR}/files/zcu102-zynqmp-mel:"
FILESEXTRAPATHS_prepend_zynqmp := "${THISDIR}/u-boot-xlnx-dev:"

SRCREV_zynqmp = "20fd28dcadb5c98e0671ae12a49acd4502517d86"

SPL_BINARY = "boot.bin"

SRC_URI_append += " \
    file://uEnv.txt \
    file://0001-ARM64-zynqmp-fix-SD-autoboot.patch \
    file://u-boot-spl_enable_debug_in_SD_boot_mode.patch \
    file://0001-xilinx_zynqmp_zcu102.h-allow-storing-u-boot-env-in-m.patch \
"

do_compile_append_zynqmp() {
	cp ${WORKDIR}/build/spl/boot.bin ${WORKDIR}/build/boot.bin
}

do_deploy_append () {
	if [ -e ${WORKDIR}/uEnv.txt ]; then
		cp ${WORKDIR}/uEnv.txt ${DEPLOYDIR}
	fi
}
