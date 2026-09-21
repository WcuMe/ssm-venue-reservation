package com.wenhua.venue.mapper;

import com.wenhua.venue.entity.User;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface UserMapper {
    User selectByUsername(@Param("username") String username);

    User selectById(@Param("id") Long id);

    List<User> selectAll();

    int insert(User user);

    int update(User user);

    int updateStatus(@Param("id") Long id, @Param("status") Integer status);

    int deleteById(@Param("id") Long id);

    int countAll();
}
