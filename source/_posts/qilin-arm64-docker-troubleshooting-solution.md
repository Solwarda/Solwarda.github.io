---
title: 麒麟 ARM64 系统 Docker 踩坑记
date: 2026-03-10 17:00:00
categories:
  - Docker
tags:
  - ARM64
  - 麒麟系统
  - Docker 故障排查
---

# 麒麟 ARM64 系统 Docker 踩坑记：从代理配置到"invalid tar header"的终极解决方案

## 背景

最近在麒麟（Kylin）ARM64 系统上使用 Docker 时，遇到了一系列问题。从最开始的代理配置，到拉取镜像时反复出现的 `archive/tar: invalid tar header` 错误，折腾了不少时间。本文将完整记录排查过程及最终解决方案，希望能帮助到遇到同样问题的朋友。

---

## 1. 首次拉取：代理问题

刚安装好 Docker，执行 `docker pull hello-world` 却遇到错误：

```bash
$ docker pull hello-world
Using default tag: latest
Error response from daemon: Get https://registry-1.docker.io/v2/: proxyconnect tcp: dial tcp 127.0.0.1:7890: connect: connection refused
```

很明显，这是代理配置缺失或指向错误。检查发现系统代理已设置但 Docker 未继承。解决方法：临时设置环境变量（或永久写入配置）。

```bash
export http_proxy=http://127.0.0.1:7890
export https_proxy=http://127.0.0.1:7890
docker pull hello-world
```

设置后拉取成功：

```
latest: Pulling from library/hello-world
198f93fd5094: Pull complete
Digest: sha256:ef54e839ef541993b4e87f25e752f7cf4238fa55f017957c2eb44077083d7a6a
Status: Downloaded newer image for hello-world:latest
```

此时查看已有镜像：

```
$ docker images
REPOSITORY       TAG       IMAGE ID       CREATED         SIZE
arm64v8/ubuntu   22.04     68c5ac770760   2 months ago    69.3MB
hello-world      latest    ca9905c726f0   7 months ago    5.2kB
arm64v8/alpine   3.18      de2b9975f8fd   12 months ago   7.66MB
```

---

## 2. 进入容器的常用命令

有了镜像，自然想进入容器操作。记录一下常用的交互式启动命令：

- **Ubuntu 22.04**：`docker run -it arm64v8/ubuntu:22.04 /bin/bash`
- **Alpine 3.18**：`docker run -it arm64v8/alpine:3.18 /bin/sh`

注意：`hello-world` 是测试镜像，启动后会立即退出，无法进入终端。

---

## 3. 噩梦开始：拉取 `arm64v8/centos:7` 时反复出现 `invalid tar header`

之后尝试拉取一个 CentOS 7 镜像（ARM64 架构）：

```bash
docker pull arm64v8/centos:7
```

拉取进度到解压层时，报错：

```
archive/tar: invalid tar header
```

尝试多次，换用不同镜像（甚至官方 `ubuntu`）均在同一阶段失败。错误信息指向 tar 头部损坏，但镜像源本身是可靠的（在其他架构上正常）。

### 3.1 常规排查手段均无效

- **清理 Docker 存储**：`docker system prune -a`，删除 `/var/lib/docker` 后重启。
- **切换存储驱动**：从 `overlay2` 改为 `aufs`、`devicemapper` 测试。
- **迁移数据目录**：换到另一块磁盘。
- **重装 Docker**：卸载后重新安装最新版。

所有方法都无法解决问题，错误依旧。

---

## 4. 真相大白：麒麟 ARM64 的 `unpigz` 是罪魁祸首

在反复查阅 Docker 源码和社区讨论后，怀疑是镜像层解压环节出了问题。Docker 在解压 gzip 压缩的层时，会优先调用 `unpigz`（并行解压工具）以提高性能。如果系统中存在 `unpigz`，Docker 会使用它；否则回退到标准的 `gunzip`。

在麒麟 ARM64 系统中，默认安装了 `unpigz`（由 `pigz` 包提供），但该 ARM64 版本的 `unpigz` 存在兼容性缺陷——解压后的 tar 流头部会损坏，导致 Docker 注册层失败。

验证方法：直接用 `unpigz` 解压一个正常的 `.tar.gz` 文件，再对比 `gunzip` 的结果，发现 `unpigz` 解压后的 tar 文件头部确实损坏。

### 4.1 解决方案：移走 `unpigz`，强制 Docker 使用 `gunzip`

```bash
sudo mv /usr/bin/unpigz /usr/bin/unpigz.bak
```

执行后，再次拉取镜像：

```bash
docker pull arm64v8/centos:7
```

这次所有层顺利解压，镜像拉取成功！

如果以后需要恢复 `unpigz`，只需改回原名：

```bash
sudo mv /usr/bin/unpigz.bak /usr/bin/unpigz
```

---

## 5. 验证与最终命令

移走 `unpigz` 后，不仅 CentOS 7 可以正常拉取，之前失败的 Ubuntu、Alpine 等镜像也全部成功。同时，代理配置依然有效。

一个典型的带代理的交互式容器启动命令（适用于有代理环境的麒麟系统）：

```bash
docker run -it --name ubuntu_claude \
  --net=host \
  -e http_proxy=http://192.168.8.156:7890 \
  -e https_proxy=http://192.168.8.156:7890 \
  arm64v8/ubuntu:22.04 \
  /bin/bash
```

---

## 6. 总结

- **代理问题**：Docker 拉取镜像时如需代理，需设置 `http_proxy`/`https_proxy` 环境变量（或写入 Docker 服务配置）。
- **invalid tar header 错误**：在麒麟 ARM64 系统上很可能是由 `unpigz` 的兼容性问题引起。重命名 `unpigz` 让 Docker 回退到 `gunzip` 即可完美解决。
- **副作用**：移走 `unpigz` 不会影响系统其他功能，解压速度会稍有下降，但稳定性优先。

希望本文能帮助遇到同样坑的朋友节省排查时间。如果你在麒麟或其他 ARM64 发行版上也有类似经历，欢迎交流讨论！
