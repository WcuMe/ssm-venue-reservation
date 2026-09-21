<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>我的预约 - 体育场馆预约系统</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>
<%@ include file="common/header.jsp" %>
<div class="container">
    <div class="card">
        <h2 class="page-title">我的预约</h2>
        <div class="msg" id="msg"></div>
        <table>
            <thead>
            <tr>
                <th>预约单号</th><th>场地</th><th>开始时间</th><th>结束时间</th>
                <th>金额</th><th>状态</th><th>备注</th><th>操作</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${reservations}" var="r">
                <tr>
                    <td>${r.orderNo}</td>
                    <td><a href="${pageContext.request.contextPath}/venue/detail?id=${r.venueId}">${r.venueName}</a></td>
                    <td><fmt:formatDate value="${r.startTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                    <td><fmt:formatDate value="${r.endTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                    <td style="color:#e74c3c;font-weight:bold">¥${r.totalPrice}</td>
                    <td>
                        <c:choose>
                            <c:when test="${r.status == 'PENDING'}"><span class="tag tag-orange">待确认</span></c:when>
                            <c:when test="${r.status == 'CONFIRMED'}"><span class="tag tag-blue">已确认</span></c:when>
                            <c:when test="${r.status == 'CANCELLED'}"><span class="tag tag-gray">已取消</span></c:when>
                            <c:when test="${r.status == 'FINISHED'}"><span class="tag tag-green">已完成</span></c:when>
                        </c:choose>
                    </td>
                    <td>${r.remark}</td>
                    <td>
                        <c:if test="${r.status == 'PENDING' || r.status == 'CONFIRMED'}">
                            <button class="btn btn-sm btn-danger" onclick="cancelReservation(${r.id})">取消预约</button>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty reservations}">
                <tr><td colspan="8" style="color:#999;text-align:center;padding:30px">暂无预约记录</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>
</div>
<script>
    function cancelReservation(id) {
        if (!confirm('确定取消该预约吗？')) return;
        var xhr = new XMLHttpRequest();
        xhr.open('POST', '${pageContext.request.contextPath}/my/reservation/cancel');
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        xhr.onload = function () {
            var r = JSON.parse(xhr.responseText);
            alert(r.message);
            if (r.success) location.reload();
        };
        xhr.send('id=' + id);
    }
</script>
</body>
</html>
