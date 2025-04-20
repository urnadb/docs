---
title: 部署运行
type: docs
prev: guide/architecture
next: guide/configure
weight: 2
---

目前 UrnaDB 提供多种运行部署方式，包括基于 Docker 镜像的容器化部署和适用于 Linux 系统的可执行文件。作为 UrnaDB 的开发者，我更推荐在长期服务场景中采用 Linux 裸机部署。相比容器化方式，裸机部署能够更充分地利用系统资源，并支持用户根据实际需求灵活调优存储引擎参数，从而实现更高的性能稳定性与资源利用率。建议优先选择主流 Linux 发行版，如 RHEL、SUSE 或 Ubuntu，以获得最佳运行效率与服务保障。

## Docker 容器

使用 Docker 可以快速部署 [urnadb:latest](https://hub.docker.com/r/auula/urnadb) 的镜像来测试 UrnaDB 提供的服务，运行以下命令即可拉取 UrnaDB 镜像：


```bash
docker pull auula/urnadb:latest
```

运行 UrnaDB 镜像启动容器服务，并且映射端口到外部主机网络，执行下面的命令：

```bash
docker run -p 2668:2668 auula/urnadb:latest
```

UrnaDB 提供使用 RESTful API 的方式进行数据交互，理论上任意具备 HTTP 协议的客户端都支持访问和操作 UrnaDB 服务实例。在调用 RESTful API 时需要在请求头中添加 `Auth-Token` 进行鉴权，该密钥由 UrnaDB 进程自动生成，可通过容器运行时日志获取，使用以下命令查看启动日志：

```bash
root@2c2m:~# docker logs 66ae91bc73a6
                  __  __              ___  ___
                 / / / /______  ___ _/ _ \/ _ )
                / /_/ / __/ _ \/ _ `/ // / _  |
                \____/_/ /_//_/\_,_/____/____/  v1.1.2

  UrnaDB is a NoSQL database support diverse data types and transactions.
  UrnaDB Software License: Apache 2.0  Website: https://urnadb.github.io

[UrnaDB:C] 2023/06/04 18:35:15 [WARN] The default password is: QGVkh8niwL2TSkj72icaKBC9B
[UrnaDB:C] 2023/06/04 18:35:15 [INFO] Logging output initialized successfully
[UrnaDB:C] 2023/06/04 18:35:15 [INFO] Loading and parsing region data files...
[UrnaDB:C] 2023/06/04 18:35:15 [INFO] Regions compression activated successfully
[UrnaDB:C] 2023/06/04 18:35:15 [INFO] File system setup completed successfully
[UrnaDB:C] 2023/06/04 18:35:15 [INFO] HTTP server started at http://192.168.31.221:2668 🚀
```

> [!IMPORTANT]
> 采用容器的方式运行有多的弊端：例如 UrnaDB 容器的数据目录和宿主机没有配置正确的映射关系，会导致每次重启之后数据丢失；另外一个问题就是 Docker 这种容器引擎会在正常关闭容器时引入超时机制，如果 UrnaDB 中的内存索引非常大的时候就会导致无法正常退出，Docker 默认超时机制会强制关闭 UrnaDB 所在容器，导致内存中数据无法正常持久化到磁盘。

## Linux 部署

推荐使用 UrnaDB 的最佳方式是通过 Linux 直接部署运行，如果测试阶段你使用的 Windows 系统可以使用虚拟机软件安装 Linux 系统进行测试，也可以使用 WSL 的方式使用 Windows 中的 Ubuntu 子系统进行测试。UrnaDB 的软件包可以从 GitHub 的 [Releases](https://github.com/auula/urnadb/releases/tag/v1.1.2) 页面下载，下载得到的是 zip 压缩包，使用 `unzip` 命令对压缩包进行解压，命令如下：

```bash
unzip urnadb-linux-amd64.zip 
```

解压完成之后将获得对应的 UrnaDB 二进制可执行文件，可直接使用该文件启动 UrnaDB 数据库服务进程，启动命令如下：

```bash
./urnadb --config=config.yaml
```

> [!IMPORTANT]
> 在启动 UrnaDB 数据库进程时可以通过命令行传入多个的参数，这些参数可以调整 UrnaDB 数据库一些运行参数和必要配置信息，如果什么都不传入直接启动 UrnaDB 数据库进程，被启动的 UrnaDB 进程会直接使用内置的默认参数进行运行。

下面是 UrnaDB 数据库进程在启动时能支持传入的命令行参数说明表格：


| 参数     | 作用说明                             |
| -------- | -------------------------------- |
| --config | 指定自定义配置文件路径           |
| --port   | 指定服务器所监听的端口号         |
| --auth   | 指定客户端连接时所需要认证密钥   |
| --daemon | 指定是否使用后台守护进程方式运行 |
| --debug  | 开启日志跟踪调试程序运行状态     |

例如使用后台守护进程并且指定认证密钥的方式启动一个 UrnaDB 的数据库进程，命令如下：

```bash
./urnadb --auth=password --daemon
```
> [!TIP]
> 相比仅通过命令行传入参数的方式，UrnaDB 还支持通过配置文件进行引导启动，也就是上面的 `--config` 参数。配置文件支持更丰富的参数选项，使用户能够更加精细地控制运行时的各项设置，从而实现更灵活、更精准的部署与调优，可以阅读下一章节的内容了解更多详情。