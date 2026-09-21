package com.wenhua.venue.service;

import com.wenhua.venue.entity.Category;
import com.wenhua.venue.entity.Venue;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

import static org.junit.Assert.*;

/**
 * 分类、场地、评价模块单元测试
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = "classpath:spring/applicationContext.xml")
@Transactional
public class VenueModuleTest {

    @Autowired
    private CategoryService categoryService;

    @Autowired
    private VenueService venueService;

    @Autowired
    private ReviewService reviewService;

    /** 测试：分类列表查询 */
    @Test
    public void testCategoryList() {
        List<Category> categories = categoryService.listAll();
        assertTrue("初始化后应有 5 个分类", categories.size() >= 5);
    }

    /** 测试：新增分类并查询 */
    @Test
    public void testCategoryAdd() {
        Category category = new Category();
        category.setName("乒乓球馆");
        category.setDescription("单元测试新增分类");
        categoryService.add(category);
        assertNotNull(category.getId());
        assertTrue(categoryService.listAll().stream()
                .anyMatch(c -> "乒乓球馆".equals(c.getName())));
    }

    /** 测试：分类下有场地时删除失败 */
    @Test(expected = Exception.class)
    public void testCategoryDeleteWithVenues() throws Exception {
        // 分类1（篮球馆）下有场地，删除应抛异常
        categoryService.delete(1L);
    }

    /** 测试：分类下无场地时删除成功 */
    @Test
    public void testCategoryDeleteSuccess() throws Exception {
        Category category = new Category();
        category.setName("空分类");
        categoryService.add(category);
        categoryService.delete(category.getId());
        assertFalse(categoryService.listAll().stream()
                .anyMatch(c -> category.getId().equals(c.getId())));
    }

    /** 测试：按分类筛选场地 */
    @Test
    public void testVenueFilterByCategory() {
        List<Venue> venues = venueService.listOpen(1L, null); // 篮球馆
        assertTrue("篮球馆分类下应有场地", venues.size() >= 2);
        venues.forEach(v -> assertEquals(Long.valueOf(1L), v.getCategoryId()));
    }

    /** 测试：按关键词搜索场地 */
    @Test
    public void testVenueSearchByKeyword() {
        List<Venue> venues = venueService.listOpen(null, "游泳");
        assertEquals("搜索'游泳'应只返回恒温游泳馆", 1, venues.size());
        assertEquals("恒温游泳馆", venues.get(0).getName());
    }

    /** 测试：场地详情带平均评分 */
    @Test
    public void testVenueDetailWithRating() {
        Venue venue = venueService.detail(4L); // 羽毛球B馆有一条5星评价
        assertNotNull(venue);
        assertNotNull("场地应带平均评分", venue.getAvgRating());
        assertEquals(5.0, venue.getAvgRating(), 0.01);
    }

    /** 测试：新增场地后可查询到 */
    @Test
    public void testVenueAdd() {
        Venue venue = new Venue();
        venue.setName("单元测试场地");
        venue.setCategoryId(1L);
        venue.setLocation("测试位置");
        venue.setCapacity(10);
        venue.setPricePerHour(new java.math.BigDecimal("30.00"));
        venueService.add(venue);
        Venue found = venueService.detail(venue.getId());
        assertEquals("单元测试场地", found.getName());
    }

    /** 测试：有未完成预约的场地删除失败 */
    @Test(expected = Exception.class)
    public void testVenueDeleteWithActiveReservation() throws Exception {
        // 场地5有一条 PENDING 状态预约（R20260919001），删除应抛异常
        venueService.delete(5L);
    }

    /** 测试：提交评价并影响场地平均分 */
    @Test
    public void testReviewAdd() throws Exception {
        // 场地1当前有一条4星评价，再提交一条5星 → 平均4.5
        reviewService.add(2L, 1L, 5, "单元测试好评");
        Venue venue = venueService.detail(1L);
        assertEquals(4.5, venue.getAvgRating(), 0.01);
        assertEquals(Integer.valueOf(2), venue.getReviewCount());
    }

    /** 测试：评分超出范围提交失败 */
    @Test(expected = Exception.class)
    public void testReviewInvalidRating() throws Exception {
        reviewService.add(2L, 1L, 6, "无效评分");
    }

    /** 测试：空内容评价提交失败 */
    @Test(expected = Exception.class)
    public void testReviewEmptyContent() throws Exception {
        reviewService.add(2L, 1L, 4, "  ");
    }
}
