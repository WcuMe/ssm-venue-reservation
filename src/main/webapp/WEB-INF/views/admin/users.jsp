<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>用户管理 - 管理后台</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>
<%@ include file="../common/header.jsp" %>
<c:set var="active" value="user"/>
<div class="container">
    <div class="admin-layout">
        <%@ include file="../common/admin-side.jsp" %>
        <div class="admin-main card">
            <h2 class="page-title">用户管理</h2>
            <div class="msg" id="msg"></div>
            <table>
                <thead><tr><th>ID</th><th>用户名</th><th>真实姓名</th><th>手机号</th>
                    <th>角色</th><th>状态</th><th>注册时间</th><th>操作</th></tr></thead>
                <tbody>
                <c:forEach items="${users}" var="u">
                    <tr>
                        <td>${u.id}</td>
                        <td>${u.username}</td>
                        <td>${u.realName}</td>
                        <td>${u.phone}</td>
                        <td><span class="tag ${u.role == 'ADMIN' ? 'tag-red' : 'tag-blue'}">
                                ${u.role == 'ADMIN' ? '管理员' : '普通用户'}</span></td>
                        <td><span class="tag ${u.status == 1 ? 'tag-green' : 'tag-gray'}">
                                ${u.status == 1 ? '正常' : '禁用'}</span></td>
                        <td><fmt:formatDate value="${u.createTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${u.status == 1}">
                                    <button class="btn btn-sm btn-warning" onclick="setStatus(${u.id}, 0)">禁用</button>
                                </c:when>
                                <c:otherwise>
                                    <button class="btn btn-sm btn-success" onclick="setStatus(${u.id}, 1)">启用</button>
                                </c:otherwise>
                            </c:choose>
                            <c:if test="${u.username != 'admin'}">
                                <button class="btn btn-sm btn-danger" onclick="del(${u.id}, '${u.username}')">删除</button>
                            </c:if>
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
    function setStatus(id, status) { post('/admin/user/status', 'id=' + id + '&status=' + status, showMsg); }
    function del(id, name) {
        if (!confirm('确定删除用户「' + name + '」吗？')) return;
        post('/admin/user/delete', 'id=' + id, showMsg);
    }
</script>
</body>
</html>
