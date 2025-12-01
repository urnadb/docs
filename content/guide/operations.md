---
title: API 交互
type: docs
prev: guide/tls-http
weight: 7
---

UrnaDB 内部提供了多种数据结构抽象，例如 Table 、Record 、 Variant 、Lock 类型，这些数据类型对应着常见的业务代码所需使用的数据结构。后续的文档统一称之为 NameSpace 命名空间，同一命名空间中存储都是同一类型的数据模型的数据，了解不同命名空间的数据模型及其特性，有助于开发者根据业务需求选择最合适的数据模型，从而高效实现上层业务功能。

> [!IMPORTANT]
> 客户端与 UrnaDB 服务端之间的数据交互通过 **PQL** 协议，PQL（Patch Query Language）是一种基于 HTTP + JSON 的数据操作与查询协议，为客户端与服务器之间的结构化数据交换提供了统一、简单且可扩展的接口，任何能够发起 HTTP 请求的软件都可以作为 PQL 客户端；以下内容将介绍如何使用 PQL API 与服务器进行数据交换示例。

**PQL** 协议统一返回的数据格式为 JSON 格式，包括 3 个字段 **status** 和 **message** 、**data** 字段，其中 **status** 字段是一个枚举类型，值可以 **success | error** 其中一种，客户端可以根据此字段判断事物操作是否执行成功；**message** 的值为给人类阅读的消息，**data** 字段的值是一个 JSON Object 对象，可以是 JSON 对象也可以是一个数组类型。

```json
{
    "status": "success",
    "message": "server output text message",
    "data": ...
}
```


## 📈 Table 命名空间

> [!TIP]
> **Table** 命名空间的结构类似关系数据库 SQL 中的一张表结构，一旦创建完成之后 Table 会为每条记录分配一个全局唯一递增的 `t_id` 索引，Table 的每列可以存储任何有映射关系的半结构化数据，例如编程语言中的 struct 和 class 字段都可以使用 Table 进行存储。相比于关系数据库 SQL 中表有更高的灵活性，不需要提前定义表 schema 结构，可以在使用的过程中灵活的动态添加、删除和修改这些记录字段。


创建一张名为 **users** 的 Table 命名空间，也可以称之为数据表。类似于关系数据库 SQL 中的 `CREATE TABLE ... { ... }` 语句，但区别于不需要提前定义表 schema 结构，代码如下：

```bash
curl -X PUT http://192.168.31.221:2668/tables/users \
  -H "Auth-Token: 73suyb7iNeZsmqhvaxgEn7Ug2"
```

如果上面操作执行成功，会创建一个 **users** 的命名空间，这个 **users** 命名空间后续可以存放更多数据记录，HTTP 会响应返回 JSON 格式的内容如下：

```json
{
    "status": "success",
    "message": "table created successfully"
}
```

> [!IMPORTANT]
> 在创建命名空间的时候可以指定该命名空间的生命周期，生命周期是指该命名空间创建之后能存活多久，以秒为单位，当到达期限后 UrnaDB 的垃圾回收器会主动删除该命名空间释放其占用的存储空间。


例如在创建 **users** 时通过 `ttl` 字段来指定它的生命周期为 1800 秒，在 1800 秒之后会被垃圾回收器主动删除，代码如下：

```bash
curl -X PUT "http://192.168.31.221:2668/tables/users" \
  -H "Auth-Token: 73suyb7iNeZsmqhvaxgEn7Ug2" \
  -H "Content-Type: application/json" \
  -d '{
    "ttl": 1800
  }'
```

下面是 Table 命名空间中的 Rows 结构的完整 JSON 抽象，Table 命名空间中的每条数据记录的 schema 布局是不同的，其中的 `t_id` 为数据库主动分配的自增主键：

```json
{
    "table": {
        "1": {
            "active": true,
            "age": 25,
            "name": "Leon Ding",
            "score": 95.5,
            "tags": [
                "admin",
                "user"
            ]
        },
        "2": {
            "active": false,
            "age": 30,
            "name": "Alice Wang",
            "config": {
                "font": 14,
                "theme": "dark"
            },
            "email": "example@xxx.com"
        },
        "3": {}
    },
    "t_id": 4
}
```

