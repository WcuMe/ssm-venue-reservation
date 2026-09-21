package com.wenhua.venue.service;

import com.wenhua.venue.entity.User;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;

import static org.junit.Assert.*;

/**
 * 用户模块单元测试
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = "classpath:spring/applicationContext.xml")
@Transactional
public class UserServiceTest {

    @Autowired
    private UserService userService;

    /** 测试：正确用户名密码登录成功 */
    @Test
    public void testLoginSuccess() {
        User user = userService.login("zhangsan", "123456");
        assertNotNull("正确账号密码应登录成功", user);
        assertEquals("张三", user.getRealName());
        assertEquals("USER", user.getRole());
    }

    /** 测试：错误密码登录失败 */
    @Test
    public void testLoginWrongPassword() {
        User user = userService.login("zhangsan", "wrong");
        assertNull("错误密码应登录失败", user);
    }

    /** 测试：不存在的用户登录失败 */
    @Test
    public void testLoginUserNotExist() {
        User user = userService.login("nobody", "123456");
        assertNull("不存在的用户应登录失败", user);
    }

    /** 测试：注册新用户成功 */
    @Test
    public void testRegisterSuccess() throws Exception {
        User user = new User();
        user.setUsername("newuser_test");
        user.setPassword("123456");
        user.setRealName("测试用户");
        user.setPhone("13900000000");
        userService.register(user);
        assertNotNull("注册后应返回自增ID", user.getId());
        assertEquals("注册后默认角色为 USER", "USER", user.getRole());
        // 注册后能登录
        assertNotNull(userService.login("newuser_test", "123456"));
    }

    /** 测试：重复用户名注册失败 */
    @Test(expected = Exception.class)
    public void testRegisterDuplicateUsername() throws Exception {
        User user = new User();
        user.setUsername("zhangsan");
        user.setPassword("123456");
        userService.register(user); // 应抛出"用户名已存在"
    }
}
