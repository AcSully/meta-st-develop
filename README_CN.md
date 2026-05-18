# meta-st-develop（中文说明）

STMicroelectronics STM32MP2 的 Yocto/OpenEmbedded BSP meta 层，以及以 Git
submodule 方式管理的 STM32CubeMX 工程。

> English version: [README.md](README.md)

## 仓库结构

| 路径 | 说明 |
|------|------|
| `meta-st-openstlinux/` | ST OpenSTLinux 发行版层 |
| `meta-st-stm32mp/` | ST STM32MP machine/BSP 层 |
| `meta-st-stm32mp-addons/` | ST 附加层（板级定制） |
| `meta-st-stm32mp-addons/mx/` | **Git submodule** → [`AcSully/STM32MP257DAK3`](https://github.com/AcSully/STM32MP257DAK3)，STM32CubeMX 工程（设备树、OP-TEE 等） |
| `scripts/` | 辅助脚本 |

四个 meta 层最初用 `repo` 工具拉取，其残缺的 `.git` 壳已被删除，源码现在直接由
本仓库跟踪。只有 `mx` 是一个真正独立的 Git 仓库，以 submodule 形式包含进来，
便于单独版本管理和推送。

## 克隆

本仓库含 submodule，**务必加 `--recurse-submodules`**：

```bash
git clone --recurse-submodules git@github.com:AcSully/meta-st-develop.git
```

如果已经克隆但漏了 submodule（`mx` 目录是空的）：

```bash
cd meta-st-develop
git submodule update --init --recursive
```

> 需要配置好 GitHub SSH key（两个远程都是 `git@github.com:`）。
> 用 `ssh -T git@github.com` 验证。

## 日常协作流程

### 修改 meta 层（除 `mx` 外的内容）

直接在顶层仓库提交/推送：

```bash
git add <文件>
git commit -m "..."
git push
```

### 修改 `mx`

`mx` 是独立仓库。**先**提交并推送它，**再**回父仓库更新 submodule 指针：

```bash
# 1. 在 submodule 内部
cd meta-st-stm32mp-addons/mx
git checkout feature/yocto-stm32mp2-atk-2g16g
git add -A && git commit -m "..."
git push origin feature/yocto-stm32mp2-atk-2g16g

# 2. 回父仓库：记录新的 mx 提交
cd ../..
git add meta-st-stm32mp-addons/mx
git commit -m "Bump mx submodule"
git push
```

漏掉第 2 步，别人拉到的还是旧版 `mx`。

### 拉取他人的更新

```bash
git pull
git submodule update --init --recursive
```

## 远程地址

| 仓库 | URL |
|------|-----|
| 父仓库 | `git@github.com:AcSully/meta-st-develop.git` |
| `mx` submodule | `git@github.com:AcSully/STM32MP257DAK3.git`（分支 `feature/yocto-stm32mp2-atk-2g16g`） |
