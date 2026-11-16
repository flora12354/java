package com.fenglin.springboottest.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.fenglin.springboottest.common.Result;
import com.fenglin.springboottest.entity.User;
import com.fenglin.springboottest.mapper.UserMapper;
import com.fenglin.springboottest.service.UserService;
import org.springframework.stereotype.Service;
import org.springframework.util.DigestUtils;
import org.springframework.util.StringUtils;

import java.nio.charset.StandardCharsets;
import java.util.regex.Pattern;

@Service
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements UserService {

    /**
     * 中国大陆手机号：1 开头，第二位 3-9，共 11 位
     */
    private static final Pattern PHONE_PATTERN = Pattern.compile("^1[3-9]\\d{9}$");

    /**
     * 头像最大长度限制（约 2MB 的 base64 文本），避免把超大图片写进数据库
     */
    private static final int MAX_AVATAR_LENGTH = 2 * 1024 * 1024;

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
        // 昵称默认与用户名一致，用户可在个人中心修改
        user.setNickname(username);
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

    @Override
    public Result<User> getProfile(Long userId) {
        User user = getById(userId);
        if (user == null) {
            return Result.fail("用户不存在");
        }
        return Result.success(user);
    }

    @Override
    public Result<User> updateProfile(Long userId, String nickname, String phone) {
        User user = getById(userId);
        if (user == null) {
            return Result.fail("用户不存在");
        }
        if (!StringUtils.hasText(nickname)) {
            return Result.fail("昵称不能为空");
        }
        if (nickname.trim().length() > 20) {
            return Result.fail("昵称最多 20 个字符");
        }
        String trimmedPhone = phone == null ? "" : phone.trim();
        if (StringUtils.hasText(trimmedPhone)) {
            if (!PHONE_PATTERN.matcher(trimmedPhone).matches()) {
                return Result.fail("请输入正确的 11 位手机号");
            }
            // 手机号不允许被其他账号占用
            Long samePhoneCount = baseMapper.selectCount(new LambdaQueryWrapper<User>()
                    .eq(User::getPhone, trimmedPhone)
                    .ne(User::getId, userId));
            if (samePhoneCount != null && samePhoneCount > 0) {
                return Result.fail("该手机号已被其他账号绑定");
            }
        }

        User update = new User();
        update.setId(userId);
        update.setNickname(nickname.trim());
        update.setPhone(StringUtils.hasText(trimmedPhone) ? trimmedPhone : null);
        // 用 set 显式写入，允许把手机号清空（null）
        update(new LambdaUpdateWrapper<User>()
                .eq(User::getId, userId)
                .set(User::getNickname, update.getNickname())
                .set(User::getPhone, update.getPhone()));

        user.setNickname(update.getNickname());
        user.setPhone(update.getPhone());
        return Result.success("资料已保存", user);
    }

    @Override
    public Result<User> updateAvatar(Long userId, String avatar) {
        User user = getById(userId);
        if (user == null) {
            return Result.fail("用户不存在");
        }
        // 传空表示清除头像，恢复默认头像
        if (!StringUtils.hasText(avatar)) {
            update(new LambdaUpdateWrapper<User>()
                    .eq(User::getId, userId)
                    .set(User::getAvatar, null));
            user.setAvatar(null);
            return Result.success("已恢复默认头像", user);
        }
        if (avatar.length() > MAX_AVATAR_LENGTH) {
            return Result.fail("头像图片过大，请选择 2MB 以内的图片");
        }
        if (!avatar.startsWith("data:image/") && !avatar.startsWith("http://") && !avatar.startsWith("https://")) {
            return Result.fail("头像格式不正确");
        }

        update(new LambdaUpdateWrapper<User>()
                .eq(User::getId, userId)
                .set(User::getAvatar, avatar));

        user.setAvatar(avatar);
        return Result.success("头像已更新", user);
    }

    @Override
    public Result<Void> changePassword(Long userId, String oldPassword, String newPassword) {
        User user = getById(userId);
        if (user == null) {
            return Result.fail("用户不存在");
        }
        if (!StringUtils.hasText(oldPassword)) {
            return Result.fail("请输入原密码");
        }
        if (!user.getPassword().equals(md5(oldPassword))) {
            return Result.fail("原密码不正确");
        }
        if (newPassword == null || newPassword.length() < 6) {
            return Result.fail("新密码至少需要 6 位");
        }
        if (newPassword.length() > 20) {
            return Result.fail("新密码最多 20 位");
        }
        if (newPassword.equals(oldPassword)) {
            return Result.fail("新密码不能与原密码相同");
        }

        User update = new User();
        update.setId(userId);
        update.setPassword(md5(newPassword));
        updateById(update);
        return Result.success("密码修改成功", null);
    }

    private String md5(String text) {
        return DigestUtils.md5DigestAsHex(text.getBytes(StandardCharsets.UTF_8));
    }
}
