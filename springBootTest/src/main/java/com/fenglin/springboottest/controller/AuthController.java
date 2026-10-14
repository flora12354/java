package com.fenglin.springboottest.controller;

import com.fenglin.springboottest.common.Result;
import com.fenglin.springboottest.entity.User;
import com.fenglin.springboottest.service.UserService;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

/**
 * 登录 / 注册接口，供 Vue 前端调用
 */
@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final UserService userService;

    public AuthController(UserService userService) {
        this.userService = userService;
    }

    /**
     * 注册：POST /api/auth/register
     * body: {"username": "xxx", "password": "xxx"}
     */
    @PostMapping("/register")
    public Result<User> register(@RequestBody Map<String, String> body) {
        return userService.register(body.get("username"), body.get("password"));
    }

    /**
     * 登录：POST /api/auth/login
     * body: {"username": "xxx", "password": "xxx"}
     */
    @PostMapping("/login")
    public Result<User> login(@RequestBody Map<String, String> body) {
        return userService.login(body.get("username"), body.get("password"));
    }
}
