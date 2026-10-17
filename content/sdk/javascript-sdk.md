---
title: JavaScript SDK
type: docs
prev: sdk/java-sdk
weight: 2
---


每个编程语言版本的 SDK 都基于对应语言的语言特性进行实现，JavaScript 版本的 SDK 同样如此，完全基于 ES6 标准编写，充分利用 JavaScript 灵活的函数式编程能力。因此 UrnaDB JavaScript SDK 在 API 设计上采用 Lambda 函数式风格，将函数作为一等公民，使 API 更加简洁、灵活，并能够充分发挥 JavaScript 的语言特性，为熟悉 JavaScript 和函数式编程的开发者提供自然、友好的编程体验。


## 🚀 快速开始 

> [!TIP]
> 在 JavaScript 工程项目中使用 UrnaDB 数据库，只需引入 UrnaDB 提供的 SDK 依赖 npm 包即可开始使用，通常情况下 JavaScript 项目基于 Node.js 和 npm 构建，并采用标准的 npm 工程结构。

在你的计算机中首先配置好 Node.js 运行环境，再在需要使用到 UrnaDB 的项目下执行以下命令，即可安装 UrnaDB SDK依赖包到当前项目中：

```bash
npm install auula/urnadb-js-sdk
```

成功安装 urnadb-js-sdk 依赖包后，开发者只需从 urnadb-js-sdk 模块中导入 UrnaDB 对象，即可创建与远程 UrnaDB 服务器的连接，并通过 SDK 对数据库进行操作，示例代码如下：

```js
// 从 SDK 模块中导入 UrnaDB 对象
import UrnaDB from "urnadb-js-sdk";

// 通过 UrnaDB 静态方法创建 Server 连接对象
const db = UrnaDB.OpenConnection({
    host: "192.168.3.20",
    port: 2668,
    token: "connection-secret-token",
});
```

获取 UrnaDB 数据库连接实例对象后，开发者可以通过 db 连接对象访问 UrnaDB 数据库中不同命名空间所提供的数据模型，并通过对应的 API 对数据库进行操作。下面以查询当前 UrnaDB 数据库运行时状态数据为例，代码示例如下：

```js
// 打开连接远程数据库服务器
const db = UrnaDB.OpenConnection({
    host: "192.168.3.20",
    port: 2668,
    token: "connection-secret-token",
});

// 获取当前的数据库服务器运行状态
const info = await db.serverInfo();

// 远程数据库服务器指标
console.log(`键数量: ${info.keyCount}`);
console.log(`GC 状态: ${info.gcState} (0=初始, 1=执行中, 2=空闲)`);
console.log(`磁盘剩余: ${info.diskFreeSpace}`);
console.log(`磁盘已用: ${info.diskUsedSpace}`);
console.log(`磁盘总量: ${info.diskTotalSpace}`);
console.log(`磁盘使用率: ${info.diskUsagePercent}`);
console.log(`内存可用: ${info.memoryFree}`);
console.log(`内存总量: ${info.memoryTotal}`);
console.log(`数据库存储总量: ${info.totalSpaceUsed}`);
```

开发者在客户端可以通过以上的 API 示例，来获取服务器端数据库的指标数据。


## 📈 Table 命名空间

> [!TIP]
> Table 命名空间用于存储结构化数据，其数据组织方式与传统关系型数据库的 Schema 模型最为接近。为了降低开发者的学习和迁移成本，Table 命名空间的 SDK API 采用了与传统关系型数据库 ORM 框架相近的设计，使开发者能够以熟悉的方式完成数据的创建、查询、更新和删除操作。

下面是一个创建一个名为 **users** 的 Table 命名空间 API 操作示例：

```javascript
test("should create table", async () => {
    // 创建一个名为 users 的命名空间
    const result = await db.createTable("users");
    // 如果创建成功 result.status 的值为 success
    assert.equal(result.status, "success");
});
```

向已有的名为 **users** 的 Table 命名空间中插入数值 API 操作示例：


