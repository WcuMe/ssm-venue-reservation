package com.wenhua.venue.service.impl;

import com.wenhua.venue.entity.Review;
import com.wenhua.venue.mapper.ReviewMapper;
import com.wenhua.venue.service.ReviewService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class ReviewServiceImpl implements ReviewService {

    @Autowired
    private ReviewMapper reviewMapper;

    @Override
    public void add(Long userId, Long venueId, Integer rating, String content) throws Exception {
        if (rating == null || rating < 1 || rating > 5) {
            throw new Exception("评分必须为 1-5 分");
        }
        if (content == null || content.trim().isEmpty()) {
            throw new Exception("评价内容不能为空");
        }
        Review review = new Review();
        review.setUserId(userId);
        review.setVenueId(venueId);
        review.setRating(rating);
        review.setContent(content.trim());
        reviewMapper.insert(review);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Review> listByVenue(Long venueId) {
        return reviewMapper.selectByVenueId(venueId);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Review> listAll() {
        return reviewMapper.selectAll();
    }

    @Override
    public void delete(Long id) {
        reviewMapper.deleteById(id);
    }
}
