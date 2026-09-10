SUMMARY = "ATK minimal system image for STM32MP2"
LICENSE = "MIT"

inherit core-image

# =========================================================
# 极简系统：不依赖 ST packagegroup，全部显式列出
# =========================================================

# 语言：仅 en-us，减少 locale 开销
IMAGE_LINGUAS = "en-us"

# IMAGE_FEATURES：不启用任何额外功能（无 package-management/ssh）
IMAGE_FEATURES = ""

# =========================================================
# 基础包（启动必需）
# =========================================================
IMAGE_INSTALL += " \
    packagegroup-core-boot        \
    "

CORE_IMAGE_BASE_INSTALL = "packagegroup-core-boot"
# =========================================================
# 按需追加（取消注释即可）
# =========================================================
# ---- SSH 远程登录（可选） ----
#IMAGE_INSTALL += "dropbear"

# ---- 网络工具（可选） ----
#IMAGE_INSTALL += "ethtool iproute2 curl"

# ---- 文件系统工具（可选） ----
#IMAGE_INSTALL += "e2fsprogs"

# ---- 系统调试（可选） ----
#IMAGE_INSTALL += "strace gdb"

# =========================================================
# 禁止推荐的自动依赖（保持极简）
# 注意：会移除所有 kernel-module-*，需确认板子驱动
# =========================================================
#BAD_RECOMMENDATIONS += "kernel-modules kernel-module-*"

# =========================================================
# Stage 4: drop udev hardware database (~19MB)
# Note: PACKAGE_EXCLUDE is honored by all backends (deb included),
#       force-excludes udev-hwdb even though it is pulled by deps
# =========================================================
PACKAGE_EXCLUDE = "udev-hwdb"