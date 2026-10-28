package com.fenglin.springboottest.controller;

import com.fenglin.springboottest.common.Result;
import com.fenglin.springboottest.entity.Admin;
import com.fenglin.springboottest.service.AdminService;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

/**
 * 后台管理员登录接口
 */
@RestController
@RequestMapping("/api/admin")
public class AdminController {

    private final AdminService adminService;

    public AdminController(AdminService adminService) {
        this.adminService = adminService;
    }

    /**
     * 管理员登录：POST /api/admin/login
     * body: {"username": "xxx", "password": "xxx"}
     */
    @PostMapping("/login")
    public Result<Admin> login(@RequestBody Map<String, String> body) {
        return adminService.login(body.get("username"), body.get("password"));
    }
}
