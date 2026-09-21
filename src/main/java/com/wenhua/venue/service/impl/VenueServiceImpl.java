package com.wenhua.venue.service.impl;

import com.wenhua.venue.entity.Venue;
import com.wenhua.venue.mapper.VenueMapper;
import com.wenhua.venue.service.VenueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class VenueServiceImpl implements VenueService {

    @Autowired
    private VenueMapper venueMapper;

    @Override
    @Transactional(readOnly = true)
    public List<Venue> listOpen(Long categoryId, String keyword) {
        return venueMapper.selectList(categoryId, keyword);
    }

    @Override
    @Transactional(readOnly = true)
    public Venue detail(Long id) {
        return venueMapper.selectById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Venue> listAll() {
        return venueMapper.selectAll();
    }

    @Override
    public void add(Venue venue) {
        if (venue.getStatus() == null) {
            venue.setStatus(1);
        }
        venueMapper.insert(venue);
    }

    @Override
    public void update(Venue venue) {
        venueMapper.update(venue);
    }

    @Override
    public void updateStatus(Long id, Integer status) {
        venueMapper.updateStatus(id, status);
    }

    @Override
    public void delete(Long id) throws Exception {
        if (venueMapper.countActiveReservations(id) > 0) {
            throw new Exception("该场地还有未完成的预约，无法删除");
        }
        venueMapper.deleteById(id);
    }
}
