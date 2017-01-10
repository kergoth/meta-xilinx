FILES_SOLIBSDEV = ""
FILES_${PN} = "${libdir}/*.so*"
INSANE_SKIP_${PN} = "dev-so"

RDEPENDS_${PN}_remove = "mali-modules"

do_install() {
    # install headers
    install -d -m 0655 ${D}${includedir}/EGL
    install -m 0644 ${S}/${EGL_TYPE}/usr/include/EGL/*.h ${D}${includedir}/EGL/
    install -d -m 0655 ${D}${includedir}/GLES
    install -m 0644 ${S}/${EGL_TYPE}/usr/include/GLES/*.h ${D}${includedir}/GLES/
    install -d -m 0655 ${D}${includedir}/GLES2
    install -m 0644 ${S}/${EGL_TYPE}/usr/include/GLES2/*.h ${D}${includedir}/GLES2/
    install -d -m 0655 ${D}${includedir}/KHR
    install -m 0644 ${S}/${EGL_TYPE}/usr/include/KHR/*.h ${D}${includedir}/KHR/

    install -d ${D}${libdir}/pkgconfig
    install -m 0644 ${WORKDIR}/egl.pc ${D}${libdir}/pkgconfig/egl.pc
    install -m 0644 ${WORKDIR}/glesv2.pc ${D}${libdir}/pkgconfig/glesv2.pc
    install -m 0644 ${WORKDIR}/glesv1.pc ${D}${libdir}/pkgconfig/glesv1.pc
    install -m 0644 ${WORKDIR}/glesv1_cm.pc ${D}${libdir}/pkgconfig/glesv1_cm.pc

    install -d ${D}${libdir}
    cp -r ${S}/${EGL_TYPE}/usr/lib/*.so* ${D}${libdir}

    # Make Insane happy about non-symlink so in -dev
    rm -rf ${D}${libdir}/libMali_prof.so
    cp -r ${S}/${EGL_TYPE}/usr/lib/libMali_prof.so ${D}${libdir}/libMali_prof.so.1
}

# WARNING: libmali-xlnx-r5p1-01rel0-r0 do_package_qa: QA Issue: ELF binary 'libmali-xlnx/r5p1-01rel0-r0/packages-split/libmali-xlnx/usr/lib64/libMali_prof.so.1' has relocations in .text
# ELF binary 'libmali-xlnx/r5p1-01rel0-r0/packages-split/libmali-xlnx/usr/lib64/libMali.so.1' has relocations in .text [textrel]
INSANE_SKIP_${PN} += "textrel"
