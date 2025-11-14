---
title: 动态交换
type: docs
prev: guide/tls-http
weight: 7
---

向一张名为 tab-01 的 tables 表中插入一条数据记录，API 操作记录如下：

```shell
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

从一张名为 tab-01 的 tables 表中查询所有的数据记录，API 操作记录如下：

```shell
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
