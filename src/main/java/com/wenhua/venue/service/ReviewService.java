package com.wenhua.venue.service;

import com.wenhua.venue.entity.Review;
import java.util.List;

public interface ReviewService {
    void add(Long userId, Long venueId, Integer rating, String content) throws Exception;

    List<Review> listByVenue(Long venueId);

    List<Review> listAll();

    void delete(Long id);
}
