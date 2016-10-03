FILESEXTRAPATHS_prepend := "${THISDIR}/files:${@os.path.dirname(bb.utils.which(BBPATH, 'files/lttng.cfg') or '')}:"

SRC_URI_append = " \
    file://lttng.cfg \
    file://enable_tracing.cfg \
    file://enable_quota.cfg \
    file://enable_squashfs.cfg \
    file://systemd.cfg \
    file://enable_kgboc.cfg \
    file://0001-Makefile-Link-kgdoc-after-the-UART-driver.patch \
    file://enable_nfs_server.cfg \
    file://lttng_backtrace_fix.cfg \
    file://enable_debug_info.cfg \
    file://0001-kernel-module-change-the-optimization-level-of-load_.patch \
    file://0002-kernel-module.c-Remove-optimization-for-complete_for.patch \
"

SRC_URI_append_zynq = " \
    ${@bb.utils.contains("MACHINE_FEATURES", "hdmi", "file://xilinx_zynq_base_trd.cfg", "", d)} \
"

SRC_URI_append_zedboard = " \
    file://0001-usb-chipidea-host.c-fix-zedboard-host-mode.patch \
    ${@bb.utils.contains("MACHINE_FEATURES", "hdmi", "file://0001-port-ADI-HDMI-support-from-3.17-linux-adi-kernel.patch", "", d)} \
    ${@bb.utils.contains("MACHINE_FEATURES", "hdmi", "file://0002-port-ADI-HDMI-support-from-3.17-linux-adi-kernel.patch", "", d)} \
    ${@bb.utils.contains("MACHINE_FEATURES", "hdmi", "file://0003-port-ADI-HDMI-support-from-3.17-linux-adi-kernel.patch", "", d)} \
    ${@bb.utils.contains("MACHINE_FEATURES", "hdmi", "file://enable_adv7511_hdmi.cfg", "", d)} \
"

SRC_URI_append_zc702 = " \
    ${@bb.utils.contains("MACHINE_FEATURES", "hdmi", "file://0001-xylon-drm-driver-add-implementation-of-set_busid.patch", "", d)} \
"

SRCREV_zynqmp = "xilinx-v2016.2"

do_deploy_append() {
    if [ "${MACHINE}" = "zcu102-zynqmp-mel" ]
    then
        ln -sf ${KERNEL_IMAGETYPE}-zynqmp-zcu102-revB.dtb ${DEPLOYDIR}/system.dtb
    fi
}
