---
title: Java SDK
type: docs
prev: sdk/
next: sdk/javascript-sdk
weight: 1
---

Java 是当今最流行、使用最广泛的编程语言，因此 UrnaDB 首先提供对 Java 的支持，UrnaDB 的 Java SDK 为开发者提供了简洁高效的数据库操作接口，使开发者用户能够轻松将 UrnaDB 集成到 Java 应用程序中。通过 Java SDK 可以充分利用 Java 语言的静态类型系统和丰富的生态工具链，实现类型安全的数据操作和完善的 IDE 智能提示支持。

## 🧰 SDK 功能

- **类型安全** 利用 Java 强类型系统，在编译期发现潜在错误，提供完整的类型检查和 IDE 智能提示，SDK 通过泛型和注解机制确保数据类型的正确性，避免运行时类型转换异常，让开发者在编写代码时就能发现潜在问题。

- **简单易用** 提供直观的 API 设计，无需学习复杂的 SQL 语法，通过方法链式调用完成数据操作，使用 Lambda 函数式编程风格进行数据交互操作，采用 Builder 模式和流式 API 设计，让数据库操作代码更加简洁易读，降低学习成本和维护难度。

## 🚀 快速开始

> [!IMPORTANT]
> UrnaDB 的 Java SDK 目前仅支持 Maven 项目依赖包构建管理工具，并且 SDK 要求兼容 JavaSE 17 或更高版本。如果用户使用其他构建方式，可以直接下载对应版本的 SDK 的 Jar 包，手动管理依赖和项目构建。在 Maven 项目中只需在 `pom.xml` 中添加对应版本的 UrnaDB Java SDK 依赖坐标信息，即可获取到 Java SDK 依赖的 Jar 包文件。


使用 Maven 构建的项目，添加 SDK 依赖示例如下：

```xml
<dependency>
    <groupId>io.github.urnadb</groupId>
    <artifactId>urnadb-java-sdk</artifactId>
    <version>1.0.0</version>
</dependency>
```

> 在添加依赖时请注意 SDK 版本与使用的 UrnaDB 数据库版本的匹配，以确保两者具有良好的兼容性和稳定性。


## 📈 Table 命名空间

相较于基于 HTTP 协议的数据交互方式，官方更推荐使用 SDK 来进行操作的，例如使用 Java 语言的 SDK 可以使用 **Lambda** 函数式编程风格进行数据交互操作。下面是创建一张名为 **users** 表并且向 **users** 表中插入一条数据记录，这条操作类似于关系数据库 SQL 中的 **INSERT ... INTO ... VALUES ...** 语句，代码如下：

```java
// 第二参数支持设置 120 秒
var ok = sdk.createTable("users",120);
// tables 支持重载 put 还可以直接插入一个 Object 对象实例
var id = sdk.tables("users").put(p -> {
    p.set("name", "Leon")
     .set("age", 18)
     .set("config", Map.of("theme", "dark", "font", 14))
     .set("meta", new Meta("author", "leon"))
     .set("extra", m -> {
         m.put("role", "admin");
         m.put("verified", true);
     });
});
```

根据条件对 Table 中已有数据记录进行部分字段数据内容更新的操作，这个操作类似于关系数据库 SQL 中的 **UPDATE ... SET ... WHERE ...** 语句，代码示例如下：

```java
var count = sdk.tables("users").patch(p -> {
    p.where(w -> w.eq("name","Leon"));
    p.sets(s -> s
        .set("age", 25)
        .set("active", true)
        .set("meta", m -> {
            m.put("editor", "system");
        })
    );
});
```

对 Table 中已有的数据记录，执行条件删除操作，类似于关系数据库 SQL 中的 **DELETE FROM ... WHERE ...** 的语句，代码如下：

```java
var count = sdk.tables("users").remove(r -> 
    r.where(w -> w.id(4))
);
```

对 Table 中已有的数据记录，执行条件查询操作，类似于关系数据库 SQL 中的 **SELECT * FROM ... WHERE ...** 的语句，代码如下：

```java
var user = sdk.tables("users").query(q -> 
    q.where(w -> w.eq("age", 18))
);
```




敬请期待更多详细内容 🚚 ！