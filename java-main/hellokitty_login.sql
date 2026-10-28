/*
 Navicat Premium Dump SQL

 Source Server         : test
 Source Server Type    : MySQL
 Source Server Version : 80039 (8.0.39)
 Source Host           : localhost:3306
 Source Schema         : hellokitty_login

 Target Server Type    : MySQL
 Target Server Version : 80039 (8.0.39)
 File Encoding         : 65001

 Date: 28/10/2026 09:47:19
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for goods
-- ----------------------------
DROP TABLE IF EXISTS `goods`;
CREATE TABLE `goods`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '商品名称',
  `emoji` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '展示图标（emoji）',
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '分类/标签',
  `price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '价格',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '描述',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_name`(`name` ASC) USING BTREE,
  INDEX `idx_category`(`category` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '商品表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of goods
-- ----------------------------
INSERT INTO `goods` VALUES (1, 'Hello Kitty 公仔', '🧸', '周边', 99.00, '经典 Hello Kitty 毛绒公仔', '2026-10-28 08:57:01');
INSERT INTO `goods` VALUES (2, '草莓发卡', '🎀', '配饰', 19.90, '甜美草莓造型发卡', '2026-10-28 08:57:01');
INSERT INTO `goods` VALUES (3, '粉色笔记本', '📒', '文具', 25.00, '少女心粉色封面笔记本', '2026-10-28 08:57:01');
INSERT INTO `goods` VALUES (4, '猫咪抱枕', '🐱', '家居', 59.00, '软萌猫咪抱枕', '2026-10-28 08:57:01');
INSERT INTO `goods` VALUES (5, '樱花水杯', '🥤', '生活', 39.90, '樱花季限定水杯', '2026-10-28 08:57:01');
INSERT INTO `goods` VALUES (6, '奶油蛋糕', '🍰', '美食', 88.00, '草莓奶油蛋糕', '2026-10-28 08:57:01');
INSERT INTO `goods` VALUES (7, '毛绒拖鞋', '🥿', '家居', 29.90, '冬季保暖毛绒拖鞋', '2026-10-28 08:57:01');
INSERT INTO `goods` VALUES (8, '星星发夹', '⭐', '配饰', 15.00, '闪亮星星发夹', '2026-10-28 08:57:01');
INSERT INTO `goods` VALUES (9, '云朵台灯', '💡', '家居', 79.00, '温馨云朵造型台灯', '2026-10-28 08:57:01');
INSERT INTO `goods` VALUES (10, '爱心信封', '💌', '文具', 9.90, '复古爱心信封', '2026-10-28 08:57:01');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名',
  `password` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '密码（MD5加密存储，与 Spring DigestUtils 一致）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'admin', 'e10adc3949ba59abbe56e057f20f883e', '2026-10-28 08:57:01', '2026-10-28 08:57:01');
INSERT INTO `user` VALUES (2, '11', '9fe98f0a0450d5175bed30a2e76a69f6', '2026-10-28 09:38:27', '2026-10-28 09:38:27');

SET FOREIGN_KEY_CHECKS = 1;
