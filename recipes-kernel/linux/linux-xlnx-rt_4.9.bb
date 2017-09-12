require recipes-kernel/linux/linux-xlnx_4.9.bb

LINUX_VERSION_EXTENSION .= "-rt"

SRC_URI += "https://www.kernel.org/pub/linux/kernel/projects/rt/4.9/older/patch-4.9-rt1.patch.gz;name=rt-patch"
SRC_URI[rt-patch.md5sum] = "3c43310bbdd8a56daf4c48941d4a739c"
SRC_URI[rt-patch.sha256sum] = "5c3e5a990d33e93c0cccae3e73e7191e868826e2a9456444c7c8d9fd16a5abe1"

SRC_URI += "file://preempt-rt.cfg"
FILESEXTRAPATHS_prepend = "${@os.path.dirname(bb.utils.which('${BBPATH}', 'recipes-kernel/linux/linux-xlnx_4.9.bb'))}/files:"

python () {
    pn = d.getVar('PN', True)
    if d.getVar("PREFERRED_PROVIDER_virtual/kernel", True) != pn:
        raise bb.parse.SkipPackage("Set PREFERRED_PROVIDER_virtual/kernel to `%s` to enable it" % pn)
}