向 **users** 命名空间中插入一条数据记录，这条操作类似于关系数据库 SQL 中的 `INSERT ... INTO ... VALUES ...` 语句，代码如下：

```bash
curl -X POST "http://192.168.101.252:2668/tables/users/rows" \
  -H "Auth-Token: yv2PH82JXfm2UpScAQK37iJVI" \
  -H "Content-Type: application/json" \
  -d '{
    "rows": {
      "name": "Leon Ding",
      "age": 25,
      "active": true,
      "score": 95.5,
      "tags": ["admin", "user"],
      "meta": {
        "editor": "system"
      }
    }
  }'
```

上面命令会执行成功之后会返回对应记录的主键 `t_id` 字段，HTTP 会响应返回 JSON 格式的内容如下：

```json
{
    "status": "success",
    "message": "table rows insert successfully",
    "data": {
        "t_id": 1
    }
}
```

从 **users** 的命名空间中查询所有的数据记录，类似于关系数据库 SQL 中的 `SELECT * FROM ...` 语句，也类似于其他文档型数据库 MongoDB 中的 `findAll` 操作，代码如下：

```bash
curl -X GET "http://192.168.31.221:2668/tables/users" \
  -H "Auth-Token: 73suyb7iNeZsmqhvaxgEn7Ug2"
```

如果上面操作执行成功会返回该命名空间中所有的数据记录，HTTP 会响应返回 JSON 格式的内容如下：

```json
{
    "status": "success",
    "message": "table queried successfully",
    "data": {
        "1": {
            "active": true,
            "age": 25,
            "meta": {
                "editor": "system"
            },
            "name": "Leon Ding",
            "score": 95.5,
            "tags": [
                "admin",
                "user"
            ]
        }
    }
}
```

从名为 **users** 的命名空间中查询一条记录，类似于关系数据库 SQL 中的 `SELECT * FROM ... WHERE ...` 的语句，查询条件是表中 **name** 字段的值为 **Leon Ding** 的记录，代码如下：

```bash
curl -X GET "http://192.168.31.221:2668/tables/users/rows" \
  -H "Auth-Token: ex224JWgK5H6sKhpNk5ZbWKzM" \
  -H "Content-Type: application/json" \
  -d '{
    "wheres": {
      "name": "Leon Ding"
    }
  }'
```

如果上面操作执行成功会返回该命名空间中匹配到的数据记录，HTTP 会响应返回 JSON 格式的内容如下：

```json
{
    "status": "success",
    "message": "table queried rows successfully",
    "data": [
        {
            "active": true,
            "age": 25,
            "meta": {
                "editor": "system"
            },
            "name": "Leon Ding",
            "score": 95.5,
            "tags": [
                "admin",
                "user"
            ]
        }
    ]
}
```

根据指定的筛选条件，对 **users** 命名空间中的数据记录进行部分字段的内容更新操作，这个操作类似于关系数据库 SQL 中的 `UPDATE ... SET ... WHERE ... `语句，代码示例如下：

```bash
curl -X PATCH "http://192.168.31.221:2668/tables/users" \
  -H "Auth-Token: ex224JWgK5H6sKhpNk5ZbWKzM" \
  -H "Content-Type: application/json" \
  -d '{
    "wheres": {
      "name": "Leon Ding",
      "active": true
    },
    "sets": {
      "age": 26,
      "name": "Leon",
      "meta": {
        "editor": "system"
      }
    }
  }'
```

如果上面操作执行成功，会修改该命名空间中所匹配到数据记录中的值，HTTP 会响应返回 JSON 格式的内容如下：

```json
{
    "status": "success",
    "message": "table rows patched successfully"
}
```

对 **users** 命名空间中已有的数据记录执行条件删除操作，类似于关系数据库 SQL 中的 `DELETE FROM ... WHERE ...` 的语句，代码如下：

