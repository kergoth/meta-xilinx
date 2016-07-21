COMPATIBLE_MACHINE = "(zynqmp|zcu102-zynqmp-mel)"

DEPENDS += "u-boot-mkimage-native"

do_deploy_append_zynqmp() {
	mkimage -A arm64 -O linux -T kernel -C none -a 0xfffe5000 -e 0xfffe5000 -d ${S}/build/${PLATFORM}/release/bl31.bin ${DEPLOYDIR}/atf.ub
}
