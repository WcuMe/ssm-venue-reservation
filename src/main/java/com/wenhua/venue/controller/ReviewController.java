package com.wenhua.venue.controller;

import com.wenhua.venue.entity.Review;
import com.wenhua.venue.entity.User;
import com.wenhua.venue.service.ReviewService;
import com.wenhua.venue.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * 评价控制器：用户评价 + 管理端评价管理
 */
@Controller
public class ReviewController {

    @Autowired
    private ReviewService reviewService;

    /** 提交评价 */
    @PostMapping("/review/add")
    @ResponseBody
    public Result<String> add(@RequestParam Long venueId,
                              @RequestParam Integer rating,
                              @RequestParam String content,
                              HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        try {
            reviewService.add(loginUser.getId(), venueId, rating, content);
            return Result.ok("评价成功");
        } catch (Exception e) {
            return Result.fail(e.getMessage());
        }
    }

    /** 场地详情页评价列表（供 venue-detail 使用） */
    @GetMapping("/review/list")
    @ResponseBody
    public Result<List<Review>> listByVenue(@RequestParam Long venueId) {
        return Result.ok("查询成功", reviewService.listByVenue(venueId));
    }

    /** 管理端：全部评价 */
    @GetMapping("/admin/review/list")
    public String adminList(Model model) {
        List<Review> reviews = reviewService.listAll();
        model.addAttribute("reviews", reviews);
        return "admin/reviews";
    }

    /** 管理端：删除评价 */
    @PostMapping("/admin/review/delete")
    @ResponseBody
    public Result<String> delete(@RequestParam Long id) {
        reviewService.delete(id);
        return Result.ok("删除成功");
    }
}
