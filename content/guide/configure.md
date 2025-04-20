---
title: 配置参数
type: docs
prev: guide/deployment
next: guide/layout
weight: 3
---

通过配置文件的方式启动 UrnaDB 数据库，可以灵活调整各个组件的运行参数，并按需启用或关闭核心功能模块。UrnaDB 提供丰富的组件配置选项，方便用户根据实际需求进行精细化控制，以下是一个示例 `config.yaml` 配置文件内容：


```yaml {filename="config.yaml"}
port: 2668                              # 服务 HTTP 协议端口
mode: "std"                             # 默认为 std 标准库，另外可以设置 mmap 模式（本功能待完善）
path: "/tmp/urnadb"                     # 数据库文件存储目录
auth: "Are we wide open to the world?"  # 访问 HTTP 协议的秘密
logpath: "/tmp/urnadb/out.log"          # urnadb 在运行时程序产生的日志存储文件
debug: false                            # 是否开启 debug 模式
region:                                 # 数据区
    enable: true                        # 是否开启数据压缩功能
    cron: "0 0 3 * * *"                 # 垃圾回收器执行周期改为 cron 的格式
    threshold: 2                        # 默认个数据文件大小，单位 GB
encryptor:                              # 是否开启静态数据加密功能
    enable: false
    secret: "your-static-data-secret!"
compressor:                             # 是否开启静态数据压缩功能
    enable: false
checkpoint:                             # 是否开启索引定时快照功能
    enable: false 
    interval: 1800                      # 每 30 分钟生成一次索引数据快照   
allowip:                                # 白名单 IP 列表，可以去掉这个字段，去掉之后白名单就不会开启
    - 192.168.31.221
    - 192.168.101.225
    - 192.168.101.226
    - 127.0.0.1
```


## 数据区

Region 是 UrnaDB 中最核心的功能模块之一，其相关的配置参数用于控制数据区运行时的行为，例如可以通过配置启用或禁用 Region 的垃圾回收机制，并设置单个 Region 区域的最大容量限制；相关的配置选项节点是 `region` ：

```yaml
region:                                 # 数据区
    enable: true                        # 是否开启数据压缩功能
    cron: "0 0 3 * * *"                 # 垃圾回收器执行周期改为 cron 的格式
    threshold: 2                        # 默认个数据文件大小，单位 GB
```

> [!WARNING]
> 在配置 Region 区域时，需要重点考虑是否启用存储引擎的垃圾回收功能。若不启用，长时间运行可能导致磁盘空间持续增长，占用过高。若启用垃圾回收功能，则需合理设置其执行周期：周期过长可能导致空间回收不及时，占用上升，并在压缩 Region 时耗时较长；周期过短则可能导致垃圾回收过于频繁，占用系统资源，影响存储引擎的整体性能。

## 数据加密

Region 区域对应的是磁盘上的数据文件，这些文件直接存储在运行 UrnaDB 数据库的服务器本地磁盘中，由于这些文件以普通文件形式存在，理论上任何拥有访问该服务器权限的用户都有可能读取它们的内容。这就引出了一个关键问题：如何有效防止这些敏感数据文件被未授权人员访问和泄露。

```yaml
encryptor:                             
    enable: false                           # 是否开启静态数据加密功能
    secret: "your-static-data-secret!"      # 静态加密的密钥
```

> [!WARNING]
> UrnaDB 内置的加密算法采用 AES（Advanced Encryption Standard），使用 CBC（Cipher Block Chaining）模式进行数据加密。支持三种标准密钥长度：128 位、192 位和 256 位，其中 256 位密钥提供最高的安全等级。需要注意的是，密钥强度越高，相应的 CPU 资源消耗也会增加，可能影响运行时性能表现。

## 数据压缩

## 访问控制