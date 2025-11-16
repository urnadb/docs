---
title: 数据交互
type: docs
prev: guide/tls-http
weight: 7
---

UrnaDB 内部提供了多种数据结构抽象，例如 Table 、Record 、 Variant 、Lock 类型，这些数据类型对应着常见的业务代码所需使用的数据结构。后续的文档统一称之为 NameSpace 命名空间，同一命名空间中存储都是同一类型的数据模型的数据，了解不同命名空间的数据模型及其特性，有助于开发者根据业务需求选择最合适的数据模型，从而高效实现上层业务功能。


### 📇 Table 命名空间

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
    "data": {
        "message": "table created successfully."
    }
}
```


> [!IMPORTANT]
> 在创建命名空间的时候可以指定该命名空间的生命周期，生命周期是指该命名空间创建之后能存活多久，一般以秒为单位，当到达期限后 UrnaDB 的垃圾回收器会主动删除该命名空间释放其占用的存储空间。


例如在创建 **users** 时通过 `ttl` 字段来指定它的生命周期为 1800 秒，在 1800 秒之后会被垃圾回收器主动删除，代码如下：

```bash
curl -X PUT http://192.168.31.221:2668/tables/users \
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
curl -X POST http://192.168.31.221:2668/tables/users/rows \ 
  -H "Auth-Token: ex224JWgK5H6sKhpNk5ZbWKzM" \
  -H "Content-Type: application/json" \
  -d '{
  "rows": {
    "name": "Leon Ding",
    "age": 25,
    "active": true,
    "score": 95.5,
    "tags": ["admin", "user"],
    "meta": {
      "editor": "system
    }
  }
}
'
```

从 **users** 的命名空间中查询所有的数据记录，类似于关系数据库 SQL 中的 `SELECT * FROM ...` 语句，也类似于其他文档型数据库 MongoDB 中的 `findAll` 操作，代码如下：

```bash
curl -X GET http://192.168.31.221:2668/tables/users  \
  -H "Auth-Token: 73suyb7iNeZsmqhvaxgEn7Ug2"
```

如果上面操作执行成功会返回该命名空间中所有的数据记录，HTTP 会响应返回 JSON 格式的内容如下：

```json
{
    "status": "success",
    "data": {
        "table": {
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
}
```

从名为 **users** 的命名空间中查询一条记录，类似于关系数据库 SQL 中的 `SELECT * FROM ... WHERE ...` 的语句，查询条件是表中 **name** 字段的值为 **Leon Ding** 的记录，代码如下：

```bash
 curl -X GET http://192.168.31.221:2668/tables/users/rows  \
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
    "data": {
        "rows": [
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
            },
        ]
    }
}
```

根据指定的筛选条件，对 **users** 命名空间中的数据记录进行部分字段的内容更新操作，这个操作类似于关系数据库 SQL 中的 `UPDATE ... SET ... WHERE ... `语句，代码示例如下：

```bash
curl -X PATCH http://192.168.31.221:2668/tables/users  \
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
    "data": {
        "message": "table rows updated successfully."
    }
}
```

对 **users** 命名空间中已有的数据记录执行条件删除操作，类似于关系数据库 SQL 中的 `DELETE FROM ... WHERE ...` 的语句，代码如下：

```bash
curl -X DELETE  http://192.168.31.221:2668/tables/users/rows  \ 
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
    "data": {
        "message": "table rows remove successfully."
    }
}
```

下面操作会删除 **users** 命名空间，这意味着 **users** 命名空间中存储的数据记录都会被删除，类似于关系数据库 SQL 中的 `DROP TABLE ...` 语句，代码如下：

```bash
curl -X DELETE  http://192.168.31.221:2668/tables/users \
  -H "Auth-Token: 43CmqMY6r7jndrjUC7cxyJ1SV"
```

如果上面操作执行成功会删除该命名空间所有数据，HTTP 会响应返回 JSON 格式的内容如下：

```json
{
    "status": "success",
    "data": {
        "message": "table deleted successfully."
    }
}
```

> [!WARNING]
> Table 是一组多个对象记录组成集合，同一个 Table 命名空间随着不断插入新的数据，会导致 Table 越来越大并且有锁的开销，多条记录共享一把 Table 锁有性能损失，所有不建议在单个 Table 命名空间中存储数据较多数据记录。

### 📂 Record 命名空间

> [!TIP]
> **Record** 结构类似关 MongoDB 中的 Document 结构，Record 通常直接映射编程语言中的 class 的一条记录，OOP 面向对象编程中的对象可以直接映射为 Record 记录。在高并发场景下 Record 一条记录对应一把锁，有着事物处理性能高的优势。Record 一段创建就不能改了，适应场景就是更新不频繁的数据，例如社交论坛系统中帖子功能，一条帖子可以对应一条 Record 记录，如果更新了直接设置一条新的 Record 映射即可。


创建一条名为 **article-001** 的 Record 命名空间，并设置所需存储的数据记录值。例如一张帖子的抽象，操作示例如下：

```bash
curl -X PUT http://192.168.31.221:2668/records/article-001 \
  -H "Content-Type: application/json" \
  -H "Auth-Token: dw8PDCPRQcrIVIekL4UheS9ra" \
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

> [!IMPORTANT]
> 同样在创建 Record 记录数据时可以指定 `ttl` 字段，来指定 Record 的生命周期。

在 Record 命名空间中查询一条名为 **article-001** 的数据记录，操作示例如下：

```bash
curl -X GET http://192.168.31.221:2668/records/article-001 \
  -H "Auth-Token: dw8PDCPRQcrIVIekL4UheS9ra"
```

如果执行成功会返回 **article-001** 中存储的完整数据记录：

```json
{
    "status": "success",
    "data": {
        "record": {
            "author": "Leon Ding",
            "category": "tech",
            "content": "This is a forum post stored inside UrnaDB.\n\n",
            "published": true,
            "tags": [
                "nosql",
                "database",
            ],
            "title": "Hello UrnaDB: My First Post",
            "views": 123
        }
    }
}
```

对已存在的 **article-001** 数据记录查询某个 `column` 操作，类似于关系数据库 SQL 中的 `SELECT column FROM ...` 语句，例如搜索查询操作示例：

```bash
curl -X POST http://192.168.31.221:2668/records/article-001 \
  -H "Auth-Token: dw8PDCPRQcrIVIekL4UheS9ra" \
  -H "Content-Type: application/json" \
  -d '{
    "column": "tags"
  }'
```

如果上面请求执行成功，会返回 **article-001** 中 `tags` 所存储的匹配的的数据记录，HTTP 会响应返回 JSON 格式的内容如下：

```json
{
  "status": "success",
  "data": {
    "column": [
      ["nosql", "database"]
    ]
  }
}
```

对已经存在的 **article-001** 记录执行删除操作，这个对应着关系数据库 SQL 中的 `DROP TABLE ...` 语句，代码如下：

```bash
curl -X DELETE  http://192.168.31.221:2668/records/article-001 \
  -H "Auth-Token: dw8PDCPRQcrIVIekL4UheS9ra"
```

如果上面请求执行成功会删除对应的 **article-001** 中所存储的数据记录，HTTP 会响应返回 JSON 格式的内容如下：

```json
{
    "status": "success",
    "data": {
        "message": "record deleted successfully."
    }
}
```

### 📦 Variant 命名空间


### 🔐 Lock 分布式锁



