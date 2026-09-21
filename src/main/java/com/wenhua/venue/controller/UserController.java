package com.wenhua.venue.controller;

import com.wenhua.venue.entity.User;
import com.wenhua.venue.service.UserService;
import com.wenhua.venue.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 用户管理控制器（管理端）
 */
@Controller
@RequestMapping("/admin/user")
public class UserController {

    @Autowired
    private UserService userService;

    /** 用户列表 */
    @GetMapping("/list")
    public String list(Model model) {
        List<User> users = userService.listAll();
        model.addAttribute("users", users);
        return "admin/users";
    }

    /** 启用/禁用用户 */
    @PostMapping("/status")
    @ResponseBody
    public Result<String> updateStatus(@RequestParam Long id, @RequestParam Integer status) {
        userService.updateStatus(id, status);
        return Result.ok(status == 1 ? "已启用" : "已禁用");
    }

    /** 删除用户 */
    @PostMapping("/delete")
    @ResponseBody
    public Result<String> delete(@RequestParam Long id) {
        userService.delete(id);
        return Result.ok("删除成功");
    }
}
