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

 Date: 18/11/2026 09:35:18
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for admin
-- ----------------------------
DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '管理员用户名',
  `password` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '密码（MD5）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '后台管理员表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of admin
-- ----------------------------
INSERT INTO `admin` VALUES (1, 'admin', '0192023a7bbd73250516f069df18b500', '2026-11-09 10:50:47');

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
) ENGINE = InnoDB AUTO_INCREMENT = 49 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '商品表' ROW_FORMAT = DYNAMIC;

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
INSERT INTO `goods` VALUES (11, 'Hello Kitty 大号抱枕公仔 50cm', '🐼', '公仔', 159.00, '50cm大号设计，从床头装饰到沙发靠垫一物两用。莫兰迪粉配奶白蝴蝶结，颜色温柔不甜腻，外套可拆洗，脏了也不用担心。', '2026-11-09 10:59:58');
INSERT INTO `goods` VALUES (12, '迷你 Kitty 挂件公仔', '🎀', '公仔', 29.90, '巴掌大小的迷你挂件公仔，8cm精致尺寸，金属挂扣可挂在书包、钥匙串、手机链上。一套三只不同表情，走到哪带到哪，回头率超高。', '2026-11-09 10:59:58');
INSERT INTO `goods` VALUES (13, 'Kitty & Dear Daniel 情侣公仔', '💕', '公仔', 128.00, 'Kitty和Dear Daniel的CP组合装，一粉一蓝成对出现，五官精致刺绣做工。附赠爱心礼盒包装，纪念日、情人节送礼直接拿捏，拆开就是双倍甜蜜。', '2026-11-09 10:59:58');
INSERT INTO `goods` VALUES (14, 'Hello Kitty 珍珠项链', '📿', '配饰', 69.00, '淡水小珍珠串链，中间坠一枚Kitty头像金属吊牌，甜美里带一点轻优雅。锁扣采用龙虾扣，佩戴牢固不易掉，通勤约会两相宜，拍照格外上镜。', '2026-11-09 10:59:58');
INSERT INTO `goods` VALUES (15, 'Kitty 猫耳发箍', '🐱', '配饰', 25.00, '毛绒猫耳发箍，耳朵内置软钢丝可自由掰出造型。内圈全包布不硌头，戴一整天也不勒，漫展、生日会、日常卖萌三合一必备单品。', '2026-11-09 10:59:58');
INSERT INTO `goods` VALUES (16, '草莓牛奶瓶耳钉一对', '🥛', '配饰', 19.90, '草莓牛奶瓶造型小耳钉，925银针不过敏，耳垂敏感星人也能放心戴。3D立体小造型，日常佩戴刚刚好，摘戴方便，通勤也不会太夸张。', '2026-11-09 10:59:58');
INSERT INTO `goods` VALUES (17, 'Kitty 造型中性笔三支装', '🖊️', '文具', 15.90, '笔帽是Kitty头的可爱中性笔，0.5mm黑色笔芯书写流畅不断墨，一支能写很久。三支装轮流换着用，放在笔袋里每次拿笔都有好心情。', '2026-11-09 10:59:58');
INSERT INTO `goods` VALUES (18, '草莓便签砖 300张', '📝', '文具', 12.00, '草莓造型的便签砖，一砖300张超耐用，纸张带微黏性可随手贴在电脑边、书页上。记TODO、划重点、给同事留小纸条，办公学习桌面的颜值担当。', '2026-11-09 10:59:58');
INSERT INTO `goods` VALUES (19, '樱花粉荧光笔六色套装', '🖍️', '文具', 22.00, '六色柔和荧光笔，划重点不刺眼、不透纸，双头笔尖粗细两用。马卡龙配色看着就心情好，备考划重点神器，笔记颜值直接拉满。', '2026-11-09 10:59:58');
INSERT INTO `goods` VALUES (20, 'Kitty 咖啡对杯', '☕', '家居', 59.00, '情侣对杯设计，一只Kitty一只蝴蝶结，釉下彩工艺安全无毒可进微波炉。350ml容量刚好一杯拿铁，早上和喜欢的人各端一只，仪式感从早餐开始。', '2026-11-09 10:59:58');
INSERT INTO `goods` VALUES (21, '粉色加绒毛毯 100×150cm', '🛏️', '家居', 79.00, '法兰绒加厚毛毯，100×150cm午睡刚刚好，不掉毛不起静电。办公室午休盖、沙发上追剧盖、车里备一条都可以，可机洗，越洗越软。', '2026-11-09 10:59:58');
INSERT INTO `goods` VALUES (22, 'Kitty 猫爪印马克杯', '🍵', '生活', 35.00, '杯底是粉粉猫爪印的马克杯，350ml容量，倒满热牛奶时爪印会慢慢显现，可爱到犯规。陶瓷材质厚实保温，配下午茶点心，出片率100%。', '2026-11-09 10:59:58');
INSERT INTO `goods` VALUES (23, '草莓香氛护手霜三支装', '🧴', '生活', 39.90, '草莓奶油香氛护手霜三支装，包里、办公桌、床头各放一支随时补涂。质地清爽不粘腻、吸收快，秋冬干燥救星，甜甜的草莓味能留一上午。', '2026-11-09 10:59:58');
INSERT INTO `goods` VALUES (24, 'Kitty 造型草莓大福', '🍡', '美食', 26.00, '手工草莓大福，Q弹雪媚娘外皮包裹整颗新鲜草莓和红豆沙，Kitty小脸用可可粉手绘。冰过之后口感像冰淇淋，一颗一口，甜度刚刚好不齁。', '2026-11-09 10:59:58');
INSERT INTO `goods` VALUES (25, 'Hello Kitty 连帽卫衣 粉', '👕', '服装', 139.00, 'oversize宽松版型连帽卫衣，胸前Kitty头像印花经过水洗工艺不掉色。内里加绒保暖，搭配牛仔裤半身裙都好看，秋季通勤上学必备。', '2026-11-09 10:59:13');
INSERT INTO `goods` VALUES (26, '蝴蝶结针织开衫', '🧶', '服装', 129.00, '马卡龙粉针织开衫，领口手工缝制立体小蝴蝶结，珍珠扣点缀。纱线柔软不扎皮肤，空调房、初秋早晚披上刚刚好，甜美又百搭。', '2026-11-09 10:59:13');
INSERT INTO `goods` VALUES (27, '粉色百褶半身长裙', '👗', '服装', 99.00, '高腰百褶长裙，裙摆随步伐层层散开自带氛围感。内衬不透光，垂感好不易皱，配卫衣、开衫都能穿出温柔学院风，拍照超出片。', '2026-11-09 10:59:13');
INSERT INTO `goods` VALUES (28, '奶油色直筒休闲裤', '👖', '服装', 109.00, '直筒微阔版型显腿直，腰头抽绳松紧腰不勒肚子。垂坠感面料抗皱免烫，通勤上课坐一天也不闷，奶油白四季都能搭。', '2026-11-09 10:59:13');
INSERT INTO `goods` VALUES (29, 'Kitty 刺绣毛呢外套', '🧥', '服装', 259.00, '双面羊毛混纺毛呢外套，版型挺括不塌肩，袖口绣有小Kitty头像。配裙子是优雅淑女，配裤子是利落通勤，一件穿出两种风格。', '2026-11-09 10:59:13');
INSERT INTO `goods` VALUES (30, '加厚连帽毛绒棉袄', '🧣', '服装', 329.00, '冬季加厚棉服，外层防风面料内里摇粒绒，帽檐缀有一对Kitty猫耳。锁温不臃肿，零下出门也不怕，可爱和保暖我全都要。', '2026-11-09 10:59:13');
INSERT INTO `goods` VALUES (31, '蝴蝶结系带帆布鞋', '👟', '鞋子', 89.00, '经典小白鞋底+粉色帆布鞋面，鞋帮两侧蝴蝶结设计甜美加分。橡胶大底防滑耐磨，鞋垫加软踩起来像踩棉花，逛街一天不累脚。', '2026-11-09 10:59:13');
INSERT INTO `goods` VALUES (32, '草莓厚底松糕运动鞋', '🥾', '鞋子', 159.00, '4.5cm厚底增高不累脚，鞋侧草莓刺绣小巧思。网面透气不闷脚，轻量化设计单只不到250g，跑步通勤两相宜。', '2026-11-09 10:59:13');
INSERT INTO `goods` VALUES (33, '毛绒保暖雪地靴', '🧦', '鞋子', 189.00, '加厚羊毛内里雪地靴，鞋口一圈绒毛自带可爱属性。防滑大底踩雪不滑，零下十度出门脚丫也是暖的，冬季衣柜定番单品。', '2026-11-09 10:59:13');
INSERT INTO `goods` VALUES (34, 'Kitty 头小方包单肩包', '👛', '包包', 119.00, '三档可调节肩带，手提单肩斜挎三种背法。Kitty头像立体浮雕包扣，PU皮面防泼水好打理，手机钱包口红统统装得下。', '2026-11-09 10:59:13');
INSERT INTO `goods` VALUES (35, '珍珠链条小圆包', '👝', '包包', 99.00, '云朵粉小圆包，金属链条上串着小珍珠，赴约拍照的点睛单品。磁扣开合单手就能操作，装个手机口红补妆镜刚刚好。', '2026-11-09 10:59:13');
INSERT INTO `goods` VALUES (36, 'Kitty 大容量托特包', '👜', '包包', 149.00, '能装下14寸电脑的大容量托特包，内设分层口袋，水杯、雨伞、iPad各归其位。帆布面料结实耐造，上课通勤旅游一包搞定。', '2026-11-09 10:59:13');
INSERT INTO `goods` VALUES (37, '樱花粉晶锁骨项链', '🌸', '配饰', 79.00, '粉水晶樱花吊坠锁骨链，链身S925银不过敏。光线下一闪一闪的超显肤色，配V领和衬衫都好看，日常通勤也能戴的轻珠宝。', '2026-11-09 10:59:13');
INSERT INTO `goods` VALUES (38, 'Kitty 头珍珠耳钉一对', '💍', '配饰', 49.90, 'Kitty小脸配天然小珍珠的耳钉，925银针敏感耳也能戴。微微垂坠的款式显脸小，约会、上班、拍照随时切换氛围。', '2026-11-09 10:59:13');
INSERT INTO `goods` VALUES (39, '蝴蝶结丝绒choker', '🎀', '配饰', 35.00, '丝绒质地颈链，正中一颗立体小蝴蝶结，后段弹力绳可调节松紧。不勒脖子不起球，搭配裙子瞬间提气，漫展拍照神器。', '2026-11-09 10:59:13');
INSERT INTO `goods` VALUES (40, 'Kitty 吸管水杯 650ml', '🥛', '生活', 39.90, '带吸管的随手杯，PPSU杯身耐摔不怕摔，吸管口有防尘盖。上学、健身、办公室随手拎，喝水量翻倍的秘密武器。', '2026-11-09 10:59:13');
INSERT INTO `goods` VALUES (41, '樱花玻璃茶杯带滤网', '🍵', '生活', 45.00, '高硼硅玻璃杯身配樱花粉滤网，泡茶泡花茶一目了然。把手握感舒适不烫手，下午茶摆在桌上就是一幅画。', '2026-11-09 10:59:13');
INSERT INTO `goods` VALUES (42, 'Kitty 便携运动水壶', '🚰', '生活', 55.00, '一键弹盖运动水壶，单手开合防漏不洒。Tritan材质无异味，700ml大容量带刻度，骑行、跑步、瑜伽后一口冰水超满足。', '2026-11-09 10:59:13');
INSERT INTO `goods` VALUES (43, '粉色气垫按摩梳', '💄', '美妆', 29.90, '气囊梳齿按摩头皮不拉扯打结，梳完头发蓬松又顺滑。手柄圆润握感舒适，包里放一把随时整理刘海，颜值实力双在线。', '2026-11-09 10:59:13');
INSERT INTO `goods` VALUES (44, '草莓润唇膏 3.5g', '🧴', '美妆', 19.90, '草莓味的滋润型润唇膏，睡前厚涂一层当唇膜，早起嘴唇水嫩不起皮。管身小巧随身带，秋冬干燥救星，涂完还有淡淡果香。', '2026-11-09 10:59:13');
INSERT INTO `goods` VALUES (45, '猫爪印花化妆镜', '🪞', '美妆', 49.00, '双面化妆镜一面普通一面放大3倍，镜面带猫爪印花边框。底座稳不晃，放梳妆台每天化妆都是好心情，也是桌面颜值担当。', '2026-11-09 10:59:13');
INSERT INTO `goods` VALUES (46, 'Kitty 无线鼠标 静音', '🖱️', '数码', 69.00, '猫爪造型静音鼠标，点击几乎无声，办公室深夜用也不吵。2.4G即插即用，一节电池用半年，办公桌第一萌物。', '2026-11-09 10:59:13');
INSERT INTO `goods` VALUES (47, 'Hello Kitty 手机壳', '📱', '数码', 35.00, '全包防摔气囊手机壳，内衬绒布不刮机，Kitty印花不掉漆。镜头口加高保护摄像头，可爱和安全一个不落。', '2026-11-09 10:59:13');
INSERT INTO `goods` VALUES (48, '猫耳蓝牙耳机保护套', '🎧', '数码', 25.00, '硅胶猫耳耳机套，自带挂绳防丢。手感软弹防尘防摔，耳机放进包里再也不怕刮花，挂在包上还是个可爱小挂件。', '2026-11-09 10:59:13');

