package com.wenhua.venue.service;

import com.wenhua.venue.entity.Venue;
import java.util.List;

public interface VenueService {
    /** 前台：按分类+关键词查询开放中的场地 */
    List<Venue> listOpen(Long categoryId, String keyword);

    Venue detail(Long id);

    /** 管理端：全部场地 */
    List<Venue> listAll();

    void add(Venue venue);

    void update(Venue venue);

    void updateStatus(Long id, Integer status);

    /** 场地下存在有效预约时不允许删除 */
    void delete(Long id) throws Exception;
}
