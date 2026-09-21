package com.wenhua.venue.controller;

import com.wenhua.venue.entity.Reservation;
import com.wenhua.venue.entity.User;
import com.wenhua.venue.service.ReservationService;
import com.wenhua.venue.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * 预约控制器：用户预约 + 管理端预约管理
 */
@Controller
public class ReservationController {

    @Autowired
    private ReservationService reservationService;

    /** 用户提交预约 */
    @PostMapping("/reservation/create")
    @ResponseBody
    public Result<String> create(@RequestParam Long venueId,
                                 @RequestParam String startTime,
                                 @RequestParam String endTime,
                                 @RequestParam(required = false) String remark,
                                 HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        try {
            Reservation reservation = reservationService.create(
                    loginUser.getId(), venueId, startTime, endTime, remark);
            return Result.ok("预约成功！预约单号：" + reservation.getOrderNo()
                    + "，应付金额 ¥" + reservation.getTotalPrice());
        } catch (Exception e) {
            return Result.fail(e.getMessage());
        }
    }

    /** 我的预约页面 */
    @GetMapping("/my/reservations")
    public String myReservations(HttpSession session, Model model) {
        User loginUser = (User) session.getAttribute("loginUser");
        List<Reservation> reservations = reservationService.myReservations(loginUser.getId());
        model.addAttribute("reservations", reservations);
        return "my-reservations";
    }

    /** 用户取消预约 */
    @PostMapping("/my/reservation/cancel")
    @ResponseBody
    public Result<String> cancel(@RequestParam Long id, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        try {
            reservationService.cancel(id, loginUser.getId());
            return Result.ok("预约已取消");
        } catch (Exception e) {
            return Result.fail(e.getMessage());
        }
    }

    /** 管理端：全部预约 */
    @GetMapping("/admin/reservation/list")
    public String adminList(Model model) {
        List<Reservation> reservations = reservationService.listAll();
        model.addAttribute("reservations", reservations);
        return "admin/reservations";
    }

    /** 管理端：确认预约 */
    @PostMapping("/admin/reservation/confirm")
    @ResponseBody
    public Result<String> confirm(@RequestParam Long id) {
        try {
            reservationService.confirm(id);
            return Result.ok("已确认");
        } catch (Exception e) {
            return Result.fail(e.getMessage());
        }
    }

    /** 管理端：完成预约 */
    @PostMapping("/admin/reservation/finish")
    @ResponseBody
    public Result<String> finish(@RequestParam Long id) {
        try {
            reservationService.finish(id);
            return Result.ok("已完成");
        } catch (Exception e) {
            return Result.fail(e.getMessage());
        }
    }

    /** 管理端：删除预约 */
    @PostMapping("/admin/reservation/delete")
    @ResponseBody
    public Result<String> delete(@RequestParam Long id) {
        try {
            reservationService.delete(id);
            return Result.ok("删除成功");
        } catch (Exception e) {
            return Result.fail(e.getMessage());
        }
    }
}
