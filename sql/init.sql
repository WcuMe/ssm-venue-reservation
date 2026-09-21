-- 体育场馆预约系统数据库
DROP DATABASE IF EXISTS venue_reservation;
CREATE DATABASE venue_reservation DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE venue_reservation;

-- 1. 用户表
CREATE TABLE user (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID',
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    password VARCHAR(100) NOT NULL COMMENT '密码',
    real_name VARCHAR(50) COMMENT '真实姓名',
    phone VARCHAR(20) COMMENT '手机号',
    role VARCHAR(20) NOT NULL DEFAULT 'USER' COMMENT '角色：USER普通用户/ADMIN管理员',
    status TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1正常/0禁用',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间'
) COMMENT '用户表';

-- 2. 场地分类表
CREATE TABLE category (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '分类ID',
    name VARCHAR(50) NOT NULL COMMENT '分类名称',
    description VARCHAR(200) COMMENT '分类描述',
    sort_order INT DEFAULT 0 COMMENT '排序号',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) COMMENT '场地分类表';

-- 3. 场地表
CREATE TABLE venue (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '场地ID',
    name VARCHAR(100) NOT NULL COMMENT '场地名称',
    category_id BIGINT NOT NULL COMMENT '所属分类ID',
    location VARCHAR(200) COMMENT '场地位置',
    capacity INT COMMENT '容纳人数',
    price_per_hour DECIMAL(10,2) NOT NULL DEFAULT 0 COMMENT '每小时价格(元)',
    description TEXT COMMENT '场地描述',
    image_url VARCHAR(255) COMMENT '场地图片',
    status TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1开放/0关闭',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    CONSTRAINT fk_venue_category FOREIGN KEY (category_id) REFERENCES category(id)
) COMMENT '场地表';

-- 4. 预约表
CREATE TABLE reservation (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '预约ID',
    order_no VARCHAR(32) NOT NULL UNIQUE COMMENT '预约单号',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    venue_id BIGINT NOT NULL COMMENT '场地ID',
    start_time DATETIME NOT NULL COMMENT '开始时间',
    end_time DATETIME NOT NULL COMMENT '结束时间',
    total_price DECIMAL(10,2) COMMENT '总价(元)',
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING' COMMENT '状态：PENDING待确认/CONFIRMED已确认/CANCELLED已取消/FINISHED已完成',
    remark VARCHAR(200) COMMENT '备注',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '预约时间',
    CONSTRAINT fk_res_user FOREIGN KEY (user_id) REFERENCES user(id),
    CONSTRAINT fk_res_venue FOREIGN KEY (venue_id) REFERENCES venue(id)
) COMMENT '预约表';

-- 5. 评价表
CREATE TABLE review (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '评价ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    venue_id BIGINT NOT NULL COMMENT '场地ID',
    reservation_id BIGINT COMMENT '关联预约ID',
    rating TINYINT NOT NULL DEFAULT 5 COMMENT '评分1-5',
    content VARCHAR(500) COMMENT '评价内容',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '评价时间',
    CONSTRAINT fk_rev_user FOREIGN KEY (user_id) REFERENCES user(id),
    CONSTRAINT fk_rev_venue FOREIGN KEY (venue_id) REFERENCES venue(id),
    CONSTRAINT fk_rev_res FOREIGN KEY (reservation_id) REFERENCES reservation(id)
) COMMENT '评价表';

-- ---------------- 测试数据 ----------------
-- 用户：admin/123456 管理员，zhangsan/123456 普通用户
INSERT INTO user (username, password, real_name, phone, role) VALUES
('admin', '123456', '系统管理员', '13800000000', 'ADMIN'),
('zhangsan', '123456', '张三', '13800000001', 'USER'),
('lisi', '123456', '李四', '13800000002', 'USER');

INSERT INTO category (name, description, sort_order) VALUES
('篮球馆', '标准室内篮球场地', 1),
('羽毛球馆', '专业羽毛球场地', 2),
('游泳馆', '恒温标准泳池', 3),
('足球场', '标准11人制足球场', 4),
('网球馆', '硬地网球场', 5);

INSERT INTO venue (name, category_id, location, capacity, price_per_hour, description, image_url) VALUES
('文华篮球1号馆', 1, '体育馆一楼东侧', 30, 80.00, '标准室内篮球场，木地板，含更衣室', '/static/img/venue1.png'),
('文华篮球2号馆', 1, '体育馆一楼西侧', 30, 80.00, '标准室内篮球场，木地板，灯光充足', '/static/img/venue2.png'),
('羽毛球A馆', 2, '体育馆二楼东侧', 12, 40.00, '8片标准羽毛球场，PVC地胶', '/static/img/venue3.png'),
('羽毛球B馆', 2, '体育馆二楼西侧', 12, 35.00, '6片标准羽毛球场，通风良好', '/static/img/venue4.png'),
('恒温游泳馆', 3, '体育馆负一楼', 50, 60.00, '25米恒温标准泳池，含淋浴间', '/static/img/venue5.png'),
('标准足球场', 4, '田径场中心', 40, 200.00, '11人制天然草坪足球场', '/static/img/venue6.png'),
('室内网球馆', 5, '体育馆三楼', 8, 90.00, '两片硬地网球场，夜间照明', '/static/img/venue7.png');

INSERT INTO reservation (order_no, user_id, venue_id, start_time, end_time, total_price, status, remark) VALUES
('R20260918001', 2, 1, '2026-09-20 14:00:00', '2026-09-20 16:00:00', 160.00, 'CONFIRMED', '同学聚会打球'),
('R20260918002', 3, 4, '2026-09-20 10:00:00', '2026-09-20 12:00:00', 70.00, 'FINISHED', '晨练'),
('R20260919001', 2, 5, '2026-09-21 19:00:00', '2026-09-21 20:00:00', 60.00, 'PENDING', '夜游');

INSERT INTO review (user_id, venue_id, reservation_id, rating, content) VALUES
(3, 4, 2, 5, '场地很干净，地胶弹性好，性价比高！'),
(2, 1, 1, 4, '木地板不错，就是更衣室人多要排队。');
