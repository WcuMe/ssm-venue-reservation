package com.wenhua.venue.mapper;

import com.wenhua.venue.entity.Category;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface CategoryMapper {
    List<Category> selectAll();

    Category selectById(@Param("id") Long id);

    int insert(Category category);

    int update(Category category);

    int deleteById(@Param("id") Long id);

    /** 该分类下的场地数量（删除前校验用） */
    int countVenues(@Param("categoryId") Long categoryId);
}
