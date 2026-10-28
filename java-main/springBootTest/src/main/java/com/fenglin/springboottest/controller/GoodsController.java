package com.fenglin.springboottest.controller;

import com.fenglin.springboottest.common.Result;
import com.fenglin.springboottest.entity.Goods;
import com.fenglin.springboottest.service.GoodsService;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 商品管理接口（后台管理系统使用）
 */
@RestController
@RequestMapping("/api/goods")
public class GoodsController {

    private final GoodsService goodsService;

    public GoodsController(GoodsService goodsService) {
        this.goodsService = goodsService;
    }

    /**
     * 商品列表（支持关键字 + 分类筛选）：GET /api/goods?keyword=xxx&category=xxx
     */
    @GetMapping
    public Result<List<Goods>> list(@RequestParam(required = false) String keyword,
                                    @RequestParam(required = false) String category) {
        return Result.success(goodsService.search(keyword, category));
    }

    /**
     * 新增商品：POST /api/goods
     */
    @PostMapping
    public Result<Goods> add(@RequestBody Goods goods) {
        if (goods.getName() == null || goods.getName().isBlank()) {
            return Result.fail("商品名称不能为空");
        }
        if (goods.getCategory() == null || goods.getCategory().isBlank()) {
            return Result.fail("商品分类不能为空");
        }
        if (goods.getPrice() == null) {
            return Result.fail("商品价格不能为空");
        }
        goodsService.save(goods);
        return Result.success("新增成功", goods);
    }

    /**
     * 修改商品：PUT /api/goods
     */
    @PutMapping
    public Result<Goods> update(@RequestBody Goods goods) {
        if (goods.getId() == null) {
            return Result.fail("商品ID不能为空");
        }
        goodsService.updateById(goods);
        return Result.success("修改成功", goods);
    }

    /**
     * 删除商品：DELETE /api/goods/{id}
     */
    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        goodsService.removeById(id);
        return Result.success("删除成功", null);
    }
}
