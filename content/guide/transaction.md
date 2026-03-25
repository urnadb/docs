---
title: 原子事物
type: docs
prev: guide/operations
next: guide/recovery
weight: 8
---

事务 **Transaction** 是数据库系统中的基础机制，**Transaction** 用于保证数据操作时的正确性与可靠性而提出的一组核心约束。事物必须具备的 <span style="color:red">**ACID**</span> 四个核心特性，**ACID** 的缩写缩写源自于：原子性 <span style="color:red">**A**</span>tomicity、一致性 <span style="color:red">**C**</span>onsistency、隔离性 <span style="color:red">**I**</span>solation 和持久性 <span style="color:red">**D**</span>urability；有了 **ACID** 的约束确保了一组数据库操作即使在故障时也能保持数据的一致性和可靠性，实现数据从一个合法状态向另一个合法状态的转换，使其执行运算过程中没有其他异常状态的产生。

目前工业级主流数据库产品 Oracle、SQLServer、MySQL、PostgreSQL、Redis、MongoDB、DynamoDB 都有对 **Transaction** 特性的支持，但具体实现细节有着天壤之别。同样按照数据库类型分类：关系型数据库如 Oracle、SQLServer、MySQL、PostgreSQL 的事务实现通常基于 SQL 标准并完整支持 ACID 特性；而 NoSQL 数据库如 Redis、MongoDB、DynamoDB 的事务机制则没有统一标准，通常根据系统设计在原子性、隔离性等方面提供不同级别的支持，部分系统甚至仅支持单操作原子性。