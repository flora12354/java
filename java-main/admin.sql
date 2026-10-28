-- 后台管理系统：管理员表
-- 使用方法：在 MySQL 中执行（库 hellokitty_login）
-- 默认管理员账号：admin  密码：admin123（MD5 存储）

USE hellokitty_login;

CREATE TABLE IF NOT EXISTS `admin` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `username` varchar(50) NOT NULL COMMENT '管理员用户名',
  `password` varchar(64) NOT NULL COMMENT '密码（MD5）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='后台管理员表';

-- 默认管理员（密码 admin123 的 MD5）
INSERT INTO `admin` (`username`, `password`)
SELECT 'admin', '0192023a7bbd73250516f069df18b500'
WHERE NOT EXISTS (SELECT 1 FROM `admin` WHERE `username` = 'admin');
