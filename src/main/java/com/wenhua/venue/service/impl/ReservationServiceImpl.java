package com.wenhua.venue.service.impl;

import com.wenhua.venue.entity.Reservation;
import com.wenhua.venue.entity.Venue;
import com.wenhua.venue.mapper.ReservationMapper;
import com.wenhua.venue.mapper.VenueMapper;
import com.wenhua.venue.service.ReservationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.concurrent.ThreadLocalRandom;

@Service
@Transactional
public class ReservationServiceImpl implements ReservationService {

    private static final SimpleDateFormat SDF = new SimpleDateFormat("yyyy-MM-dd HH:mm");

    @Autowired
    private ReservationMapper reservationMapper;

    @Autowired
    private VenueMapper venueMapper;

    @Override
    public Reservation create(Long userId, Long venueId, String startTimeStr,
                              String endTimeStr, String remark) throws Exception {
        // 1. 时间解析与合法性校验
        Date startTime, endTime;
        try {
            startTime = SDF.parse(startTimeStr);
            endTime = SDF.parse(endTimeStr);
        } catch (ParseException e) {
            throw new Exception("时间格式错误，应为 yyyy-MM-dd HH:mm");
        }
        if (!endTime.after(startTime)) {
            throw new Exception("结束时间必须晚于开始时间");
        }

        // 2. 场地校验
        Venue venue = venueMapper.selectById(venueId);
        if (venue == null) {
            throw new Exception("场地不存在");
        }
        if (venue.getStatus() == null || venue.getStatus() != 1) {
            throw new Exception("该场地当前未开放预约");
        }

        // 3. 时间段冲突校验（与未取消预约比较是否重叠）
        List<Reservation> conflicts = reservationMapper.selectConflicts(venueId, startTime, endTime);
        if (!conflicts.isEmpty()) {
            throw new Exception("预约失败：该时间段已被占用（与预约单 " + conflicts.get(0).getOrderNo() + " 冲突）");
        }

        // 4. 计算总价 = 小时数 × 每小时单价（不足半小时按半小时计）
        long millis = endTime.getTime() - startTime.getTime();
        double hours = millis / (1000.0 * 60 * 60);
        double halfHours = Math.ceil(hours * 2) / 2;
        BigDecimal totalPrice = venue.getPricePerHour()
                .multiply(BigDecimal.valueOf(halfHours))
                .setScale(2, BigDecimal.ROUND_HALF_UP);

        // 5. 生成预约单号并入库
        Reservation reservation = new Reservation();
        reservation.setOrderNo(generateOrderNo());
        reservation.setUserId(userId);
        reservation.setVenueId(venueId);
        reservation.setStartTime(startTime);
        reservation.setEndTime(endTime);
        reservation.setTotalPrice(totalPrice);
        reservation.setStatus(Reservation.STATUS_PENDING);
        reservation.setRemark(remark);
        reservationMapper.insert(reservation);
        return reservation;
    }

    /** 预约单号：R + 日期 + 4位随机数 */
    private String generateOrderNo() {
        String datePart = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
        int random = ThreadLocalRandom.current().nextInt(1000, 9999);
        return "R" + datePart + random;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Reservation> myReservations(Long userId) {
        return reservationMapper.selectByUserId(userId);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Reservation> listAll() {
        return reservationMapper.selectAll();
    }

    @Override
    public void cancel(Long id, Long userId) throws Exception {
        Reservation reservation = getChecked(id);
        if (!reservation.getUserId().equals(userId)) {
            throw new Exception("只能取消自己的预约");
        }
        if (!Reservation.STATUS_PENDING.equals(reservation.getStatus())
                && !Reservation.STATUS_CONFIRMED.equals(reservation.getStatus())) {
            throw new Exception("当前状态不允许取消");
        }
        reservationMapper.updateStatus(id, Reservation.STATUS_CANCELLED);
    }

    @Override
    public void confirm(Long id) throws Exception {
        Reservation reservation = getChecked(id);
        if (!Reservation.STATUS_PENDING.equals(reservation.getStatus())) {
            throw new Exception("只有待确认的预约才能确认");
        }
        reservationMapper.updateStatus(id, Reservation.STATUS_CONFIRMED);
    }

    @Override
    public void finish(Long id) throws Exception {
        Reservation reservation = getChecked(id);
        if (!Reservation.STATUS_CONFIRMED.equals(reservation.getStatus())) {
            throw new Exception("只有已确认的预约才能完成");
        }
        reservationMapper.updateStatus(id, Reservation.STATUS_FINISHED);
    }

    @Override
    public void delete(Long id) throws Exception {
        getChecked(id);
        reservationMapper.deleteById(id);
    }

    private Reservation getChecked(Long id) throws Exception {
        Reservation reservation = reservationMapper.selectById(id);
        if (reservation == null) {
            throw new Exception("预约记录不存在");
        }
        return reservation;
    }
}
