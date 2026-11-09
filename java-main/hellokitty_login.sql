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

 Date: 09/11/2026 11:06:43
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
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '后台管理员表' ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'admin', 'e10adc3949ba59abbe56e057f20f883e', '2026-10-28 08:57:01', '2026-10-28 08:57:01');
INSERT INTO `user` VALUES (2, '11', '9fe98f0a0450d5175bed30a2e76a69f6', '2026-10-28 09:38:27', '2026-10-28 09:38:27');
INSERT INTO `user` VALUES (3, '77', '9fe98f0a0450d5175bed30a2e76a69f6', '2026-11-09 10:45:34', '2026-11-09 10:45:34');

SET FOREIGN_KEY_CHECKS = 1;
