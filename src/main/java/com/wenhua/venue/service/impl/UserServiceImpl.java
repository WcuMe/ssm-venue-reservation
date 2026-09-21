package com.wenhua.venue.service.impl;

import com.wenhua.venue.entity.User;
import com.wenhua.venue.mapper.UserMapper;
import com.wenhua.venue.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Override
    @Transactional(readOnly = true)
    public User login(String username, String password) {
        User user = userMapper.selectByUsername(username);
        if (user == null || !user.getPassword().equals(password)) {
            return null;
        }
        if (user.getStatus() != null && user.getStatus() == 0) {
            return null;
        }
        return user;
    }

    @Override
    public User register(User user) throws Exception {
        if (userMapper.selectByUsername(user.getUsername()) != null) {
            throw new Exception("用户名已存在");
        }
        user.setRole("USER");
        user.setStatus(1);
        userMapper.insert(user);
        return user;
    }

    @Override
    @Transactional(readOnly = true)
    public List<User> listAll() {
        return userMapper.selectAll();
    }

    @Override
    public void updateStatus(Long id, Integer status) {
        userMapper.updateStatus(id, status);
    }

    @Override
    public void delete(Long id) {
        userMapper.deleteById(id);
    }
}
