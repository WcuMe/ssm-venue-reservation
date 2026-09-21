本系统采用经典的三层架构（表现层 / 业务层 / 持久层），项目代码结构如下：

```
venue-reservation/
|-- pom.xml                          （Maven 依赖与构建配置）
|-- sql/
|   `-- init.sql                     （建库建表及初始数据脚本）
`-- src/
    |-- main/
    |   |-- java/com/wenhua/venue/
    |   |   |-- controller/          （控制器层：6 个 Controller）
    |   |   |-- service/             （业务层接口）
    |   |   |   `-- impl/            （业务层实现类，@Service + @Transactional）
    |   |   |-- mapper/              （MyBatis Mapper 接口）
    |   |   |-- entity/              （实体类：User/Venue/Category/Reservation/Review）
    |   |   |-- interceptor/         （登录与角色权限拦截器）
    |   |   `-- utils/               （统一响应结果工具类）
    |   |-- resources/
    |   |   |-- mapper/              （MyBatis XML 映射文件）
    |   |   |-- spring/              （applicationContext.xml、spring-mvc.xml）
    |   |   |-- mybatis-config.xml   （MyBatis 全局配置）
    |   |   `-- jdbc.properties      （数据库连接配置）
    |   `-- webapp/
    |       |-- WEB-INF/
    |       |   |-- views/           （JSP 视图：前台页面与 admin 后台页面）
    |       |   `-- web.xml          （Web 配置：DispatcherServlet、编码过滤器）
    |       `-- static/css/          （静态样式资源）
    `-- test/java/com/wenhua/venue/service/   （JUnit 单元测试）
```
