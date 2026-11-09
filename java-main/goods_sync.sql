-- 同步脚本：将数据库 goods 表中 id 1-10 的商品同步为首页最新数据（来源：前端 goodsData.js mockGoods）
-- id 11-48 已与首页一致，无需改动
USE hellokitty_login;

UPDATE `goods` SET `name`='Hello Kitty 经典公仔 30cm', `emoji`='🧸', `category`='公仔', `price`=89.00, `description`='超柔软的Hello Kitty经典款公仔，30cm高，短绒面料亲肤不起球，内充PP棉回弹饱满不易塌。抱着睡觉刚刚好，也是送闺蜜的生日礼物首选，粉丝必入款～' WHERE `id`=1;

UPDATE `goods` SET `name`='草莓弹簧发卡', `emoji`='🍓', `category`='配饰', `price`=12.50, `description`='粉嫩草莓造型发卡，弹簧夹设计抓力适中不夹头发。树脂材质打磨圆润不刮头皮，日常通勤、约会、拍照都能戴，一夹就能提升整体甜度。' WHERE `id`=2;

UPDATE `goods` SET `name`='粉色磨砂笔记本 A5', `emoji`='📒', `category`='文具', `price`=25.00, `description`='A5横线内页，80g加厚纸张中性笔不洇墨不透页。粉色磨砂封面手感细腻，附赠Hello Kitty贴纸一版可自己DIY封面，上课记笔记、写手账都超有动力。' WHERE `id`=3;

UPDATE `goods` SET `name`='猫咪造型抱枕 45cm', `emoji`='🐱', `category`='家居', `price`=69.00, `description`='45cm大号猫咪抱枕，填充饱满有弹性，靠在沙发上看剧必备。水晶超柔面料摸起来像撸真猫，可拆洗设计方便打理，午睡垫腰一物多用。' WHERE `id`=4;

UPDATE `goods` SET `name`='樱花渐变保温杯 500ml', `emoji`='🥤', `category`='生活', `price`=45.00, `description`='500ml樱花渐变保温杯，316不锈钢内胆，保冷保温12小时。杯盖带提绳方便携带，双重密封圈防漏，丢包里也不怕，冬天喝到一口热水真的会幸福。' WHERE `id`=5;

UPDATE `goods` SET `name`='草莓奶油切块蛋糕', `emoji`='🍰', `category`='美食', `price`=39.90, `description`='草莓奶油切块蛋糕，动物奶油不腻口，蛋糕胚松软带淡淡奶香，夹层是整颗草莓果肉。下午茶配一杯红茶刚刚好，冷藏后口感更佳，当天食用风味最佳。' WHERE `id`=6;

UPDATE `goods` SET `name`='冬季毛绒居家拖鞋', `emoji`='🥿', `category`='家居', `price`=29.00, `description`='冬季加厚毛绒居家拖鞋，防滑软底踩上去像踩在云朵上。内里长绒保暖，包裹感十足，冬天起床第一件事不再是"脚冷警告"，36-40码可选。' WHERE `id`=7;

UPDATE `goods` SET `name`='镀金星星发夹五件套', `emoji`='⭐', `category`='配饰', `price`=9.90, `description`='镀金星星小发夹，一套5只装，大中小三种尺寸随心组合。碎发神器，怎么夹都好看，合金电镀工艺久戴不易褪色，学生党人手一套的性价比之王。' WHERE `id`=8;

UPDATE `goods` SET `name`='云朵造型触控台灯', `emoji`='💡', `category`='家居', `price`=99.00, `description`='云朵造型小夜灯，三档调光（暖光/自然光/柔光），轻触即可开关。内置1800mAh电池满电续航8小时，放床头、书桌都治愈感拉满，也是拍照氛围道具。' WHERE `id`=9;

UPDATE `goods` SET `name`='爱心信封信纸套装', `emoji`='💌', `category`='文具', `price`=6.00, `description`='粉色爱心信封+信纸一套10张，信纸带淡淡樱花暗纹，书写顺滑。写给朋友的一封信，从选纸到落笔都仪式感满满，比微信消息温度高多了。' WHERE `id`=10;
