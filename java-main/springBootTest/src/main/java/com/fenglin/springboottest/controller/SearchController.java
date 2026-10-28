package com.fenglin.springboottest.controller;

import com.fenglin.springboottest.common.Result;
import com.fenglin.springboottest.entity.Goods;
import com.fenglin.springboottest.service.GoodsService;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

/**
 * 首页搜索接口
 */
@RestController
@RequestMapping("/api")
public class SearchController {

    private final GoodsService goodsService;

    public SearchController(GoodsService goodsService) {
        this.goodsService = goodsService;
    }

    /**
     * 搜索：POST /api/search
     * body: { "keyword": "xxx" }
     */
    @PostMapping("/search")
    public Result<List<Goods>> search(@RequestBody Map<String, String> body) {
        return Result.success(goodsService.search(body.get("keyword"), "全部"));
    }
}
