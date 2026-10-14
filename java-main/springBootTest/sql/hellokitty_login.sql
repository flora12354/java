-- ============================================================
-- Hello Kitty 登录 / 商城系统 - 数据库初始化脚本
-- 数据库：MySQL 8.0+
-- 用法：mysql -uroot -p123456 < hellokitty_login.sql
-- 说明：脚本幂等，可重复执行（不会清空已有数据）
-- ============================================================

-- 创建数据库
CREATE DATABASE IF NOT EXISTS hellokitty_login
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_general_ci;

USE hellokitty_login;

-- ---------- 用户表 ----------
CREATE TABLE IF NOT EXISTS `user` (
  id          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  username    VARCHAR(50)  NOT NULL                COMMENT '用户名',
  password    VARCHAR(64)  NOT NULL                COMMENT '密码（MD5加密存储，与 Spring DigestUtils 一致）',
  create_time DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
  update_time DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (id),
  UNIQUE KEY uk_username (username)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COMMENT = '用户表';

-- 测试账号：admin / 123456（密码为 MD5 加密后的值）
INSERT IGNORE INTO `user` (username, password)
VALUES ('admin', MD5('123456'));

-- ---------- 商品表（支撑首页搜索 /api/search）----------
CREATE TABLE IF NOT EXISTS `goods` (
  id          BIGINT        NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  name        VARCHAR(100)  NOT NULL                COMMENT '商品名称',
  emoji       VARCHAR(16)   NOT NULL DEFAULT ''     COMMENT '展示图标（emoji）',
  category    VARCHAR(50)   NOT NULL DEFAULT ''     COMMENT '分类/标签',
  price       DECIMAL(10,2) NOT NULL DEFAULT 0.00   COMMENT '价格',
  description VARCHAR(255)  NOT NULL DEFAULT ''     COMMENT '描述',
  create_time DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (id),
  KEY idx_name (name),
  KEY idx_category (category)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COMMENT = '商品表';

-- 商品演示数据（与前端首页展示一致，便于后续 /api/search 接入）
INSERT IGNORE INTO `goods` (name, emoji, category, price, description) VALUES
('Hello Kitty 公仔', '🧸', '周边', 99.00,  '经典 Hello Kitty 毛绒公仔'),
('草莓发卡',         '🎀', '配饰', 19.90,  '甜美草莓造型发卡'),
('粉色笔记本',       '📒', '文具', 25.00,  '少女心粉色封面笔记本'),
('猫咪抱枕',         '🐱', '家居', 59.00,  '软萌猫咪抱枕'),
('樱花水杯',         '🥤', '生活', 39.90,  '樱花季限定水杯'),
('奶油蛋糕',         '🍰', '美食', 88.00,  '草莓奶油蛋糕'),
('毛绒拖鞋',         '🥿', '家居', 29.90,  '冬季保暖毛绒拖鞋'),
('星星发夹',         '⭐', '配饰', 15.00,  '闪亮星星发夹'),
('云朵台灯',         '💡', '家居', 79.00,  '温馨云朵造型台灯'),
('爱心信封',         '💌', '文具', 9.90,   '复古爱心信封');