```bash
curl -X DELETE "http://192.168.31.221:2668/tables/users/rows" \
  -H "Auth-Token: NjqwUvtNP6XQGeABhgwXIDcNw" \
  -H "Content-Type: application/json" \
  -d '{
    "wheres": {
      "name": "Leon Ding"
    }
  }'
```

如果上面操作执行成功，会删除该命名空间中所匹配到数据记录，HTTP 会响应返回 JSON 格式的内容如下：

```json
{
    "status": "success",
    "message": "table rows remove successfully"
}
```

下面操作会删除 **users** 命名空间，这意味着 **users** 命名空间中存储的数据记录都会被删除，类似于关系数据库 SQL 中的 `DROP TABLE ...` 语句，代码如下：

```bash
curl -X DELETE "http://192.168.31.221:2668/tables/users" \
  -H "Auth-Token: 43CmqMY6r7jndrjUC7cxyJ1SV"
```

如果上面操作执行成功会删除该命名空间所有数据，HTTP 会响应返回 JSON 格式的内容如下：

```json
{
    "status": "success",
    "message": "table deleted successfully"
}
```

> [!WARNING]
> Table 是一组多个对象记录组成集合，同一个 Table 命名空间随着不断插入新的数据，会导致 Table 越来越大并且有锁的开销，多条记录共享一把 Table 锁有性能损失，所有不建议在单个 Table 命名空间中存储数据较多数据记录。

## 📂 Record 命名空间

> [!TIP]
> **Record** 命名空间的结构类似 MongoDB 中的 Document 结构，Record 通常直接映射编程语言中的 class 的一条记录，OOP 面向对象编程中的对象可以直接映射为 Record 记录。在高并发场景下 Record 一条记录对应一把锁，有着事物处理性能高的优势。Record 一段创建就不能改了，适应场景就是更新不频繁的数据，例如社交论坛系统中帖子功能，一条帖子可以对应一条 Record 记录，如果更新了直接设置一条新的 Record 映射即可。


创建一条名为 **142857** 的 Record 命名空间，并设置所需存储的数据记录值。例如一张帖子的抽象，操作示例如下：

```bash
curl -X PUT "http://192.168.101.252:2668/records/142857" \
  -H "Content-Type: application/json" \
  -H "Auth-Token: yv2PH82JXfm2UpScAQK37iJVI" \
  -d '{
    "record": {
      "title": "Hello UrnaDB: My First Post",
      "author": "Leon Ding",
      "content": "This is a forum post stored inside UrnaDB.\n\n",
      "category": "tech",
      "tags": ["nosql", "database"],
      "views": 123,
      "published": true
    },
    "ttl": 3600
  }'
```

上面命令执行成功之后 HTTP 会响应返回 JSON 格式的内容如下：

```json
{
    "status": "success",
    "message": "record created successfully"
}
```

> [!IMPORTANT]
> 这个 **142857** 可以看作是一篇文章的 POST ID 编号，业务层只需要提供这个 ID 就可以查询到这条帖子数据，类似于关系数据库中一条记录的唯一主键；同样在创建 Record 记录数据时可以指定 `ttl` 字段，`ttl` 的值单位是秒用来设置 Record 的生命周期。

在 Record 命名空间中查询一条名为 **142857** 的数据记录，操作示例如下：

```bash
curl -X GET http://192.168.31.221:2668/records/142857 \
  -H "Auth-Token: dw8PDCPRQcrIVIekL4UheS9ra"
```

如果执行成功会返回 **142857** 中存储的完整数据记录：

```json
{
    "status": "success",
    "message": "record queried successfully",
    "data": {
        "author": "Leon Ding",
        "category": "tech",
        "content": "This is a forum post stored inside UrnaDB.\n\n",
        "published": true,
        "tags": [
            "nosql",
            "database"
        ],
        "title": "Hello UrnaDB: My First Post",
        "views": 123
    }
}
```

对已存在的 **142857** 数据记录查询某个 `column` 操作，类似于关系数据库 SQL 中的 `SELECT column FROM ...` 语句，例如搜索查询操作示例：

