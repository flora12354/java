package com.fenglin.springboottest.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.fenglin.springboottest.entity.Goods;
import com.fenglin.springboottest.mapper.GoodsMapper;
import com.fenglin.springboottest.service.GoodsService;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List;

@Service
public class GoodsServiceImpl extends ServiceImpl<GoodsMapper, Goods> implements GoodsService {

    @Override
    public List<Goods> search(String keyword, String category) {
        LambdaQueryWrapper<Goods> wrapper = new LambdaQueryWrapper<>();
        if (StringUtils.hasText(category) && !"全部".equals(category)) {
            wrapper.eq(Goods::getCategory, category);
        }
        if (StringUtils.hasText(keyword)) {
            wrapper.and(w -> w.like(Goods::getName, keyword)
                    .or().like(Goods::getCategory, keyword)
                    .or().like(Goods::getDescription, keyword));
        }
        wrapper.orderByAsc(Goods::getId);
        return list(wrapper);
    }
}
