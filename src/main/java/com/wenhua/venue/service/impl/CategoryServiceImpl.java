package com.wenhua.venue.service.impl;

import com.wenhua.venue.entity.Category;
import com.wenhua.venue.mapper.CategoryMapper;
import com.wenhua.venue.service.CategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class CategoryServiceImpl implements CategoryService {

    @Autowired
    private CategoryMapper categoryMapper;

    @Override
    @Transactional(readOnly = true)
    public List<Category> listAll() {
        return categoryMapper.selectAll();
    }

    @Override
    public void add(Category category) {
        if (category.getSortOrder() == null) {
            category.setSortOrder(0);
        }
        categoryMapper.insert(category);
    }

    @Override
    public void update(Category category) {
        categoryMapper.update(category);
    }

    @Override
    public void delete(Long id) throws Exception {
        if (categoryMapper.countVenues(id) > 0) {
            throw new Exception("该分类下还有场地，无法删除");
        }
        categoryMapper.deleteById(id);
    }
}
