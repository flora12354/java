package com.fenglin.springboottest.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.fenglin.springboottest.entity.Goods;

import java.util.List;

/**
 * 商品服务接口
 */
public interface GoodsService extends IService<Goods> {

    List<Goods> search(String keyword, String category);
}