```bash
curl -X POST "http://192.168.101.252:2668/records/142857" \
  -H "Auth-Token: yv2PH82JXfm2UpScAQK37iJVI" \
  -H "Content-Type: application/json" \
  -d '{
    "column": "tags"
  }'
```

如果上面请求执行成功，会返回 **142857** 中 `tags` 字段所存储的数据记录，HTTP 会响应返回 JSON 格式的内容如下：

```json
{
    "status": "success",
    "message": "search completed successfully",
    "data": [
        [
            "nosql",
            "database"
        ]
    ]
}
```

对已经存在的 **142857** 记录执行删除操作，这个对应着关系数据库 SQL 中的 `DROP TABLE ...` 语句，代码如下：

```bash
curl -X DELETE "http://192.168.101.252:2668/records/142857" \
  -H "Auth-Token: yv2PH82JXfm2UpScAQK37iJVI"
```

如果上面请求执行成功会删除对应的 **142857** 中所存储的数据记录，HTTP 会响应返回 JSON 格式的内容如下：

```json
{
    "status": "success",
    "message": "record deleted successfully"
}
```

## 📦 Variant 命名空间

> [!TIP]
> **Variant** 命名空间是一个通用的动态数据容器，可用于存储多种基础数据类型，例如 String、Boolean、Integer 和 Double 等，它为不同类型的数据提供了统一的 API，使业务层能够以一致且灵活的方式进行操作。


在 Variant 命名空间中，具体的数据类型由首次写入的值决定，并在后续操作中保持一致，例如创建一个名为 **views** 的 Variant 命名空间，它的值是整数 Integer 基础数据类型，示例如下：

```bash
curl -X PUT "http://192.168.101.252:2668/variants/views" \
  -H "Auth-Token: yv2PH82JXfm2UpScAQK37iJVI" \
  -H "Content-Type: application/json" \
  -d '{
    "variant": 0
  }'
```

如果上面命令执行成功会返回 **views** 命名空间初始值，HTTP 会响应返回 JSON 格式的内容如下：

```json
{
    "status": "success",
    "message": "variant created successfully",
    "data": {
        "variant": 0
    }
}
```

> [!IMPORTANT]
> 同样在创建 Variant 命名空间时可以指定 `ttl` 来设置生命周期，其值单位为秒。

当 **views** 创建并初始化成功后，即可对其数值执行类似 Redis 中的 INCR 自增操作，示例如下：

```bash
curl -X POST "http://192.168.101.252:2668/variants/views" \
  -H "Auth-Token: yv2PH82JXfm2UpScAQK37iJVI" \
  -H "Content-Type: application/json" \
  -d '{
    "delta": 1
  }'
```

如果 INCR 自增操作命令执行成功，HTTP 会响应返回 JSON 格式的内容如下：

```json
{
    "status": "success",
    "message": "variant incremented successfully",
    "data": {
        "variant": 1
    }
}
```

> [!IMPORTANT]
> 请求体中的 `delta` 值可以是 -1 负数，这样就可以实现原子自减操作。如果 Variant 中存储的是 Boolen 和 String 这些操作就会失效，并返回类型错误信息。


获取名为 **views** 的命名空间中的值，示例如下：

```bash
curl -X GET "http://192.168.101.252:2668/variants/views" \
  -H "Auth-Token: yv2PH82JXfm2UpScAQK37iJVI"
```

HTTP 会响应返回 JSON 格式的内容如下：

```json
{
    "status": "success",
    "message": "variant queried successfully",
    "data": {
        "variant": 1
    }
}
```


## 🔐 Lock 命名空间

> [!TIP]
> **Lock** 命名空间是一个分布式租期锁服务，用于在分布式环境中协调多个客户端对共享资源的访问，能实现类似于基于 Redis 和 ETCD 分布式锁服务的功能。**Lock** 命名空间特别适用于需要确保数据一致性的场景，如分布式任务调度、资源分配、配置更新等操作，为分布式应用提供了可靠的同步机制。

Lock 提供的它提供了以下核心功能：

