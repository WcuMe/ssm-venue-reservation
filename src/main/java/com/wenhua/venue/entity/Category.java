package com.wenhua.venue.entity;

import lombok.Data;
import java.util.Date;

/**
 * 场地分类实体
 */
@Data
public class Category {
    private Long id;
    private String name;
    private String description;
    private Integer sortOrder;
    private Date createTime;
}