```javascript
test("should insert row data into table", async () => {
    // 类似于 SQL 关系数据库中的 INSERT INTO 语句操作
    const result = await db.tables("users").put(rows => {
        rows
            .set("name", "Leon Ding")
            .set("age", 26)
            .set("address", address => {
                address
                    .put("🌍 nation", "China")
                    .put("🌆 city", "Shanghai")
                    .put("📧 zipcode", 2000001);
            })
            .set("hobbies", ["🏸️ badminton", "🎮 games", "🎵 music"]);
    });

    assert.equal(result.status, "success");
});
```

根据条件来实现数据记录更新，类似于关系数据库 SQL 的 UPDATE 语句，更新 API 操作示例如下：


```javascript
test("should update table row data", async () => {
    // 更新 name 值为 Leon Ding 的 age 和 address 字段
    const result = await db.tables("users").patch(patch => {
        patch
            .where(where => {
                where.eq("name", "Leon Ding");
            })
            .sets(sets => {
                sets
                    .put("age", 27)
                    .put("address", address => {
                        address
                            .put("🌆 city", "Shanghai")
                    })
            });
    });

    assert.equal(result.status, "success");
});
```

根据条件删除数据记录类似于 SQL 关系数据库中的 DELETE 语句，删除 API 操作示例如下：

```javascript
test("should delete table row data", async () => {
    // 删除 users 表中字段 name 值为 Leon Ding 的数据记录
    const result = await db.tables("users").delete(where => {
        where.eq("name", "Leon Ding");
    });

    assert.equal(result.status, "success");
});
```

根据条件查询数据记录似于 SQL 关系数据库中的 SELECT 语句，查询 API 操作示例如下：

```javascript
test("should query table row data", async () => {
    // 查询 users 表中的 name 字段为 Leon Ding 的数据记录
    const result = await db.tables("users").query(where => {
        where.eq("name", "Leon Ding");
    });

    assert.equal(result.status, "success");

    assert.equal(result.data[0].address["🌆 city"], "Shanghai");
});
```

> [!IMPORTANT]
> 在 UrnaDB 的 Table 命名空间提供了类似于关系型数据库 SQL 事务的操作机制，支持在同一个事务中对多个不同 Table 命名空间中的数据记录进行操作，并通过统一的事务提交确保这些操作作为一个整体完成。


下面是 UrnaDB 中的数据库事物处理 API 代码调用示例如下： 

```javascript

test("should build a transaction with multiple table", async () => {

    const db = UrnaDB.OpenConnection({
        host: "192.168.3.20",
        port: 2668,
        token: "connection-secret-token"
    });

    // UrnaDB ES6 SDK Transaction Example:
    const result = await db.tables().transaction(txns => {
        txns
            // Enable serializable isolation level for this transaction
            .serializable(true)
            .put("users", rows => {
                rows
                    .set("name", "Leon Ding")
                    .set("age", 26)
                    .set("address", address => {
                        address
                            .put("🌍 nation", "China")
                            .put("🌆 city", "Shanghai")
                            .put("📧 zipcode", 200001);
                    })
                    .set("hobbies", ["🏸️ badminton", "🎮 games", "🎵 music"]);
            })
            .patch("users", patch => {
                patch
                    .where(where => {
                        where.eq("name", "Leon Ding");
                    })
                    .sets(sets => {
                        sets
                            .put("address", address => {
                                address
                                    .put("🌆 city", "Singapore");
                            })
                    });
            });
    });

    assert.equal(result.status, "success");
});
```

这段 UrnaDB SDK 代码在关系型数据库 SQL 中对应的是事务中组合执行 INSERT 和 UPDATE 操作，并使用可串行化隔离级别，该 SQL 语句示例如下：

```sql
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

INSERT INTO users (name, age, address, hobbies)
VALUES (
    'Leon Ding',
    26,
    '{"🌍 nation": "China", "🌆 city": "Shanghai", "📧 zipcode": 200001}',
    '["🏸️ badminton", "🎮 games", "🎵 music"]'
);

UPDATE users
SET address = jsonb_set(
    address,
    '{🌆 city}',
    '"Singapore"'
)
WHERE name = 'Leon Ding';

COMMIT;
```