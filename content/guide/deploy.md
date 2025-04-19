---
title: 部署运行
type: docs
prev: guide/architecture
next: guide/configure
weight: 2
---

目前 MomentDB 提供多种运行部署方式，包括基于 Docker 镜像的容器化部署和适用于 Linux 系统的可执行文件。作为 MomentDB 的开发者，我更推荐在长期服务场景中采用 Linux 裸机部署。相比容器化方式，裸机部署能够更充分地利用系统资源，并支持用户根据实际需求灵活调优存储引擎参数，从而实现更高的性能稳定性与资源利用率。建议优先选择主流 Linux 发行版，如 RHEL、SUSE 或 Ubuntu，以获得最佳运行效率与服务保障。

## Docker 容器

使用 Docker 可以快速部署 [momentdb:latest](https://hub.docker.com/r/auula/momentdb) 的镜像来测试 MomentDB 提供的服务，运行以下命令即可拉取 MomentDB 镜像：


```bash
docker pull auula/momentdb:latest
```

运行 MomentDB 镜像启动容器服务，并且映射端口到外部主机网络，执行下面的命令：

```bash
docker run -p 2668:2668 auula/momentdb:latest
```

MomentDB 提供使用 RESTful API 的方式进行数据交互，理论上任意具备 HTTP 协议的客户端都支持访问和操作 MomentDB 服务实例。在调用 RESTful API 时需要在请求头中添加 `Auth-Token` 进行鉴权，该密钥由 MomentDB 进程自动生成，可通过容器运行时日志获取，使用以下命令查看启动日志：

```bash
root@2c2m:~# docker logs 66ae91bc73a6
           __  ___                    __  ___  ___
          /  |/  /__  __ _  ___ ___  / /_/ _ \/ _ )
         / /|_/ / _ \/  ' \/ -_) _ \/ __/ // / _  |
        /_/  /_/\___/_/_/_/\__/_//_/\__/____/____/  v1.1.2

  MomentDB is a NoSQL database based on Log-structured file system.
  Software License: Apache 2.0  Website: https://momentdb.github.io

[MDB:C] 2025/04/18 18:48:45 [WARN] The default password is: iYPNxjlFt2FnKy8XUh6henLMJ
[MDB:C] 2025/04/18 18:48:45 [INFO] Logging output initialized successfully
[MDB:C] 2025/04/18 18:48:45 [INFO] Loading and parsing region data files...
[MDB:C] 2025/04/18 18:48:46 [INFO] Regions compression activated successfully
[MDB:C] 2025/04/18 18:48:46 [INFO] File system setup completed successfully
[MDB:C] 2025/04/18 18:48:46 [INFO] HTTP server started at http://192.168.31.221:2668 🚀
```

> [!IMPORTANT]
> 采用容器的方式运行有多的弊端：例如 MomentDB 容器的数据目录和宿主机没有配置正确的映射关系，会导致每次重启之后数据丢失；另外一个问题就是 Docker 这种容器引擎会在正常关闭容器时引入超时机制，如果 MomentDB 中的内存索引非常大的时候就会导致无法正常退出，Docker 默认超时机制会强制关闭 MomentDB 所在容器，导致内存中数据无法正常持久化到磁盘。

## Linux 部署

推荐使用 MomentDB 的最佳方式是通过 Linux 直接部署运行，你可以从 GitHub 的 [Releases](https://github.com/auula/momentdb/releases/tag/v1.1.2) 页面下载 MomentDB 的可执行文件。下载得到的是 zip 压缩包，使用 `unzip` 命令对压缩包进行解压，命令如下：

```bash
unzip wiredb-linux-amd64.zip 
```

解压完成将会得到对应的 MomentDB 二进制可执行文件，可以直接使用通过二进制文件启动一个 MomentDB 数据库进程，命令如下：

```bash

```