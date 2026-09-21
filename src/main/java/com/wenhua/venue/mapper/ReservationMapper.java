package com.wenhua.venue.mapper;

import com.wenhua.venue.entity.Reservation;
import org.apache.ibatis.annotations.Param;
import java.util.Date;
import java.util.List;

public interface ReservationMapper {
    int insert(Reservation reservation);

    Reservation selectById(@Param("id") Long id);

    /** 我的预约列表 */
    List<Reservation> selectByUserId(@Param("userId") Long userId);

    /** 全部预约列表（管理端） */
    List<Reservation> selectAll();

    /** 与某场地时间段冲突的有效预约（非取消状态） */
    List<Reservation> selectConflicts(@Param("venueId") Long venueId,
                                      @Param("startTime") Date startTime,
                                      @Param("endTime") Date endTime);

    int updateStatus(@Param("id") Long id, @Param("status") String status);

    int deleteById(@Param("id") Long id);

    int countAll();
}
