package com.wenhua.venue.controller;

import com.wenhua.venue.entity.Category;
import com.wenhua.venue.service.CategoryService;
import com.wenhua.venue.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 场地分类管理控制器（管理端）
 */
@Controller
@RequestMapping("/admin/category")
public class CategoryController {

    @Autowired
    private CategoryService categoryService;

    /** 分类列表 */
    @GetMapping("/list")
    public String list(Model model) {
        List<Category> categories = categoryService.listAll();
        model.addAttribute("categories", categories);
        return "admin/categories";
    }

    /** 新增分类 */
    @PostMapping("/add")
    @ResponseBody
    public Result<String> add(Category category) {
        categoryService.add(category);
        return Result.ok("新增成功");
    }

    /** 修改分类 */
    @PostMapping("/update")
    @ResponseBody
    public Result<String> update(Category category) {
        categoryService.update(category);
        return Result.ok("修改成功");
    }

    /** 删除分类（分类下有场地则失败） */
    @PostMapping("/delete")
    @ResponseBody
    public Result<String> delete(@RequestParam Long id) {
        try {
            categoryService.delete(id);
            return Result.ok("删除成功");
        } catch (Exception e) {
            return Result.fail(e.getMessage());
        }
    }
}
