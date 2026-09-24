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
