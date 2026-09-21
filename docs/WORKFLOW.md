# 项目工作流（Workflow）

本文档记录「体育场馆预约系统」从**读题 → 开发 → 测试 → 出图 → 写报告 → 交付**的完整工作流。整套流程在本地 macOS 环境完成，包含 AI 协作部分的实际操作路径。

---

## 总览

```
① 需求拆解        读卷出题 → 五选一定选题 → 定技术栈
        ↓
② 环境准备        检测 JDK / Maven / MySQL → 重置密码 → 启动服务
        ↓
③ 数据库建模      E-R 设计 → 建表 SQL → 测试数据
        ↓
④ 框架搭建        Maven war 工程 → SSM 四大配置文件
        ↓
⑤ 编码实现        entity → mapper(xml) → service(impl) → controller → interceptor
        ↓
⑥ 前端页面        JSP + JSTL + CSS（前台 6 页 + 后台 6 页）
        ↓
⑦ 单元测试        JUnit4 + Spring Test（27 个 @Test）
        ↓
⑧ 构建验证        mvn compile → mvn test → mvn package
        ↓
⑨ 运行验证        mvn jetty:run → curl 全链路接口测试 → 浏览器端到端
        ↓
⑩ 截图取证        浏览器截图 11 张
        ↓
⑪ 报告图件        SVG 绘制 → 浏览器渲染 → PNG（功能结构图 / E-R 图 / 类图）
        ↓
⑫ 报告排版        Markdown 写稿 → 代码块转 HTML → 填入 docx 模板 → 插图
        ↓
⑬ 交付            封面信息 → 更新目录 → 打印装订
```

---

## ① 需求拆解

**输入**：《SSM框架开发技术项目实战》考查试卷（`.doc`）+ 考查报告模板（`.docx`）

读取方式：本地文档编辑 SDK（`doc_resolve_document_structure`）解析全文。

**决策点 1 — 选题**：五选一（体育场馆预约 / 美食评价 / 社团活动 / 旅游攻略 / 跑腿需求）

选 **体育场馆预约系统**，理由：
- 实体关系典型：user ↔ venue 构成多对多，E-R 图有内容可画
- CRUD 逻辑清晰，预约冲突校验可作为技术亮点
- 答辩时业务背景容易讲清楚

**决策点 2 — 技术栈**：选 **SSM + JSP**（非 SpringBoot、非前后端分离）
- 课程名就是「SSM 框架开发技术项目实战」，用原生 SSM 最贴合
- 答辩时老师大概率追问 `web.xml`、`applicationContext.xml` 配置细节，纯 SSM 全都能答得上
- 单体工程，不需要搭建两个项目

---

## ② 环境准备

本机 macOS 环境检测：

```bash
java -version                    # JDK 8 (Corretto 1.8.0_482)
mvn -version                     # Maven 3.9.15
mysql.server status              # MySQL 9.6 (Homebrew)
lsof -i :3306
```

**MySQL 密码重置**（忘记 root 密码时）流程：

```bash
# 1. 停服务
mysql.server stop && pkill -f mysqld

# 2. 跳过权限表启动
/opt/homebrew/opt/mysql/bin/mysqld_safe --skip-grant-tables --skip-networking &
sleep 5

# 3. 清空 authentication_string 字段
mysql -uroot -e "UPDATE mysql.user SET authentication_string='' WHERE User='root' AND Host='localhost';"

# 4. 正常重启并设置新密码
pkill -f mysqld; sleep 4; mysql.server start
mysql -uroot -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '123456'; FLUSH PRIVILEGES;"
```

> 注意 MySQL 8+ 装了 `validate_password` 组件时，弱密码会被拒绝，需要先 `UNINSTALL COMPONENT` 或调低策略。

---

## ③ 数据库建模

**E-R 模型**（5 实体）：

```
user ──< reservation >── venue          user ──< review >── venue
                          │
                       category
```

**转换规则**：两个多对多关系各生成一张关联表（`reservation`、`review`），实际这两张表自身也携带业务属性（预约时段、金额、评分），因此直接作为实体表存在。

