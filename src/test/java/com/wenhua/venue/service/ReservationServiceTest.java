package com.wenhua.venue.service;

import com.wenhua.venue.entity.Reservation;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

import static org.junit.Assert.*;

/**
 * 预约模块单元测试（含核心的时间冲突校验逻辑）
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = "classpath:spring/applicationContext.xml")
@Transactional
public class ReservationServiceTest {

    @Autowired
    private ReservationService reservationService;

    private static final Long USER_ID = 2L;   // zhangsan
    private static final Long VENUE_ID = 2L;  // 文华篮球2号馆 80元/小时

    /** 测试：正常预约成功，单号和总价正确（2小时 × 80元 = 160元） */
    @Test
    public void testCreateReservationSuccess() throws Exception {
        Reservation r = reservationService.create(USER_ID, VENUE_ID,
                "2026-10-01 09:00", "2026-10-01 11:00", "单元测试预约");
        assertNotNull("预约成功后应有自增ID", r.getId());
        assertNotNull("预约单号不应为空", r.getOrderNo());
        assertEquals("待确认状态", Reservation.STATUS_PENDING, r.getStatus());
        assertEquals("2小时×80元=160元", 0, new BigDecimal("160.00").compareTo(r.getTotalPrice()));
    }

    /** 测试：结束时间早于开始时间，预约失败 */
    @Test(expected = Exception.class)
    public void testCreateInvalidTimeRange() throws Exception {
        reservationService.create(USER_ID, VENUE_ID,
                "2026-10-01 11:00", "2026-10-01 09:00", null);
    }

    /** 测试：时间格式错误，预约失败 */
    @Test(expected = Exception.class)
    public void testCreateInvalidTimeFormat() throws Exception {
        reservationService.create(USER_ID, VENUE_ID,
                "2026/10/01 9点", "2026-10-01 11:00", null);
    }

    /** 测试：与已有预约时间段完全重叠，预约失败（冲突校验核心逻辑） */
    @Test(expected = Exception.class)
    public void testCreateTimeConflict() throws Exception {
        // 先预约 10:00-12:00
        reservationService.create(USER_ID, VENUE_ID,
                "2026-10-01 10:00", "2026-10-01 12:00", "第一次预约");
        // 再预约完全重叠时间段，应抛出冲突异常
        reservationService.create(3L, VENUE_ID,
                "2026-10-01 10:00", "2026-10-01 12:00", "冲突预约");
    }

    /** 测试：与已有预约时间段部分重叠（交叉），预约失败 */
    @Test(expected = Exception.class)
    public void testCreatePartialConflict() throws Exception {
        reservationService.create(USER_ID, VENUE_ID,
                "2026-10-01 10:00", "2026-10-01 12:00", null);
        // 11:00-13:00 与 10:00-12:00 交叉
        reservationService.create(3L, VENUE_ID,
                "2026-10-01 11:00", "2026-10-01 13:00", null);
    }

    /** 测试：不同时间段不冲突，预约成功 */
    @Test
    public void testCreateNoConflict() throws Exception {
        reservationService.create(USER_ID, VENUE_ID,
                "2026-10-01 10:00", "2026-10-01 12:00", null);
        // 12:00 之后开始，不算冲突
        Reservation r = reservationService.create(3L, VENUE_ID,
                "2026-10-01 12:00", "2026-10-01 14:00", null);
        assertNotNull(r.getId());
    }

    /** 测试：不足半小时按半小时计价（90分钟 = 1.5小时 × 80 = 120元） */
    @Test
    public void testPriceHalfHourRounding() throws Exception {
        Reservation r = reservationService.create(USER_ID, VENUE_ID,
                "2026-10-01 09:00", "2026-10-01 10:30", null);
        assertEquals("1.5小时×80元=120元", 0, new BigDecimal("120.00").compareTo(r.getTotalPrice()));
    }

    /** 测试：用户取消自己的预约 */
    @Test
    public void testCancelOwnReservation() throws Exception {
        Reservation r = reservationService.create(USER_ID, VENUE_ID,
                "2026-10-02 09:00", "2026-10-02 11:00", null);
        reservationService.cancel(r.getId(), USER_ID);
        List<Reservation> list = reservationService.myReservations(USER_ID);
        for (Reservation item : list) {
            if (item.getId().equals(r.getId())) {
                assertEquals("取消后状态应为 CANCELLED", Reservation.STATUS_CANCELLED, item.getStatus());
            }
        }
    }

    /** 测试：不能取消别人的预约 */
    @Test(expected = Exception.class)
    public void testCancelOthersReservation() throws Exception {
        Reservation r = reservationService.create(USER_ID, VENUE_ID,
                "2026-10-02 09:00", "2026-10-02 11:00", null);
        // 用户3 试图取消用户2 的预约，应抛异常
        reservationService.cancel(r.getId(), 3L);
    }

    /** 测试：管理员确认预约后状态流转 */
    @Test
    public void testConfirmAndFinish() throws Exception {
        Reservation r = reservationService.create(USER_ID, VENUE_ID,
                "2026-10-03 09:00", "2026-10-03 11:00", null);
        reservationService.confirm(r.getId());
        reservationService.finish(r.getId());
        Reservation after = reservationService.myReservations(USER_ID).stream()
                .filter(x -> x.getId().equals(r.getId())).findFirst().orElse(null);
        assertNotNull(after);
        assertEquals("完成后状态应为 FINISHED", Reservation.STATUS_FINISHED, after.getStatus());
    }
}
