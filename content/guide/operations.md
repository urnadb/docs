---
title: 动态交换
type: docs
prev: guide/tls-http
weight: 7
---

向一张名为 `tab-01` 的 Table 数据模型的表中插入一条数据记录，这条操作类似于关系数据库 SQL 中的 `INSERT ... INTO ... VALUES ...` 语句，代码如下：

```bash
curl -X POST http://192.168.31.221:2668/tables/tab-01/rows \ 
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

为 `tab-01` 的 Table 表中查询所有的数据记录，类似于关系数据库 SQL 中的 `SELECT * FROM ...` 语句，也类似于其他文档型关系数据库中的 `findAll` 操作，代码如下：

```bash
curl -X GET http://192.168.31.221:2668/tables/tab-01 \
  -H "Auth-Token: Rd3mFxhcGvul4HN5Twm5YgjDL" \
  -H "Content-Type: application/json"

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

从一张名为 `tab-01` 的 Table 表中查询一条记录，类似于关系数据库 SQL 中的 `SELECT * FROM ... WHERE ...` 的语句，查询条件是表中 `name` 字段的值为 `Leon Ding` 的记录，代码如下：

```bash
 curl -X GET http://192.168.31.221:2668/tables/tab-01/rows  \
  -H "Auth-Token: zSmJeNQ46lFXvmnA7TuttHte3" \
  -H "Content-Type: application/json" \
  -d '{
  "wheres": {
    "name": "Leon Ding"
  }
}'
```


