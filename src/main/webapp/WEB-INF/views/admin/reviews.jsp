<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>评价管理 - 管理后台</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>
<%@ include file="../common/header.jsp" %>
<c:set var="active" value="review"/>
<div class="container">
    <div class="admin-layout">
        <%@ include file="../common/admin-side.jsp" %>
        <div class="admin-main card">
            <h2 class="page-title">评价管理</h2>
            <div class="msg" id="msg"></div>
            <table>
                <thead><tr><th>ID</th><th>用户</th><th>场地</th><th>评分</th><th>评价内容</th>
                    <th>评价时间</th><th>操作</th></tr></thead>
                <tbody>
                <c:forEach items="${reviews}" var="r">
                    <tr>
                        <td>${r.id}</td>
                        <td>${r.username}</td>
                        <td>${r.venueName}</td>
                        <td class="stars">★${r.rating}</td>
                        <td>${r.content}</td>
                        <td><fmt:formatDate value="${r.createTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                        <td><button class="btn btn-sm btn-danger" onclick="del(${r.id})">删除</button></td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
<script>
    function del(id) {
        if (!confirm('确定删除该评价吗？')) return;
        var xhr = new XMLHttpRequest();
        xhr.open('POST', '${pageContext.request.contextPath}/admin/review/delete');
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