**要点**：所有表和字段显式指定 `utf8mb4`，避免中文乱码和 emoji 无法存储。

---

## ④ 框架搭建

Maven war 工程，四份核心配置：

| 文件 | 职责 |
|---|---|
| `web.xml` | DispatcherServlet、CharacterEncodingFilter、ContextLoaderListener |
| `spring/applicationContext.xml` | 数据源(Druid)、SqlSessionFactory、Mapper 扫描、事务管理器 |
| `spring/spring-mvc.xml` | Controller 扫描、`@ResponseBody`(Jackson)、静态资源映射、视图解析器、拦截器 |
| `mybatis-config.xml` | 驼峰命名映射、别名、Mapper XML 注册 |

**分层依赖方向**：Controller → Service → Mapper → DB，单向依赖，实体类贯穿各层。

---

## ⑤ 编码实现顺序

严格按依赖顺序，每完成一层跑一次编译：

```
entity（5 个）
    ↓
mapper 接口 + mapper XML（5 组，含动态 SQL <if> <where> <foreach>）
    ↓
service 接口 + impl（5 组，@Service + @Transactional）
    ↓
interceptor（LoginInterceptor：未登录跳登录页 / 普通用户访问 admin 返回 403）
    ↓
controller（6 个：PageController 负责 JSP 跳转，其余 5 个负责业务 REST 接口）
```

**核心业务逻辑三处**：

1. **预约冲突校验** — 用 MyBatis 动态 SQL 查询时段重叠：
   ```sql
   WHERE venue_id = #{venueId}
     AND status != 'CANCELLED'
     AND NOT (end_time <= #{startTime} OR start_time >= #{endTime})
   ```
2. **费用自动计算** — 分钟数向上取整到半小时：`ceil(minutes / 30.0) * 30 / 60 * pricePerHour`
3. **评价平均分回流** — 评价写入后用 `AVG(rating)` 聚合更新 `venue.avg_rating` 和 `review_count`

---

## ⑥ 前端页面

纯 JSP + JSTL，无第三方 UI 框架（作业场景要求手写）。

- 前台 6 页：首页、登录、注册、场地详情、我的预约、通用头/尾
- 后台 6 页：场地管理、场地编辑、分类管理、预约管理、评价管理、用户管理 + 侧边栏

通过 `<%@ include %>` 复用 header / footer / admin-side，避免重复代码。

---

## ⑦ 单元测试

JUnit4 + `SpringJUnit4ClassRunner`，加载完整 Spring 容器打真实数据库：

```java
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {
    "classpath:spring/applicationContext.xml",
    "classpath:spring/spring-mvc.xml"
})
public class ReservationServiceTest { ... }
```

**27 个用例**覆盖：登录成功/失败/禁用、注册重复、角色权限、**预约冲突**、费用进位、状态流转、取消预约、场地 CRUD、**分类删除约束**、评价提交与平均分统计。

---

## ⑧ 构建与运行验证

```bash
export JAVA_HOME=~/Library/Java/JavaVirtualMachines/corretto-1.8.0_482/Contents/Home
mvn -q compile -DskipTests     # 首次会下载依赖，约几分钟
mvn test                       # 27 个测试全绿
mvn -q package -DskipTests     # 生成 target/venue-reservation.war
mvn jetty:run                  # 启动，访问 http://localhost:8080
```

**接口层全链路验证**（curl）：

```bash
# 登录建立 session
curl -c /tmp/c.txt -X POST http://localhost:8080/login -d "username=zhangsan&password=123456"

# 提交预约
curl -b /tmp/c.txt -X POST http://localhost:8080/reservation/create \
  -d "venueId=2&startTime=2026-09-22 14:00&endTime=2026-09-22 16:00&remark=接口测试"

# 冲突校验（同一时段重复预约应被拒绝）
curl -b /tmp/c2.txt -X POST http://localhost:8080/reservation/create \
  -d "venueId=2&startTime=2026-09-22 15:00&endTime=2026-09-22 17:00"

# 权限控制：未登录访问后台 → 302；普通用户访问后台 → 403
curl -o /dev/null -w "%{http_code}" http://localhost:8080/admin/venue/list
```

