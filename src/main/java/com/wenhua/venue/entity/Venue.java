package com.wenhua.venue.entity;

import lombok.Data;
import java.math.BigDecimal;
import java.util.Date;

/**
 * 场地实体
 */
@Data
public class Venue {
    private Long id;
    private String name;
    private Long categoryId;
    private String location;
    private Integer capacity;
    /** 每小时价格（元） */
    private BigDecimal pricePerHour;
    private String description;
    private String imageUrl;
    /** 状态：1 开放 / 0 关闭 */
    private Integer status;
    private Date createTime;

    /** 关联查询字段：分类名称 */
    private String categoryName;
    /** 关联查询字段：平均评分 */
    private Double avgRating;
    /** 关联查询字段：评价数 */
    private Integer reviewCount;
}
