package com.wenhua.venue.entity;

import lombok.Data;
import java.math.BigDecimal;
import java.util.Date;

/**
 * 预约实体
 */
@Data
public class Reservation {
    private Long id;
    private String orderNo;
    private Long userId;
    private Long venueId;
    private Date startTime;
    private Date endTime;
    private BigDecimal totalPrice;
    /** 状态：PENDING 待确认 / CONFIRMED 已确认 / CANCELLED 已取消 / FINISHED 已完成 */
    private String status;
    private String remark;
    private Date createTime;

    /** 关联查询字段 */
    private String username;
    private String venueName;

    /** 待确认 */
    public static final String STATUS_PENDING = "PENDING";
    /** 已确认 */
    public static final String STATUS_CONFIRMED = "CONFIRMED";
    /** 已取消 */
    public static final String STATUS_CANCELLED = "CANCELLED";
    /** 已完成 */
    public static final String STATUS_FINISHED = "FINISHED";
}
