---
date: '2025-03-01T22:56:40+08:00'
draft: true
title: 快速开始
weight: 1
---

🚀 使用 Docker 可以快速部署 [urnadb:latest](https://hub.docker.com/r/auula/urnadb) 的镜像来测试 UrnaDB 提供的服务，运行以下命令即可拉取 UrnaDB 镜像：

```shell
docker pull auula/urnadb:latest
```

运行 UrnaDB 镜像启动容器服务，并且映射端口到外部主机网络，执行下面的命令：

```shell
docker run -p 2668:2668 auula/urnadb:latest
```

UrnaDB 提供使用 RESTful API 的方式进行数据交互，理论上任意具备 HTTP 协议的客户端都支持访问和操作 UrnaDB 服务实例。在调用 RESTful API 时需要在请求头中添加 Auth-Token 进行鉴权，该密钥由 UrnaDB 进程自动生成，可通过容器运行时日志获取，使用以下命令查看启动日志：

```text
root@2c2m:~# docker logs 66ae91bc73a6
              __  __              ___  ___
             / / / /______  ___ _/ _ \/ _ )
            / /_/ / __/ _ \/ _ `/ // / _  |
            \____/_/ /_//_/\_,_/____/____/  v1.1.2

  UrnaDB is a NoSQL database based on Log-structured file system.
  Software License: Apache 2.0  Website: https://urnadb.github.io

[UrnaDB:C] 2023/06/04 18:35:15 [WARN] The default password is: QGVkh8niwL2TSkj72icaKBC9B
[UrnaDB:C] 2023/06/04 18:35:15 [INFO] Logging output initialized successfully
[UrnaDB:C] 2023/06/04 18:35:15 [INFO] Loading and parsing region data files...
[UrnaDB:C] 2023/06/04 18:35:15 [INFO] Regions compression activated successfully
[UrnaDB:C] 2023/06/04 18:35:15 [INFO] File system setup completed successfully
[UrnaDB:C] 2023/06/04 18:35:15 [INFO] HTTP server started at http://192.168.31.221:2668 🚀
```

如果计划将 UrnaDB 作为长期运行的服务，推荐直接使用主流 Linux 发行版来运行而非容器技术。采用裸机 Linux 部署 UrnaDB 服务，可手动优化存储引擎参数，以获得更稳定的性能和更高的资源利用率，具体参数配置建议查看使用指南部分内容。


## 🕹️ RESTful API

目前 UrnaDB 服务对外提供数据交互接口是基于 HTTP 协议的 RESTful API ，只需要通过支持 HTTP 协议客户端软件就可以进行数据操作。这里推荐使用 curl 软件进行数据交互操作，UrnaDB 内部提供了多种数据结构抽象，例如 Table 、List 、ZSet 、Set 、Number 、Text 类型，这些数据类型对应着常见的业务代码所需使用的数据结构，这里以 Table 类型结构为例进行 RESTful API 数据交互的演示。

Table 结构类似于 JSON 及任何有映射关系的半结构化数据，例如编程语言中的 struct 和 class 字段都可以使用 Table 进行存储，下面是一个 Table 结构 JSON 抽象，其中的 ttl 字段为设置存活时间，超过 120 秒后会被主动删除：

```json
{
    "table": {
        "is_valid": false,
        "items": [
            {
                "id": 1,
                "name": "Item 1"
            },
            {
                "id": 2,
                "name": "Item 2"
            }
        ],
        "meta": {
            "version": "2.0",
            "author": "Leon Ding"
        }
    },
    "ttl": 120
}
```

下面是 curl 进行数据存储操作的例子，由于是 RESTful API 设计风格，需要在 HTTP 的请求路径 URL 加上数据类型信息。注意存储使用 HTTP 协议的 PUT 方法进行操作，使用 PUT 方法会直接创建新数据版本覆盖掉旧的数据版本，命令如下：

```shell
curl -X PUT http://localhost:2668/table/key-01 -v \
     -H "Content-Type: application/json" \
     -H "Auth-Token: QGVkh8niwL2TSkj72icaKBC9B" \
     --data @tests/table.json
```

获取数据的方式只需要将 HTTP 的请求改为 GET 方式就会获取得 Key 相应的存储记录，命令如下：

```shell
curl -X GET http://localhost:2668/table/key-01 -v \
-H "Auth-Token: QGVkh8niwL2TSkj72icaKBC9B" 
```

删除对应的数据记录，只需要将 HTTP 的请求改为 DELETE 的方式即可，命令如下：

```shell
curl -X DELETE http://localhost:2668/table/key-01 -v \
-H "Auth-Token: QGVkh8niwL2TSkj72icaKBC9B" 
```

更为复杂的查询和复杂更新操作，将在后续的版本更新中添加支持。其他数据结构类型操作代码示例请查看使用指南部分文档。

## 🧪 Benchmark Test

由于底层存储引擎是以 Append-Only Log 的方式将所有的操作写入到数据文件中，所以这里给出的测试用例报告，是针对的其核心文件系统 vfs 包的写入性能测试的结果。运行测试代码的硬件设备配置信息为（Intel i5-7360U, 8GB LPDDR3 RAM），写入基准测试结果如下：

```shell
$: go test -benchmem -run=^$ -bench ^BenchmarkVFSWrite$ github.com/auula/urnadb/vfs
goos: darwin
goarch: amd64
pkg: github.com/auula/urnadb/vfs
cpu: Intel(R) Core(TM) i5-7360U CPU @ 2.30GHz
BenchmarkVFSWrite-4   	  173533	      7283 ns/op	     774 B/op	      20 allocs/op
PASS
ok  	github.com/auula/urnadb/vfs	2.806s
```

在项目根目录下有一个 [tools.sh](https://github.com/auula/urnadb/blob/main/tools.sh) 的工具脚本文件，可以快速帮助完成各项辅助工作。