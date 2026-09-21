package com.wenhua.venue.entity;

import lombok.Data;
import java.util.Date;

/**
 * 评价实体
 */
@Data
public class Review {
    private Long id;
    private Long userId;
    private Long venueId;
    private Long reservationId;
    /** 评分 1-5 */
    private Integer rating;
    private String content;
    private Date createTime;

    /** 关联查询字段 */
    private String username;
    private String venueName;
}
