package com.wenhua.venue.controller;

import com.wenhua.venue.entity.Category;
import com.wenhua.venue.entity.User;
import com.wenhua.venue.entity.Venue;
import com.wenhua.venue.service.CategoryService;
import com.wenhua.venue.service.UserService;
import com.wenhua.venue.service.VenueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * 页面与登录注册控制器
 */
@Controller
public class PageController {

    @Autowired
    private VenueService venueService;

    @Autowired
    private CategoryService categoryService;

    @Autowired
    private UserService userService;

    @Autowired
    private com.wenhua.venue.service.ReviewService reviewService;

    /** 首页：场地列表（支持分类筛选和关键词搜索） */
    @GetMapping({"/", "/index"})
    public String index(@RequestParam(required = false) Long categoryId,
                        @RequestParam(required = false) String keyword,
                        Model model) {
        List<Venue> venues = venueService.listOpen(categoryId, keyword);
        List<Category> categories = categoryService.listAll();
        model.addAttribute("venues", venues);
        model.addAttribute("categories", categories);
        model.addAttribute("currentCategoryId", categoryId);
        model.addAttribute("keyword", keyword);
        return "index";
    }

    /** 登录页 */
    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }

    /** 登录提交 */
    @PostMapping("/login")
    @ResponseBody
    public com.wenhua.venue.utils.Result<String> doLogin(String username, String password,
                                                          HttpSession session) {
        User user = userService.login(username, password);
        if (user == null) {
            return com.wenhua.venue.utils.Result.fail("用户名或密码错误，或账号已被禁用");
        }
        session.setAttribute("loginUser", user);
        return com.wenhua.venue.utils.Result.ok("登录成功");
    }

    /** 注册页 */
    @GetMapping("/register")
    public String registerPage() {
        return "register";
    }

    /** 注册提交 */
    @PostMapping("/register")
    @ResponseBody
    public com.wenhua.venue.utils.Result<String> doRegister(User user) {
        try {
            userService.register(user);
            return com.wenhua.venue.utils.Result.ok("注册成功，请登录");
        } catch (Exception e) {
            return com.wenhua.venue.utils.Result.fail(e.getMessage());
        }
    }

    /** 退出登录 */
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/index";
    }

    /** 场地详情页（含评价列表） */
    @GetMapping("/venue/detail")
    public String venueDetail(@RequestParam Long id, Model model,
                              @ModelAttribute("msg") String msg) {
        Venue venue = venueService.detail(id);
        if (venue == null) {
            return "redirect:/index";
        }
        model.addAttribute("venue", venue);
        model.addAttribute("reviews", reviewService.listByVenue(id));
        return "venue-detail";
    }
}
