# This recipe swaps in the ADI kernel tree rather than the upstream Xilinx tree.
# It is intended to be used specifically in scenarios where the ADI tree leads
# the Xilinx tree and where you intend to use the ADI IP bitstream from either
# your bootloader or /dev/xdevcfg to configure the PL on a Xilinx target.
# Currently only applicable to the Zedboard.
#
# To enable this recipe, set the following in your local.conf:
#
# PREFERRED_PROVIDER_virtual/kernel = "linux-adi"
#
FILESEXTRAPATHS_prepend := "${THISDIR}/files:${@os.path.dirname(bb.utils.which(BBPATH, 'files/lttng.cfg') or '')}:"
inherit kernel
require recipes-kernel/linux/linux-yocto.inc

DESCRIPTION = "Analog Devices Kernel"

KBRANCH = "xcomm_zynq"

FILESEXTRAPATHS_prepend := "${THISDIR}/config:"

SRC_URI = " \
           git://github.com/analogdevicesinc/linux.git;protocol=https;branch=${KBRANCH};name=linux-adi \
           file://zedboard-zynq7-adi-hdmi.cfg \
           file://lttng.cfg \
           file://enable_nfs_client_support.cfg \
           file://enable_quota.cfg \
           file://enable_squashfs.cfg \
           file://unionfs-2.6_for_3.17.0-rc1.patch \
           file://enable_unionfs.cfg \
          "

LINUX_VERSION ?= "3.17+"
LINUX_VERSION_EXTENSION ?= "-adi"

SRCREV_zynq="845d349f6e18ca34361c1320f5cb9ffde024b61b"

PV = "${LINUX_VERSION}${LINUX_VERSION_EXTENSION}+git${SRCPV}"

COMPATIBLE_MACHINE_zynq = "zynq"
KMACHINE_zynq ?= "zynq"

python __anonymous() {
    if d.getVar("MACHINE", True) != "zedboard-zynq7-mel":
        bb.warn("kernel provider 'linux-adi' is ONLY supported for MACHINE=zedboard-zynq7-mel")
}
