FILESEXTRAPATHS_prepend := "${THISDIR}/files:${@os.path.dirname(bb.utils.which(BBPATH, 'files/lttng.cfg') or '')}:"

SRC_URI_append = " \
    ${@bb.utils.contains("MACHINE_FEATURES", "hdmi", "file://xilinx_zynq_base_trd.cfg", "", d)} \
    file://lttng.cfg \
    file://unionfs-2.6_for_3.14.17.patch \    
    file://enable_quota.cfg \
    file://enable_squashfs.cfg \
    file://enable_unionfs.cfg \
    file://systemd.cfg \
    file://enable_kgboc.cfg \
    file://0001-Makefile-Link-kgdoc-after-the-UART-driver.patch \
"

