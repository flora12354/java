package com.fenglin.springboottest.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.fenglin.springboottest.common.Result;
import com.fenglin.springboottest.entity.Admin;
import com.fenglin.springboottest.mapper.AdminMapper;
import com.fenglin.springboottest.service.AdminService;
import org.springframework.stereotype.Service;
import org.springframework.util.DigestUtils;
import org.springframework.util.StringUtils;

import java.nio.charset.StandardCharsets;

@Service
public class AdminServiceImpl extends ServiceImpl<AdminMapper, Admin> implements AdminService {

    @Override
    public Result<Admin> login(String username, String password) {
        if (!StringUtils.hasText(username) || !StringUtils.hasText(password)) {
            return Result.fail("用户名和密码不能为空");
        }
        Admin admin = getOne(new LambdaQueryWrapper<Admin>().eq(Admin::getUsername, username));
        if (admin == null) {
            return Result.fail("管理员不存在");
        }
        if (!admin.getPassword().equals(md5(password))) {
            return Result.fail("密码错误");
        }
        return Result.success("登录成功", admin);
    }

    private String md5(String text) {
        return DigestUtils.md5DigestAsHex(text.getBytes(StandardCharsets.UTF_8));
    }
}
