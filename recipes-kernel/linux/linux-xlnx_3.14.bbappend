FILESEXTRAPATHS_prepend := "${THISDIR}/files:${@os.path.dirname(bb.utils.which(BBPATH, 'files/lttng.cfg') or '')}:"

SRC_URI_append = " \
    ${@base_contains("MACHINE_FEATURES", "hdmi", "file://xilinx_zynq_base_trd.cfg", "", d)} \
    file://openamp.cfg \
    file://lttng.cfg \
    file://0001-openamp-integrate-OpenAMP-support.patch \
    file://0001-drivers-apf-Fix-Global-timer-enable-sequence.patch \
"

# The latest kernel in meta-xilinx is missing critical graphic driver commits,
# we will base our work on the latest vendor kernel.
SRCREV = "c0292a5c3919cf777f9d21202e022c99ce255b8f"
