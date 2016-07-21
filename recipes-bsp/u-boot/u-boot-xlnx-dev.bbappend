SRCREV_zynqmp = "20fd28dcadb5c98e0671ae12a49acd4502517d86"

UBOOT_SUFFIX_zynqmp = "img"
SPL_BINARY = "boot.bin"

do_compile_append() {
       cp ${WORKDIR}/git/spl/boot.bin ${WORKDIR}/git/boot.bin
}
