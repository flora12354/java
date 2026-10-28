-- MySQL dump 10.13  Distrib 8.0.39, for Win64 (x86_64)
--
-- Host: localhost    Database: hellokitty_login
-- ------------------------------------------------------
-- Server version	8.0.39

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `goods`
--

DROP TABLE IF EXISTS `goods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `goods` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` varchar(100) NOT NULL COMMENT '商品名称',
  `emoji` varchar(16) NOT NULL DEFAULT '' COMMENT '展示图标（emoji）',
  `category` varchar(50) NOT NULL DEFAULT '' COMMENT '分类/标签',
  `price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '价格',
  `description` varchar(255) NOT NULL DEFAULT '' COMMENT '描述',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_name` (`name`),
  KEY `idx_category` (`category`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `goods`
--

LOCK TABLES `goods` WRITE;
/*!40000 ALTER TABLE `goods` DISABLE KEYS */;
INSERT INTO `goods` VALUES (1,'Hello Kitty 公仔','🧸','周边',99.00,'经典 Hello Kitty 毛绒公仔','2026-10-28 08:57:01'),(2,'草莓发卡','🎀','配饰',19.90,'甜美草莓造型发卡','2026-10-28 08:57:01'),(3,'粉色笔记本','📒','文具',25.00,'少女心粉色封面笔记本','2026-10-28 08:57:01'),(4,'猫咪抱枕','🐱','家居',59.00,'软萌猫咪抱枕','2026-10-28 08:57:01'),(5,'樱花水杯','🥤','生活',39.90,'樱花季限定水杯','2026-10-28 08:57:01'),(6,'奶油蛋糕','🍰','美食',88.00,'草莓奶油蛋糕','2026-10-28 08:57:01'),(7,'毛绒拖鞋','🥿','家居',29.90,'冬季保暖毛绒拖鞋','2026-10-28 08:57:01'),(8,'星星发夹','⭐','配饰',15.00,'闪亮星星发夹','2026-10-28 08:57:01'),(9,'云朵台灯','💡','家居',79.00,'温馨云朵造型台灯','2026-10-28 08:57:01'),(10,'爱心信封','💌','文具',9.90,'复古爱心信封','2026-10-28 08:57:01');
/*!40000 ALTER TABLE `goods` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-28  8:57:33
