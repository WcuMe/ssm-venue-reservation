-- 扩展演示数据：用于第二版报告的截图演示
-- 在 init.sql 之后执行，新增分类 / 场地 / 用户 / 预约 / 评价，
-- 使演示场景与基础脚本区分开（场地评分由关联子查询实时聚合，本脚本不写冗余字段）
-- 幂等设计：先清理本脚本产生的演示数据，再重新插入，可重复执行
-- 执行：mysql -uroot -p --default-character-set=utf8mb4 < sql/init-extend.sql

USE venue_reservation;

-- 0. 清理上一轮演示数据（按名称/账号精确匹配，不影响 init.sql 的基础数据）
DELETE FROM review WHERE venue_id IN (SELECT id FROM venue WHERE name IN
    ('乒乓球1号馆','乒乓球2号馆','综合健身馆','游泳训练池','室外篮球场'));
DELETE FROM reservation WHERE venue_id IN (SELECT id FROM venue WHERE name IN
    ('乒乓球1号馆','乒乓球2号馆','综合健身馆','游泳训练池','室外篮球场'));
DELETE FROM venue WHERE name IN
    ('乒乓球1号馆','乒乓球2号馆','综合健身馆','游泳训练池','室外篮球场');
DELETE FROM category WHERE name IN ('乒乓球馆','健身房');
DELETE FROM review WHERE user_id IN (SELECT id FROM user WHERE username IN ('wangwu','zhaoliu'));
DELETE FROM reservation WHERE user_id IN (SELECT id FROM user WHERE username IN ('wangwu','zhaoliu'));
DELETE FROM user WHERE username IN ('wangwu','zhaoliu');
UPDATE user SET status = 1 WHERE username = 'lisi';

-- 1. 新增两个场地分类
INSERT INTO category (name, description, sort_order) VALUES
    ('乒乓球馆', '室内乒乓球场地，按球台数量计费', 6),
    ('健身房', '力量与有氧训练区域', 7);

-- 2. 新增五个场地（分类 id 用子查询取得，避免依赖自增主键）
INSERT INTO venue (name, category_id, location, capacity, price_per_hour, description, status)
SELECT '乒乓球1号馆', c.id, '体育馆三层东厅', 20, 30.00,
       '八张标准球台，配备专业地胶与照明，适合日常训练与社团活动。', 1
FROM category c WHERE c.name = '乒乓球馆';

INSERT INTO venue (name, category_id, location, capacity, price_per_hour, description, status)
SELECT '乒乓球2号馆', c.id, '体育馆三层西厅', 16, 25.00,
       '六张球台，环境安静，主要面向校内师生开放。', 1
FROM category c WHERE c.name = '乒乓球馆';

INSERT INTO venue (name, category_id, location, capacity, price_per_hour, description, status)
SELECT '综合健身馆', c.id, '体育中心一层', 40, 50.00,
       '有氧区、力量区与自由重量区分区明确，配备跑步机十二台。', 1
FROM category c WHERE c.name = '健身房';

INSERT INTO venue (name, category_id, location, capacity, price_per_hour, description, status)
SELECT '游泳训练池', c.id, '游泳馆副馆', 30, 45.00,
       '六泳道短池，水温常年保持 27 摄氏度，用于教学与训练。', 1
FROM category c WHERE c.name = '游泳馆';

INSERT INTO venue (name, category_id, location, capacity, price_per_hour, description, status)
SELECT '室外篮球场', c.id, '田径场北侧', 24, 60.00,
       '硅 PU 场地两片，夜间照明开放至 22:00。', 1
FROM category c WHERE c.name = '篮球馆';

-- 3. 新增两名普通用户（密码均为 123456）
INSERT INTO user (username, password, real_name, phone, role, status) VALUES
    ('wangwu', '123456', '王五', '13900000005', 'USER', 1),
    ('zhaoliu', '123456', '赵六', '13900000006', 'USER', 1);

-- 4. 新增预约单，覆盖 PENDING / CONFIRMED / FINISHED / CANCELLED 四种状态
INSERT INTO reservation (order_no, user_id, venue_id, start_time, end_time, status, total_price, remark)
SELECT CONCAT('RD', DATE_FORMAT(NOW(), '%Y%m%d'), '0001'),
       u.id, v.id, '2026-09-24 09:00:00', '2026-09-24 11:00:00', 'CONFIRMED', 60.00, '社团训练场地预留'
FROM user u, venue v WHERE u.username = 'wangwu' AND v.name = '乒乓球1号馆';

INSERT INTO reservation (order_no, user_id, venue_id, start_time, end_time, status, total_price, remark)
SELECT CONCAT('RD', DATE_FORMAT(NOW(), '%Y%m%d'), '0002'),
       u.id, v.id, '2026-09-25 18:00:00', '2026-09-25 19:30:00', 'PENDING', 75.00, '课后健身'
FROM user u, venue v WHERE u.username = 'zhaoliu' AND v.name = '综合健身馆';

INSERT INTO reservation (order_no, user_id, venue_id, start_time, end_time, status, total_price, remark)
SELECT CONCAT('RD', DATE_FORMAT(NOW(), '%Y%m%d'), '0003'),
       u.id, v.id, '2026-09-20 16:00:00', '2026-09-20 17:00:00', 'FINISHED', 60.00, '班级友谊赛'
FROM user u, venue v WHERE u.username = 'wangwu' AND v.name = '室外篮球场';

INSERT INTO reservation (order_no, user_id, venue_id, start_time, end_time, status, total_price, remark)
SELECT CONCAT('RD', DATE_FORMAT(NOW(), '%Y%m%d'), '0004'),
       u.id, v.id, '2026-09-21 14:00:00', '2026-09-21 15:30:00', 'CANCELLED', 67.50, '临时有事取消'
FROM user u, venue v WHERE u.username = 'zhaoliu' AND v.name = '游泳训练池';

-- 5. 新增评价记录
INSERT INTO review (user_id, venue_id, rating, content)
SELECT u.id, v.id, 5, '球台很新，灯光也不刺眼，社团每周都来这里训练。'
FROM user u, venue v WHERE u.username = 'wangwu' AND v.name = '乒乓球1号馆';

INSERT INTO review (user_id, venue_id, rating, content)
SELECT u.id, v.id, 4, '场地略小，但价格便宜，适合日常练习。'
FROM user u, venue v WHERE u.username = 'zhaoliu' AND v.name = '乒乓球2号馆';

INSERT INTO review (user_id, venue_id, rating, content)
SELECT u.id, v.id, 5, '器械齐全，有氧区不拥挤，管理很规范。'
FROM user u, venue v WHERE u.username = 'wangwu' AND v.name = '综合健身馆';

INSERT INTO review (user_id, venue_id, rating, content)
SELECT u.id, v.id, 4, '水质不错，就是更衣室柜子有点少。'
FROM user u, venue v WHERE u.username = 'zhaoliu' AND v.name = '游泳训练池';

-- 6. 演示账号禁用：李四账号置为禁用状态（用户管理页可同时展示正常与禁用状态）
UPDATE user SET status = 0 WHERE username = 'lisi';

SELECT '扩展演示数据已就绪' AS result;
