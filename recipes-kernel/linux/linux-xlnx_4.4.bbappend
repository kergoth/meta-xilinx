FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

inherit kernel-config-lttng

SRC_URI_append = " \
    file://enable_tracing.cfg \
    file://enable_bluetooth.cfg \
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
    file://arm64_errata_add-mpc-relative-literal-loads-to-build-flags.patch \
    file://enable_audio.cfg \
    file://enable_posix_mqueue.cfg \
    file://fix_build_warning.cfg \
    file://0001-net-macb-release-spinlock-before-calling-ptp_clock_u.patch \
    file://enable_xilinx_phy.cfg \
    file://enable_autofs.cfg \
    file://enable_wlan.cfg \
    file://dirty-cow-fix-cve-2016-5195.patch \
    file://enable_schedstats.cfg \
    file://0001-serial-xuartps-Enable-loopback-mode.patch \
    file://0001-arm64-KGDB-64-bit-pstate-32-bit-pstate.patch \
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

SRC_URI_append_zynqmp = " \
   file://display_port.cfg \
"
KERNEL_FEATURES_append_zynqmp = " features/drm/drm-xilinx.scc"

SRCREV_zynqmp = "xilinx-v2016.2"

do_deploy_append() {
    if [ "${MACHINE}" = "zcu102-zynqmp-mel" ]
    then
        ln -sf ${KERNEL_IMAGETYPE}-zynqmp-zcu102-revB.dtb ${DEPLOYDIR}/system.dtb
    fi
}
