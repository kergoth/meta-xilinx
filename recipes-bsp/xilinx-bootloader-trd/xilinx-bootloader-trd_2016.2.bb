DESCRIPTION = "A proprietary boot.bin from xilinx TRD containing FPGA support for display and USB peripherals"
SECTION = "bsp"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${WORKDIR}/LICENSE.xilinx;md5=cc7d2eefc042eec125f967de1d4ec39d"

XILINX_EULA_FILE = "${THISDIR}/files/LICENSE.xilinx"

# By default, use the boot.bin generated from u-boot
USE_XILINX_TRD_BOOTLOADER ?= "0"

PACKAGE_ARCH = "${MACHINE_ARCH}"

COMPATIBLE_MACHINE = "(zynqmp|zcu102-zynqmp-mel)"

SRC_URI = "file://boot.bin \
           file://LICENSE.xilinx"

inherit deploy

python do_unpack() {
    eula = d.getVar('ACCEPT_XILINX_EULA', True)
    eula_file = d.getVar('XILINX_EULA_FILE', True)
    pkg = d.getVar('PN', True)
    if eula == None:
        bb.fatal("To use '%s' you need to accept the XILINX EULA at '%s'. "
                 "Please read it and in case you accept it, write: "
                 "ACCEPT_XILINX_EULA = \"1\" in your local.conf." % (pkg, eula_file))
    elif eula == '0':
        bb.fatal("To use '%s' you need to accept the XILINX EULA." % pkg)
    else:
        bb.note("XILINX EULA has been accepted for '%s'" % pkg)

    try:
        bb.build.exec_func('base_do_unpack', d)
    except:
        raise
}

do_install_append() {
	if [ ! -d "${D}/boot" ]; then 
		install -d ${D}/boot
	fi

	cp ${WORKDIR}/boot.bin ${D}/boot/boot.bin
}

do_deploy() {
	if [ "${USE_XILINX_TRD_BOOTLOADER}" == "1" ]; then
		cp ${WORKDIR}/boot.bin ${DEPLOYDIR}/xilinx-bootloader-trd.bin
	else
		bbnote "FPGA support for Display and USB peripherals not enabled."
		bbnote "Set USE_XILINX_TRD_BOOTLOADER to enable it" 
	fi
}

addtask deploy after do_unpack

FILES_${PN} = "boot/boot.bin"
