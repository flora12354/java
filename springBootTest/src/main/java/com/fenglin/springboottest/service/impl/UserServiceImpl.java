package com.fenglin.springboottest.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.fenglin.springboottest.common.Result;
import com.fenglin.springboottest.entity.User;
import com.fenglin.springboottest.mapper.UserMapper;
import com.fenglin.springboottest.service.UserService;
import org.springframework.stereotype.Service;
import org.springframework.util.DigestUtils;
import org.springframework.util.StringUtils;

import java.nio.charset.StandardCharsets;

@Service
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements UserService {

    @Override
    public Result<User> register(String username, String password) {
        if (!StringUtils.hasText(username)) {
            return Result.fail("用户名不能为空");
        }
        if (password == null || password.length() < 6) {
            return Result.fail("密码至少需要 6 位");
        }
        // 检查用户名是否已存在
        long count = count(new LambdaQueryWrapper<User>().eq(User::getUsername, username));
        if (count > 0) {
            return Result.fail("用户名已被注册");
        }
        User user = new User();
        user.setUsername(username);
        user.setPassword(md5(password));
        save(user);
        return Result.success("注册成功", user);
    }

    @Override
    public Result<User> login(String username, String password) {
        if (!StringUtils.hasText(username) || !StringUtils.hasText(password)) {
            return Result.fail("用户名和密码不能为空");
        }
        User user = getOne(new LambdaQueryWrapper<User>().eq(User::getUsername, username));
        if (user == null) {
            return Result.fail("用户不存在");
        }
        if (!user.getPassword().equals(md5(password))) {
            return Result.fail("密码错误");
        }
        return Result.success("登录成功", user);
    }

    private String md5(String text) {
        return DigestUtils.md5DigestAsHex(text.getBytes(StandardCharsets.UTF_8));
    }
}
