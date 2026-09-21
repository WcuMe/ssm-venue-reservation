<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>预约管理 - 管理后台</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>
<%@ include file="../common/header.jsp" %>
<c:set var="active" value="reservation"/>
<div class="container">
    <div class="admin-layout">
        <%@ include file="../common/admin-side.jsp" %>
        <div class="admin-main card">
            <h2 class="page-title">预约管理</h2>
            <div class="msg" id="msg"></div>
            <table>
                <thead><tr><th>预约单号</th><th>用户</th><th>场地</th><th>开始时间</th><th>结束时间</th>
                    <th>金额</th><th>状态</th><th>备注</th><th>操作</th></tr></thead>
                <tbody>
                <c:forEach items="${reservations}" var="r">
                    <tr>
                        <td>${r.orderNo}</td>
                        <td>${r.username}</td>
                        <td>${r.venueName}</td>
                        <td><fmt:formatDate value="${r.startTime}" pattern="MM-dd HH:mm"/></td>
                        <td><fmt:formatDate value="${r.endTime}" pattern="MM-dd HH:mm"/></td>
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
                            <c:if test="${r.status == 'PENDING'}">
                                <button class="btn btn-sm btn-success" onclick="confirmRes(${r.id})">确认</button>
                            </c:if>
                            <c:if test="${r.status == 'CONFIRMED'}">
                                <button class="btn btn-sm" onclick="finishRes(${r.id})">完成</button>
                            </c:if>
                            <button class="btn btn-sm btn-danger" onclick="del(${r.id})">删除</button>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
<script>
    function post(url, params, done) {
        var xhr = new XMLHttpRequest();
        xhr.open('POST', '${pageContext.request.contextPath}' + url);
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        xhr.onload = function () { done(JSON.parse(xhr.responseText)); };
        xhr.send(params);
    }
    function showMsg(r) {
        var msg = document.getElementById('msg');
        msg.className = 'msg ' + (r.success ? 'success' : 'error');
        msg.innerText = r.message;
        if (r.success) setTimeout(function () { location.reload(); }, 800);
    }
    function confirmRes(id) { post('/admin/reservation/confirm', 'id=' + id, showMsg); }
    function finishRes(id) { post('/admin/reservation/finish', 'id=' + id, showMsg); }
    function del(id) {
        if (!confirm('确定删除该预约记录吗？')) return;
        post('/admin/reservation/delete', 'id=' + id, showMsg);
    }
</script>
</body>
</html>
