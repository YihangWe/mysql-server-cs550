# Background
尽管 MySQL 作为一个起源于上世纪九十年代中期、经久不衰的关系型数据库管理系统，依然是最受欢迎的数据存储与管理方案之一，但随着新型数据库技术的不断涌现以及对更高效系统需求的增长，持续优化其性能以保持竞争力至关重要。

MySQL 最关键的组件之一是 InnoDB 存储引擎，其核心特性包括事务支持、崩溃恢复、外键约束和多版本并发控制，使其成为当今 MySQL 中使用最广的存储引擎。在高并发、大数据量的使用场景下，资源利用效率往往成为性能瓶颈，因此对 InnoDB 进行有针对性的改进意义重大。

# Enhancement
聚合性能提升
- 引入基于 HyperLogLog 的聚合器，以加速常见的聚合计算。
- 改造 SQL 解析器并设计新的 AI 驱动聚合器，使用户能直接向大型语言模型（LLM）发起查询，获取数据洞察。

缓冲池管理改进
- 用通用时钟算法（GCLOCK）替换当前的 LRU 页面置换策略，以提高页表替换效率。

存储压缩优化
- 采用 Zstandard 压缩算法，增强数据文件的压缩比，降低存储占用。

# Future Work
1. 在 InnoDB 引擎中引入多线程</br>
目前，MySQL 仍沿用经典的 Volcano 式迭代模型，算子按行逐一输出。虽然该设计概念简单，但会带来较高的运行开销，也难以支持算子级的批处理或多线程执行。若能采用批处理或分区执行模型，就能为算子多线程评估提供契机；但这需要对算子接口进行深入重构，并调整内存分配模式与同步机制。虽然改动复杂，但一旦落地，MySQL 的执行架构将更贴近当代数据库引擎的高效设计。

2. 优化事务调度算法</br>
InnoDB 已将默认的锁调度策略由先来先服务升级为最大依赖集优先，以缓解锁竞争导致的性能瓶颈。更进一步的批量 LDSF（bLDSF）策略，则只对部分等待事务批量授予共享锁，而非一次性放行所有共享锁，从而避免拖尾问题——即最慢事务拖慢整个共享群组的进度。要实现 bLDSF，需在 InnoDB 的事务调度器中加入事务分组与批量锁申请的逻辑，并确保与现有的死锁检测和饥饿预防机制（如基于老化的优先级决胜）相兼容。尽管 bLDSF 在实现上更为复杂，但在高并发、高争用的场景中，极有可能带来显著的延迟改进。

# License
Copyright (c) 2000, 2025, Oracle and/or its affiliates.

This is a release of MySQL, an SQL database server.

License information can be found in the LICENSE file.

In test packages where this file is renamed README-test, the license
file is renamed LICENSE-test.

This distribution may include materials developed by third parties.
For license and attribution notices for these materials,
please refer to the LICENSE file.

For further information on MySQL or additional documentation, visit
  http://dev.mysql.com/doc/

For additional downloads and the source of MySQL, visit
  http://dev.mysql.com/downloads/

MySQL is brought to you by the MySQL team at Oracle.