-- ----------------------------
-- Table structure for order_info
-- ----------------------------
DROP TABLE IF EXISTS `order_info`;
CREATE TABLE `order_info`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '订单号',
  `user_id` bigint NOT NULL COMMENT '下单用户ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '下单用户名（冗余，便于后台展示）',
  `receiver` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '收货人',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系电话',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '收货地址快照',
  `total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '订单总金额',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'PAID' COMMENT '状态：PENDING_PAYMENT 待付款 / PAID 待发货 / SHIPPED 已发货 / COMPLETED 已完成 / REFUND_REQUESTED 退款申请中 / REFUNDED 已退款',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '订单备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '下单时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_order_no`(`order_no` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '订单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of order_info
-- ----------------------------
INSERT INTO `order_info` VALUES (1, 'HK202611180001', 1, 'admin', '王小满', '13800138000', '广东省 广州市 天河区 演示路 1 号', 118.90, 'PAID', '请尽快发货', '2026-11-18 09:21:30', '2026-11-18 09:21:30');
INSERT INTO `order_info` VALUES (2, 'HK202611180002', 1, 'admin', '王小满', '13800138000', '广东省 广州市 天河区 演示路 1 号', 59.00, 'SHIPPED', NULL, '2026-11-18 09:21:30', '2026-11-18 09:21:30');
INSERT INTO `order_info` VALUES (3, 'HK202611180003', 1, 'admin', '王小满', '13800138000', '广东省 广州市 天河区 演示路 1 号', 104.90, 'COMPLETED', NULL, '2026-11-18 09:21:30', '2026-11-18 09:21:30');
INSERT INTO `order_info` VALUES (4, 'HK202611180004', 1, 'admin', '王小满', '13800138000', '广东省 广州市 天河区 演示路 1 号', 88.00, 'REFUND_REQUESTED', '蛋糕收到了，融化变形了，申请退款', '2026-11-18 09:21:30', '2026-11-18 09:21:30');
INSERT INTO `order_info` VALUES (5, 'HK202611180005', 1, 'admin', '王小满', '13800138000', '广东省 广州市 天河区 演示路 1 号', 19.90, 'REFUND_REQUESTED', '买错了，申请退款', '2026-11-18 09:21:30', '2026-11-18 09:21:30');
INSERT INTO `order_info` VALUES (6, 'HK202611180006', 1, 'admin', '王小满', '13800138000', '广东省 广州市 天河区 演示路 1 号', 25.00, 'REFUNDED', NULL, '2026-11-18 09:21:30', '2026-11-18 09:21:30');

-- ----------------------------
-- Table structure for order_item
-- ----------------------------
DROP TABLE IF EXISTS `order_item`;
CREATE TABLE `order_item`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `order_id` bigint NOT NULL COMMENT '所属订单ID',
  `goods_id` bigint NULL DEFAULT NULL COMMENT '商品ID',
  `goods_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '商品名称快照',
  `emoji` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '商品图标快照',
  `price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '成交单价',
  `qty` int NOT NULL DEFAULT 1 COMMENT '数量',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_order_id`(`order_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '订单明细表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of order_item
-- ----------------------------
INSERT INTO `order_item` VALUES (1, 1, 1, 'Hello Kitty 公仔', '🧸', 99.00, 1);
INSERT INTO `order_item` VALUES (2, 2, 4, '猫咪抱枕', '🐱', 59.00, 1);
INSERT INTO `order_item` VALUES (3, 3, 2, '草莓发卡', '🎀', 19.90, 1);
INSERT INTO `order_item` VALUES (4, 4, 6, '奶油蛋糕', '🍰', 88.00, 1);
INSERT INTO `order_item` VALUES (5, 5, 2, '草莓发卡', '🎀', 19.90, 1);
INSERT INTO `order_item` VALUES (6, 6, 3, '粉色笔记本', '📒', 25.00, 1);

-- ----------------------------
-- Table structure for review
-- ----------------------------
DROP TABLE IF EXISTS `review`;
CREATE TABLE `review`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '评价用户ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '评价用户名（冗余，便于后台展示）',
  `goods_id` bigint NOT NULL COMMENT '商品ID',
  `rating` tinyint NOT NULL DEFAULT 5 COMMENT '评分 1-5',
  `content` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '评价内容',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'PENDING' COMMENT '审核状态：PENDING 待审核 / APPROVED 已通过 / REJECTED 已驳回',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '评价时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_goods_id`(`goods_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '商品评价表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of review
-- ----------------------------
INSERT INTO `review` VALUES (1, 1, 'admin', 1, 5, '公仔超级软，做工精致， kitty 爱了爱了！', 'PENDING', '2026-11-18 09:21:30', '2026-11-18 09:21:30');
INSERT INTO `review` VALUES (2, 1, 'admin', 2, 4, '发卡很好看，就是夹久了有点松。', 'PENDING', '2026-11-18 09:21:30', '2026-11-18 09:21:30');
INSERT INTO `review` VALUES (3, 1, 'admin', 4, 5, '抱枕抱着睡觉超舒服，回购第二个了～', 'APPROVED', '2026-11-18 09:21:30', '2026-11-18 09:21:30');
INSERT INTO `review` VALUES (4, 1, 'admin', 6, 1, '东西不行，别买（广告内容已删除）', 'PENDING', '2026-11-18 09:21:30', '2026-11-18 09:21:30');
INSERT INTO `review` VALUES (5, 1, 'admin', 7, 3, '拖鞋保暖还行，颜值一般般。', 'APPROVED', '2026-11-18 09:21:30', '2026-11-18 09:21:30');
INSERT INTO `review` VALUES (6, 1, 'admin', 8, 5, '星星发夹太可爱了，闪亮亮！', 'REJECTED', '2026-11-18 09:21:30', '2026-11-18 09:21:30');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名',
  `nickname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '昵称',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '手机号',
  `avatar` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '头像（可存 base64 dataURL 或图片链接）',
  `password` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '密码（MD5加密存储，与 Spring DigestUtils 一致）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_username`(`username` ASC) USING BTREE,
  INDEX `idx_phone`(`phone` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'admin', 'admin', NULL, NULL, 'e10adc3949ba59abbe56e057f20f883e', '2026-10-28 08:57:01', '2026-11-18 09:06:41');
INSERT INTO `user` VALUES (2, '11', '11', NULL, NULL, '9fe98f0a0450d5175bed30a2e76a69f6', '2026-10-28 09:38:27', '2026-10-28 09:38:27');
INSERT INTO `user` VALUES (3, '77', '77', NULL, NULL, '9fe98f0a0450d5175bed30a2e76a69f6', '2026-11-09 10:45:34', '2026-11-09 10:45:34');
INSERT INTO `user` VALUES (4, '999', '999', NULL, 'data:image/jpeg;base64,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', 'e10adc3949ba59abbe56e057f20f883e', '2026-11-18 08:47:53', '2026-11-18 09:07:09');

-- ----------------------------
-- Table structure for user_address
-- ----------------------------
DROP TABLE IF EXISTS `user_address`;
CREATE TABLE `user_address`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '所属用户ID',
  `receiver` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '收货人姓名',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '联系电话',
  `province` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '省',
  `city` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '市',
  `district` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '区/县',
  `detail` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '详细地址（街道门牌）',
  `is_default` tinyint NOT NULL DEFAULT 0 COMMENT '是否默认地址：1 是 0 否',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户收货地址表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user_address
-- ----------------------------
INSERT INTO `user_address` VALUES (3, 4, '江西刘亦菲', '14523698745', '广东省', '广州市', '天河区', '999号', 1, '2026-11-18 09:08:22', '2026-11-18 09:08:22');

SET FOREIGN_KEY_CHECKS = 1;
