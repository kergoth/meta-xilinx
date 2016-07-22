FILESEXTRAPATHS_prepend_zcu102-zynqmp-mel := "${THISDIR}/files/zcu102-zynqmp-mel:"
SRCREV_zynqmp = "20fd28dcadb5c98e0671ae12a49acd4502517d86"

SPL_BINARY = "boot.bin"

SRC_URI_append += " \
    file://uEnv.txt \
"

do_compile_append_zynqmp() {
	cp ${WORKDIR}/git/spl/boot.bin ${WORKDIR}/git/boot.bin
}

do_deploy_append () {
	if [ -e ${WORKDIR}/uEnv.txt ]; then
		cp ${WORKDIR}/uEnv.txt ${DEPLOYDIR}
	fi
}
