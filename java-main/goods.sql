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

 Date: 14/10/2026 09:53:15
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for goods
-- ----------------------------
DROP TABLE IF EXISTS `goods`;
CREATE TABLE `goods`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '涓婚敭ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '鍟嗗搧鍚嶇О',
  `emoji` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '灞曠ず鍥炬爣锛坋moji锛',
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '鍒嗙被/鏍囩?',
  `price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '浠锋牸',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '鎻忚堪',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '鍒涘缓鏃堕棿',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_name`(`name` ASC) USING BTREE,
  INDEX `idx_category`(`category` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '鍟嗗搧琛' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of goods
-- ----------------------------
INSERT INTO `goods` VALUES (1, 'Hello Kitty 鍏?粩', '馃Ц', '鍛ㄨ竟', 99.00, '缁忓吀 Hello Kitty 姣涚粧鍏?粩', '2026-10-14 09:27:13');
INSERT INTO `goods` VALUES (2, '鑽夎帗鍙戝崱', '馃巰', '閰嶉グ', 19.90, '鐢滅編鑽夎帗閫犲瀷鍙戝崱', '2026-10-14 09:27:13');
INSERT INTO `goods` VALUES (3, '绮夎壊绗旇?鏈', '馃搾', '鏂囧叿', 25.00, '灏戝コ蹇冪矇鑹插皝闈㈢瑪璁版湰', '2026-10-14 09:27:13');
INSERT INTO `goods` VALUES (4, '鐚?挭鎶辨灂', '馃惐', '瀹跺眳', 59.00, '杞?悓鐚?挭鎶辨灂', '2026-10-14 09:27:13');
INSERT INTO `goods` VALUES (5, '妯辫姳姘存澂', '馃イ', '鐢熸椿', 39.90, '妯辫姳瀛ｉ檺瀹氭按鏉', '2026-10-14 09:27:13');
INSERT INTO `goods` VALUES (6, '濂舵补铔嬬硶', '馃嵃', '缇庨?', 88.00, '鑽夎帗濂舵补铔嬬硶', '2026-10-14 09:27:13');
INSERT INTO `goods` VALUES (7, '姣涚粧鎷栭瀷', '馃タ', '瀹跺眳', 29.90, '鍐??淇濇殩姣涚粧鎷栭瀷', '2026-10-14 09:27:13');
INSERT INTO `goods` VALUES (8, '鏄熸槦鍙戝す', '猸', '閰嶉グ', 15.00, '闂?寒鏄熸槦鍙戝す', '2026-10-14 09:27:13');
INSERT INTO `goods` VALUES (9, '浜戞湹鍙扮伅', '馃挕', '瀹跺眳', 79.00, '娓╅Θ浜戞湹閫犲瀷鍙扮伅', '2026-10-14 09:27:13');
INSERT INTO `goods` VALUES (10, '鐖卞績淇″皝', '馃拰', '鏂囧叿', 9.90, '澶嶅彜鐖卞績淇″皝', '2026-10-14 09:27:13');

SET FOREIGN_KEY_CHECKS = 1;
