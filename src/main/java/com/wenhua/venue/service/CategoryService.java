package com.wenhua.venue.service;

import com.wenhua.venue.entity.Category;
import java.util.List;

public interface CategoryService {
    List<Category> listAll();

    void add(Category category);

    void update(Category category);

    /** 分类下存在场地时不允许删除 */
    void delete(Long id) throws Exception;
}
