# meta-st-develop

STMicroelectronics STM32MP2 Yocto/OpenEmbedded BSP meta-layers, plus the
STM32CubeMX project tracked as a Git submodule.

> 中文版见 [README_CN.md](README_CN.md)

## Repository layout

| Path | Description |
|------|-------------|
| `meta-st-openstlinux/` | ST OpenSTLinux distro layer |
| `meta-st-stm32mp/` | ST STM32MP machine/BSP layer |
| `meta-st-stm32mp-addons/` | ST add-ons layer (board customizations) |
| `meta-st-stm32mp-addons/mx/` | **Git submodule** → [`AcSully/STM32MP257DAK3`](https://github.com/AcSully/STM32MP257DAK3) — STM32CubeMX project (device tree, OP-TEE, etc.) |
| `scripts/` | Helper scripts |

The four meta-layers were originally fetched with the `repo` tool; their
incomplete `.git` stubs were removed and the sources are now tracked directly
in this repository. Only `mx` is a real, independent Git repository, included
here as a submodule so it can be versioned and pushed separately.

## Clone

This repository contains a submodule, so **always clone with
`--recurse-submodules`**:

```bash
git clone --recurse-submodules git@github.com:AcSully/meta-st-develop.git
```

If you already cloned without it (the `mx` directory is empty):

```bash
cd meta-st-develop
git submodule update --init --recursive
```

> Requires a working GitHub SSH key (both remotes use `git@github.com:`).
> Verify with `ssh -T git@github.com`.

## Daily workflow

### Changing the meta-layers (anything except `mx`)

Edit, then commit/push in the top-level repo as usual:

```bash
git add <files>
git commit -m "..."
git push
```

### Changing `mx`

`mx` is a separate repository. Commit and push it **first**, then update the
submodule pointer in the parent repo:

```bash
# 1. Inside the submodule
cd meta-st-stm32mp-addons/mx
git checkout feature/yocto-stm32mp2-atk-2g16g
git add -A && git commit -m "..."
git push origin feature/yocto-stm32mp2-atk-2g16g

# 2. Back in the parent repo: record the new mx commit
cd ../..
git add meta-st-stm32mp-addons/mx
git commit -m "Bump mx submodule"
git push
```

Skipping step 2 means others still get the old `mx` version.

### Pulling updates from others

```bash
git pull
git submodule update --init --recursive
```

## Remotes

| Repo | URL |
|------|-----|
| Parent | `git@github.com:AcSully/meta-st-develop.git` |
| `mx` submodule | `git@github.com:AcSully/STM32MP257DAK3.git` (branch `feature/yocto-stm32mp2-atk-2g16g`) |
