---
title: 部署运行
type: docs
prev: guide/architecture
next: guide/configure
weight: 2
---

目前 MomentDB 提供多种运行部署方式，包括基于 Docker 镜像的容器化部署以及适用于 Linux 系统的可执行文件。作为 MomentDB 项目的开发者，我更推荐采用 **Linux 裸机部署** 的方式，特别是在将 MomentDB 作为长期运行服务的场景中。相较于容器化运行，裸机部署可更充分地利用底层资源，并允许用户根据实际需求手动调整存储引擎参数，从而获得更高的性能稳定性和资源利用率。建议使用主流 Linux 发行版例如 REHL 和 SUSE 、Ubuntu 来运行 MomentDB，以实现最佳的运行效率和服务保障。

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

[MDB:C] 2025/04/18 18:41:58 [INFO] Loading custom config file was successfully
[MDB:C] 2025/04/18 18:41:58 [INFO] Logging output initialized successfully
[MDB:C] 2025/04/18 18:41:58 [INFO] Loading and parsing region data files...
[MDB:C] 2025/04/18 18:41:58 [INFO] Regions compression activated successfully
[MDB:C] 2025/04/18 18:41:58 [INFO] Setting server whitelist IP successfully
[MDB:C] 2025/04/18 18:41:58 [INFO] File system setup completed successfully
[MDB:C] 2025/04/18 18:41:59 [INFO] HTTP server started at http://192.168.31.221:2668 🚀
```