> macOS 本地 curl 可能被系统代理拦截，建议加 `--noproxy '*'`。

---

## ⑨ 截图取证

用无头浏览器（`agent-browser`）跑端到端流程并截图：

```bash
agent-browser open http://localhost:8080/index
agent-browser screenshot 01-index.png --full

# 遇到 type 命令填表不稳时，改用同步 XHR 登录
agent-browser eval "var x=new XMLHttpRequest();x.open('POST','/login',false);\
  x.setRequestHeader('Content-Type','application/x-www-form-urlencoded');\
  x.send('username=zhangsan&password=123456');x.responseText"
```

产出 11 张截图存入 `screenshots/`，序号与报告图号（图 3-x）一一对应。

---

## ⑩ 报告图件制作

不用 Visio，**手写 SVG + 浏览器渲染**成 PNG，可完全控制样式：

```bash
# 1. 编写 SVG（务必显式写 width/height，否则渲染尺寸不可控）
vim docs/fig2-er.svg

# 2. 浏览器渲染截图
agent-browser open "file:///path/to/fig2-er.svg"
agent-browser screenshot fig2-er.png --full
```

三张图：
- `fig1-structure.png` — 功能结构层次图（1200×820）
- `fig2-er.png` — E-R 图（1080×920，卡片式布局，避免属性连线交叉）
- `fig3-class.png` — 类图（1200×940，四层：Controller / Service / Mapper / Entity）

---

## ⑪ 报告排版流水线

模板是 `.docx`，需要在保留封面和章节样式的**前提下**填入内容。使用本地文档编辑 SDK 操作。

**踩到的坑**：`doc_insert_markdown` 会把 markdown 里的代码块（\`\`\`）**漂移**到普通文字之后，导致多处代码块错位堆叠。

**解决方案 — 锚点替换法**：

```
1. 章节正文（不含代码块）写成 xxx-text.md
2. 脚本把代码块抽出来，逐个转成 <p style="font-family:Consolas"> + <br> 的 HTML
3. 正文里代码块位置留锚点： 【代码块-conflict-sql】
4. 先 insert_markdown 插正文  →  再对每个锚点：doc_find 定位 → insert_html_content 插入代码 → delete_paragraph 删锚点段
```

关键坐标管理经验：

> **删除段落会让后续所有段落 index 前移**。批量删除时要么从后往前删，要么每删一段重新定位。混用「先 replace 清空再循环 delete」极易越界误删后续内容（曾因此删掉了图题段，只能从干净模板重做）。

流程总结：

```
md 正文写稿 → split_code.py 拆代码块 → 锚点版 md + 各代码块 html
    → doc_insert_markdown(正文) → 逐个锚点查/插/删 → doc_insert_image(插图) → save_file
```

**图片插入**：`doc_insert_image(file_id, idx, image_path, w, h)`，`w=570`（≈A4 正文宽度），`h` 按原图比例换算。插完记得 `doc_insert_paragraph` 补一个空段落，避免图片与图题粘连。

**收尾自检**：

```bash
# 检查占位符残留：本小节 / XX系统 / ×××× / 【代码块 / project-name
# 检查图片数量应为 14（3 张报告插图 + 11 张运行截图）
```

---

## ⑫ 交付清单

| 步骤 | 内容 |
|---|---|
| 补封面信息 | 班级 / 学号 / 姓名（个人信息不入库，手工填写） |
| 更新目录 | Word/WPS 打开 → 选中目录 → F9 更新域（页码对齐） |
| 打印装订 | 试卷（双面，最前） → 报告封面（单面） → 报告正文（双面，最后） |

---

## 环境速查

```bash
# 启动数据库
mysql.server start

# 启动系统
cd venue-reservation
export JAVA_HOME=~/Library/Java/JavaVirtualMachines/corretto-1.8.0_482/Contents/Home
mvn jetty:run

# 停止：Ctrl-C，或
pkill -f "jetty:run"
```

凭证：MySQL `root / 123456`（本机开发库），测试账号 `admin/123456`、`zhangsan/123456`。
