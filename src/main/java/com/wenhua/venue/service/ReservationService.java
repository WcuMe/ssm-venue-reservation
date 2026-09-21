package com.wenhua.venue.service;

import com.wenhua.venue.entity.Reservation;
import java.text.ParseException;
import java.util.List;

public interface ReservationService {
    /**
     * 创建预约：校验时间合法性与场地冲突，计算总价，生成预约单号
     * @return 创建成功的预约对象
     */
    Reservation create(Long userId, Long venueId, String startTimeStr,
                       String endTimeStr, String remark) throws Exception;

    List<Reservation> myReservations(Long userId);

    List<Reservation> listAll();

    /** 用户取消自己的预约（待确认/已确认状态可取消） */
    void cancel(Long id, Long userId) throws Exception;

    /** 管理员确认预约 */
    void confirm(Long id) throws Exception;

    /** 管理员完成预约 */
    void finish(Long id) throws Exception;

    void delete(Long id) throws Exception;
}
