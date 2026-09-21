package com.wenhua.venue.controller;

import com.wenhua.venue.entity.Category;
import com.wenhua.venue.entity.Venue;
import com.wenhua.venue.service.CategoryService;
import com.wenhua.venue.service.VenueService;
import com.wenhua.venue.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 场地管理控制器（管理端）
 */
@Controller
@RequestMapping("/admin/venue")
public class VenueController {

    @Autowired
    private VenueService venueService;

    @Autowired
    private CategoryService categoryService;

    /** 场地列表（含分类下拉数据） */
    @GetMapping("/list")
    public String list(Model model) {
        List<Venue> venues = venueService.listAll();
        List<Category> categories = categoryService.listAll();
        model.addAttribute("venues", venues);
        model.addAttribute("categories", categories);
        return "admin/venues";
    }

    /** 新增场地 */
    @PostMapping("/add")
    @ResponseBody
    public Result<String> add(Venue venue) {
        venueService.add(venue);
        return Result.ok("新增成功");
    }

    /** 修改场地 */
    @PostMapping("/update")
    @ResponseBody
    public Result<String> update(Venue venue) {
        venueService.update(venue);
        return Result.ok("修改成功");
    }

    /** 开放/关闭场地 */
    @PostMapping("/status")
    @ResponseBody
    public Result<String> updateStatus(@RequestParam Long id, @RequestParam Integer status) {
        venueService.updateStatus(id, status);
        return Result.ok(status == 1 ? "已开放" : "已关闭");
    }

    /** 删除场地（有未完成预约则失败） */
    @PostMapping("/delete")
    @ResponseBody
    public Result<String> delete(@RequestParam Long id) {
        try {
            venueService.delete(id);
            return Result.ok("删除成功");
        } catch (Exception e) {
            return Result.fail(e.getMessage());
        }
    }

    /** 跳转编辑页面用的数据（供页面回显） */
    @GetMapping("/edit")
    public String edit(@RequestParam Long id, Model model) {
        Venue venue = venueService.detail(id);
        List<Category> categories = categoryService.listAll();
        model.addAttribute("venue", venue);
        model.addAttribute("categories", categories);
        return "admin/venue-edit";
    }
}
