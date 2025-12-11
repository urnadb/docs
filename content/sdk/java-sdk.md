---
title: Java SDK
type: docs
prev: sdk/
next: sdk/javascript-sdk
weight: 1
---

UrnaDB Java SDK 为 Java 开发者提供了简洁、高效的数据库操作接口，让您能够轻松地在 Java 应用程序中集成 UrnaDB 数据库功能。通过 Java SDK，您可以充分利用 Java 语言的静态类型系统和丰富的生态工具链，实现类型安全的数据操作和完善的 IDE 智能提示支持。

## 核心优势

**类型安全** - 利用 Java 强类型系统，在编译期发现潜在错误，提供完整的类型检查和 IDE 智能提示。SDK 通过泛型和注解机制确保数据类型的正确性，避免运行时类型转换异常，让开发者在编写代码时就能发现潜在问题。

**简单易用** - 提供直观的 API 设计，无需学习复杂的 SQL 语法，通过方法链式调用完成数据操作。采用 Builder 模式和流式 API 设计，让数据库操作代码更加简洁易读，降低学习成本和维护难度。

**高性能** - 基于 HTTP 连接池和异步处理机制，支持高并发场景下的数据库访问。内置智能连接管理、请求批处理和响应缓存机制，在保证数据一致性的同时最大化吞吐量和响应速度。

**完整功能** - 支持 UrnaDB 的所有数据类型和操作，包括 Table、Record、Variant、Lock 等命名空间。提供事务控制、批量操作、条件查询等高级功能，满足复杂业务场景的数据处理需求。

## 快速开始

Java SDK 支持 Maven 和 Gradle 两种主流构建工具，您可以根据项目需要选择合适的依赖管理方式。SDK 要求 Java 8 或更高版本，兼容 Spring Boot、Spring Framework 等主流 Java 框架。

### Maven 依赖

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