package com.wenhua.venue.entity;

import lombok.Data;
import java.util.Date;

/**
 * 用户实体
 */
@Data
public class User {
    private Long id;
    private String username;
    private String password;
    private String realName;
    private String phone;
    /** 角色：USER 普通用户 / ADMIN 管理员 */
    private String role;
    /** 状态：1 正常 / 0 禁用 */
    private Integer status;
    private Date createTime;
}
