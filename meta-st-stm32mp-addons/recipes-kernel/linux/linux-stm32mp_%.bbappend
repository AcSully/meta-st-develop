# Configure recipe for CubeMX
inherit cubemx-stm32mp

FILESEXTRAPATHS:prepend := "${THISDIR}/linux-stm32mp:"

LINUX_VERSION = "6.6"
LINUX_SUBVERSION = ".129"
LINUX_TARBASE = "linux-${LINUX_VERSION}${LINUX_SUBVERSION}"

# Use the ST-specific defconfig instead of the generic mainline "defconfig".
# The 000x-*.patch files above (alientek panel driver / CONFIG_DRM_PANEL_
# ALIENTEK_MIPI_LCD) only modify stm32mp257_defconfig, so without this the
# patches have no effect and 48010000.display-controller stays stuck in
# "deferred probe pending" (panel "alientek,mipi-lcd" has no bound driver).
KERNEL_DEFCONFIG = "stm32mp257_defconfig"

SRC_URI += " \
    file://${LINUX_VERSION}/${LINUX_VERSION}${LINUX_SUBVERSION}/0001-stm32mp257-custom-changes-panel-es8388-motorcomm-fus.patch \
	file://${LINUX_VERSION}/${LINUX_VERSION}${LINUX_SUBVERSION}/0002-update-stm32mp257_defconfig.patch \
	file://${LINUX_VERSION}/${LINUX_VERSION}${LINUX_SUBVERSION}/0003-1.-update-stm32mp257_develop_defconfig.patch \
	file://${LINUX_VERSION}/${LINUX_VERSION}${LINUX_SUBVERSION}/0004-net-phy-motorcomm-switch-back-to-the-in-tree-driver.patch \
	file://${LINUX_VERSION}/${LINUX_VERSION}${LINUX_SUBVERSION}/0005-usb-typec-tcpm-fusb302-switch-back-to-the-upstream-T.patch \
	file://${LINUX_VERSION}/${LINUX_VERSION}${LINUX_SUBVERSION}/0006-ASoC-es8388-fix-format-mask-headphone-IRQ-and-the-re.patch \
	file://${LINUX_VERSION}/${LINUX_VERSION}${LINUX_SUBVERSION}/0007-drm-panel-alientek-mipi-fix-device-node-leak-and-unk.patch \
	file://${LINUX_VERSION}/${LINUX_VERSION}${LINUX_SUBVERSION}/0008-arm64-defconfig-drop-the-redundant-_bak-copy.patch \
	file://${LINUX_VERSION}/${LINUX_VERSION}${LINUX_SUBVERSION}/0009-net-phy-motorcomm-reapply-YT8531-clock-output-config.patch \
    "

# ------------------------------------------------
# Generate Kernel Makefile for usage of EXTERNAL DT with cubemx devicetree
# ------------------------------------------------
autogenerate_makefile_for_external_dt_cubemx() {
    [ "${ENABLE_CUBEMX_DTB}" -ne 1 ] && return
    [ "${CUBEMX_EXTDT_ENABLE_MK}" -ne 1 ] && return

    if [ -e "${STAGING_EXTDT_DIR}/${EXTDT_DIR_LINUX}/Makefile" ]; then
        [ "${CUBEMX_EXTDT_FORCE_MK}" -ne 1 ] && return
    fi

    echo "# SPDX-License-Identifier: GPL-2.0-only" > ${WORKDIR}/Makefile.external_dt
    echo "" >>  ${WORKDIR}/Makefile.external_dt

    dtb=$(echo ${STM32MP_DEVICETREE} | tr ' ' '\n' | uniq | tr '\n' ' ')
    if [ "${ARCH}" = "arm" ]; then
        echo "dtb-\$(TARGET_ARM32) += \\" >> ${WORKDIR}/Makefile.external_dt
        for devicetree in ${dtb}; do
            echo "    ${devicetree}.dtb \\" >> ${WORKDIR}/Makefile.external_dt
        done
        echo "" >> ${WORKDIR}/Makefile.external_dt
    fi
    if [ "${ARCH}" = "arm64" ]; then
        echo "dtb-\$(TARGET_ARM64) += \\" >> ${WORKDIR}/Makefile.external_dt
        for devicetree in ${dtb}; do
            echo "    ${devicetree}.dtb \\" >> ${WORKDIR}/Makefile.external_dt
        done
        echo "" >> ${WORKDIR}/Makefile.external_dt
    fi

    cp -f ${WORKDIR}/Makefile.external_dt ${STAGING_EXTDT_DIR}/${EXTDT_DIR_LINUX}/Makefile

}
python() {
    machine_overrides = d.getVar('MACHINEOVERRIDES').split(':')
    if "stm32mpcommonmx" in machine_overrides:
        d.appendVarFlag('do_configure', 'prefuncs', ' autogenerate_makefile_for_external_dt_cubemx')
}
