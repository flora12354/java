package com.fenglin.springboottest.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.fenglin.springboottest.common.Result;
import com.fenglin.springboottest.entity.Admin;

/**
 * 管理员服务接口
 */
public interface AdminService extends IService<Admin> {

    Result<Admin> login(String username, String password);
}
