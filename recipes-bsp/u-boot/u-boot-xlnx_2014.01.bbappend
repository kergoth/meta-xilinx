FILESEXTRAPATHS_prepend_zc702 := "${THISDIR}/files/zc702-zynq7-mel:"
FILESEXTRAPATHS_prepend_zedboard := "${THISDIR}/files/zedboard-zynq7-mel:"

SRC_URI_append += " \
    file://ps7_init.h \
    file://ps7_init.c \
    file://uEnv.txt \
"

do_configure_prepend () {
	cp ${WORKDIR}/ps7_init.h ${S}/board/xilinx/zynq/
	cp ${WORKDIR}/ps7_init.c ${S}/board/xilinx/zynq/
}

do_deploy_append () {
	if [ -e ${WORKDIR}/uEnv.txt ]; then
		cp ${WORKDIR}/uEnv.txt ${DEPLOYDIR}
	fi
	if [ -e ${WORKDIR}/fpga.bin ]; then
		cp ${WORKDIR}/fpga.bin ${DEPLOYDIR}
	fi
	if [ -e ${WORKDIR}/git/boot.bin ]; then
		cp ${WORKDIR}/git/boot.bin ${DEPLOYDIR}
	fi
}
