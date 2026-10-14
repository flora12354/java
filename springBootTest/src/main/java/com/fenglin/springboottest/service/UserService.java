package com.fenglin.springboottest.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.fenglin.springboottest.common.Result;
import com.fenglin.springboottest.entity.User;

public interface UserService extends IService<User> {

    /**
     * 用户注册
     */
    Result<User> register(String username, String password);

    /**
     * 用户登录
     */
    Result<User> login(String username, String password);
}
