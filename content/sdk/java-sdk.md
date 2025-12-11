---
title: Java SDK
type: docs
prev: sdk/
next: sdk/javascript-sdk
weight: 1
---

Java 是当今最流行、使用最广泛的编程语言，因此 UrnaDB 首先提供对 Java 的支持。UrnaDB 的 Java SDK 为开发者提供了简洁高效的数据库操作接口，使您能够轻松将 UrnaDB 集成到 Java 应用程序中。通过 Java SDK 可以充分利用 Java 语言的静态类型系统和丰富的生态工具链，实现类型安全的数据操作和完善的 IDE 智能提示支持。

## SDK 功能

1. **类型安全** 利用 Java 强类型系统，在编译期发现潜在错误，提供完整的类型检查和 IDE 智能提示。SDK 通过泛型和注解机制确保数据类型的正确性，避免运行时类型转换异常，让开发者在编写代码时就能发现潜在问题。

2. **简单易用** 提供直观的 API 设计，无需学习复杂的 SQL 语法，通过方法链式调用完成数据操作，使用 Lambda 函数式编程风格进行数据交互操作，采用 Builder 模式和流式 API 设计，让数据库操作代码更加简洁易读，降低学习成本和维护难度。

3. **高性能** 基于 HTTP 连接池和异步处理机制，支持高并发场景下的数据库访问，内置智能连接管理、请求批处理和响应缓存机制，在保证数据一致性的同时最大化吞吐量和响应速度。

4. **完整功能** 支持 UrnaDB 的所有数据类型和操作，包括 Table、Record、Variant、Lock 等命名空间，提供事务控制、批量操作、条件查询等高级功能，满足复杂业务场景的数据处理需求。

## 快速开始

Java SDK 目前仅支持 Maven 项目依赖包构建管理工具，用户可以根据项目需要选择合适的依赖管理方式，SDK 要求兼容 JavaSE 17 或更高版本。

### Maven 依赖

在你的工程项目中的 `pom.xml` 文件中添加如下依赖：

```xml
<dependency>
    <groupId>io.github.urnadb</groupId>
    <artifactId>urnadb-java-sdk</artifactId>
    <version>1.0.0</version>
</dependency>
```

### Gradle 依赖

```gradle
implementation 'io.github.urnadb:urnadb-java-sdk:1.0.0'
```

敬请期待更多详细内容 🚚 ！