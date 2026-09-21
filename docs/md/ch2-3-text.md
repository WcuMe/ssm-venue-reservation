针对系统核心业务编写了 JUnit 单元测试，测试类基于 Spring Test 框架（@RunWith(SpringJUnit4ClassRunner.class)）加载 applicationContext.xml 容器，直接对 Service 层真实调用数据库进行测试。测试覆盖情况如下表所示：

| 测试类 | 用例数 | 主要覆盖点 |
| --- | --- | --- |
| UserServiceTest | 5 | 登录成功/密码错误/禁用账号拦截、注册重名校验、用户状态变更 |
| ReservationServiceTest | 10 | 预约成功计价、时间格式与先后校验、完全重叠/部分交叉冲突、不冲突相邻时段、半小时进位计价、取消本人/他人预约、状态流转 |
| VenueModuleTest | 12 | 场地列表与多条件搜索、场地增删改、分类关联删除校验、评价提交校验与列表查询 |
| **合计** | **27** | 全部通过（Failures: 0, Errors: 0） |

其中预约模块最核心的冲突校验与计价测试代码如下：

【代码块-test-java】

测试类上标注 @Transactional，每个用例执行完毕后事务自动回滚，不会污染数据库，可反复执行。在 Maven 中执行 mvn test 的运行结果如下：

【代码块-test-result】

27 个测试用例全部通过，表明系统核心业务逻辑（登录校验、预约冲突判断、费用计算、状态流转、关联删除保护等）运行正确。
