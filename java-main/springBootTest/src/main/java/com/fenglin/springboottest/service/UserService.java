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

    /**
     * 查询个人资料（个人中心）
     */
    Result<User> getProfile(Long userId);

    /**
     * 修改昵称、手机号（个人中心）
     */
    Result<User> updateProfile(Long userId, String nickname, String phone);

    /**
     * 修改头像（个人中心）
     *
     * @param avatar base64 dataURL 或图片链接
     */
    Result<User> updateAvatar(Long userId, String avatar);

    /**
     * 修改密码（个人中心，需校验原密码）
     */
    Result<Void> changePassword(Long userId, String oldPassword, String newPassword);
}
