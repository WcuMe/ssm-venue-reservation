package com.wenhua.venue.mapper;

import com.wenhua.venue.entity.Review;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface ReviewMapper {
    int insert(Review review);

    List<Review> selectByVenueId(@Param("venueId") Long venueId);

    List<Review> selectAll();

    Review selectById(@Param("id") Long id);

    int deleteById(@Param("id") Long id);
}
