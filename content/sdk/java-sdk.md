---
title: Java SDK
type: docs
prev: sdk/
next: sdk/javascript-sdk
weight: 1
---

Java 是当今最流行、使用最广泛的编程语言，因此 UrnaDB 首先提供对 Java 的支持，UrnaDB 的 Java SDK 为开发者提供了简洁高效的数据库操作接口，使开发者用户能够轻松将 UrnaDB 集成到 Java 应用程序中。通过 Java SDK 可以充分利用 Java 语言的静态类型系统和丰富的生态工具链，实现类型安全的数据操作和完善的 IDE 智能提示支持。

## SDK 功能

- **类型安全** 利用 Java 强类型系统，在编译期发现潜在错误，提供完整的类型检查和 IDE 智能提示，SDK 通过泛型和注解机制确保数据类型的正确性，避免运行时类型转换异常，让开发者在编写代码时就能发现潜在问题。

- **简单易用** 提供直观的 API 设计，无需学习复杂的 SQL 语法，通过方法链式调用完成数据操作，使用 Lambda 函数式编程风格进行数据交互操作，采用 Builder 模式和流式 API 设计，让数据库操作代码更加简洁易读，降低学习成本和维护难度。

## 快速开始

> [!IMPORTANT]
> UrnaDB 的 Java SDK 目前仅支持 Maven 项目依赖包构建管理工具，并且 SDK 要求兼容 JavaSE 17 或更高版本。如果用户使用其他构建方式，可以直接下载对应版本的 SDK 的 Jar 包，手动管理依赖和项目构建。在 Maven 项目中，只需在 `pom.xml` 中添加对应版本的 UrnaDB Java SDK 依赖坐标信息，即可确保与 UrnaDB 数据库的兼容性和稳定性。


使用 Maven 构建的项目示例如下：

```xml
<dependency>
    <groupId>io.github.urnadb</groupId>
    <artifactId>urnadb-java-sdk</artifactId>
    <version>1.0.0</version>
</dependency>
```

在添加依赖时请注意 SDK 版本与 UrnaDB 数据库版本的匹配，以确保两者具有良好的兼容性和稳定性。


敬请期待更多详细内容 🚚 ！