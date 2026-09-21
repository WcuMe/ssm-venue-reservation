package com.wenhua.venue.service;

import com.wenhua.venue.entity.User;
import java.util.List;

public interface UserService {
    /** 登录校验，成功返回用户对象，失败返回 null */
    User login(String username, String password);

    /** 注册，用户名重复抛出异常 */
    User register(User user) throws Exception;

    List<User> listAll();

    void updateStatus(Long id, Integer status);

    void delete(Long id);
}
