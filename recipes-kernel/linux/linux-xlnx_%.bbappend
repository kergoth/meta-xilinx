FILESEXTRAPATHS_prepend := "${THISDIR}/files:${@os.path.dirname(bb.utils.which(BBPATH, 'files/lttng.cfg') or '')}:"

SRC_URI_append = " \
    ${@bb.utils.contains("MACHINE_FEATURES", "hdmi", "file://xilinx_zynq_base_trd.cfg", "", d)} \
    file://lttng.cfg \
    file://unionfs-2.6_for_3.17.0-rc1.patch \    
    file://enable_quota.cfg \
    file://enable_squashfs.cfg \
    file://enable_unionfs.cfg \
    file://systemd.cfg \
    file://enable_kgboc.cfg \
    file://0001-Makefile-Link-kgdoc-after-the-UART-driver.patch \
"

SRC_URI_append_zedboard = " \
    file://0001-port-ADI-HDMI-support-from-3.17-linux-adi-kernel.patch \
    file://0002-port-ADI-HDMI-support-from-3.17-linux-adi-kernel.patch \
    file://0003-port-ADI-HDMI-support-from-3.17-linux-adi-kernel.patch \
    file://enable_adv7511_hdmi.cfg \
"

