FILESEXTRAPATHS_prepend := "${THISDIR}/files:${@os.path.dirname(bb.utils.which(BBPATH, 'files/lttng.cfg') or '')}:"

SRC_URI_append = " \
    ${@bb.utils.contains("MACHINE_FEATURES", "hdmi", "file://xilinx_zynq_base_trd.cfg", "", d)} \
    file://lttng.cfg \
    file://0001-drivers-apf-Fix-Global-timer-enable-sequence.patch \
    file://unionfs-2.6_for_3.14.17.patch \    
    file://enable_quota.cfg \
    file://enable_squashfs.cfg \
    file://enable_unionfs.cfg \
    file://systemd.cfg \
    file://enable_kgboc.cfg \
    file://0001-Makefile-Link-kgdoc-after-the-UART-driver.patch \
    file://0001-scsi-fix-our-current-target-reap-infrastructure.patch \
    file://0002-SCSI-dual-scan-thread-bug-fix.patch \
"

SRCREV = "c0292a5c3919cf777f9d21202e022c99ce255b8f"