1. **互斥锁定**：确保同一时间只有一个客户端能够获取特定的锁。
2. **自动过期**：支持设置锁的超时时间，防止死锁情况。
3. **锁续期**：允许持有锁的客户端延长锁的有效期。
4. **非阻塞获取**：支持尝试获取锁而不阻塞当前线程。
5. **锁状态查询**：可以查询锁的当前状态和持有者信息。


在 Lock 命名空间中创建一个名为 **orders** 的分布式租期锁，锁的名称通常对应需要保护的资源标识符，这样可以通过锁名直接关联到具体的业务资源。通过 **orders** 这个锁名，可以方便地查询锁的当前状态、持有者信息以及剩余租期时间，实现对订单相关操作的分布式同步控制，示例如下：

```bash
curl -X PUT "http://192.168.101.252:2668/locks/orders" -v \
  -H "Auth-Token: yv2PH82JXfm2UpScAQK37iJVI" \
  -H "Content-Type: application/json" \
  -d '{
    "ttl": 30
  }'
```

如果上锁成功会返回对应锁的 Token 凭证，这个 Token 是方便于客户端续租和解锁使用的，HTTP 会响应返回 JSON 格式的内容如下：

```json
{
    "status": "success",
    "message": "lock created successfully",
    "data": {
        "token": "01KBCNZY9C5XM8YDT835SHW4GN"
    }
}
```

当上锁成功后客户端可以安全地执行资源相关的业务操作，在有效租期内，客户端对资源的独占访问是受保护的。但在实际业务场景中客户端的操作时间可能超出预期的锁租期，为了防止锁自动过期导致其他客户端意外获取锁，当客户端需要延长持锁时间时，应主动对锁进行续租操作，确保在业务完成前始终保持对资源的独占控制，示例如下：

```bash
curl -X PATCH "http://192.168.101.252:2668/locks/orders" \
  -H "Auth-Token: yv2PH82JXfm2UpScAQK37iJVI" \
  -H "Content-Type: application/json" \
  -d '{
    "token": "01KAXPB8D4MNMG731BBZ8MAV28"
  }'
```


如果对锁续租成功，HTTP 会响应返回 JSON 格式的内容如下：

```json
{
    "status": "success",
    "message": "lease acquired successfully",
    "data": {
        "token": "01KBCP1V7GF9CF27PCJDEAT961"
    }
}
```

客户端对持有的锁进行提前释放和解锁，解锁时同样需要带有锁对应的 Token 凭证，示例如下：

```bash
curl -X DELETE "http://192.168.101.252:2668/locks/orders" \
  -H "Auth-Token: yv2PH82JXfm2UpScAQK37iJVI" \
  -H "Content-Type: application/json" \
  -d '{
    "token": "01KBCP1V7GF9CF27PCJDEAT961"
  }'
```

如果解锁成功，HTTP 会响应返回 JSON 格式的内容如下：

```json
{
    "status": "success",
    "message": "lock deleted successfully"
}
```

> [!WARNING]
> 本篇文档将帮助开发者理解 UrnaDB 支持的数据结构及其对应的 HTTP API 设计，借助这些统一的接口，开发者可以基于任意编程语言实现自己的 SDK 或进一步扩展 UrnaDB 的能力。


## 🌡️ 指标监控
> [!TIP]
> 除了基础的命名空间数据操作接口之外，UrnaDB 还提供方便指标监控 HTTP API 接口，客户端可以通过此接口来获取服务端健康状态数据信息。


使用 **GET** 类型的 HTTP 请求发送至 UrnaDB 的 HTTP API 根端点，即可返回具体的指标监控 JSON 数据信息：

```bash
curl -X GET "http://192.168.101.252:2668/" \
  -H "Auth-Token: yv2PH82JXfm2UpScAQK37iJVI" \
  -H "Content-Type: application/json"
```

HTTP 会响应返回 JSON 格式的内容如下：

```json
{
    "key_count": 1,
    "gc_state": 0,
    "disk_free": "28.09GB",
    "disk_used": "84.62GB",
    "disk_total": "112.71GB",
    "mem_free": "1.50GB",
    "mem_total": "8.00GB",
    "disk_percent": "75.08%",
    "space_total": "0.00GB"
}
```

