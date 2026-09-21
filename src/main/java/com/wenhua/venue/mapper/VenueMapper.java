package com.wenhua.venue.mapper;

import com.wenhua.venue.entity.Venue;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface VenueMapper {
    /** 按分类和关键词查询（均可为空），带平均评分 */
    List<Venue> selectList(@Param("categoryId") Long categoryId,
                           @Param("keyword") String keyword);

    Venue selectById(@Param("id") Long id);

    List<Venue> selectAll();

    int insert(Venue venue);

    int update(Venue venue);

    int updateStatus(@Param("id") Long id, @Param("status") Integer status);

    int deleteById(@Param("id") Long id);

    /** 该场地未取消的预约数量（删除前校验用） */
    int countActiveReservations(@Param("venueId") Long venueId);
}
