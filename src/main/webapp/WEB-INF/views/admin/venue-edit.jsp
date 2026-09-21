<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>编辑场地 - 管理后台</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>
<%@ include file="../common/header.jsp" %>
<c:set var="active" value="venue"/>
<div class="container">
    <div class="admin-layout">
        <%@ include file="../common/admin-side.jsp" %>
        <div class="admin-main card">
            <h2 class="page-title">编辑场地：${venue.name}</h2>
            <div class="msg" id="msg"></div>
            <form id="editForm" style="max-width:600px">
                <input type="hidden" id="id" value="${venue.id}">
                <div class="form-group"><label>场地名称</label><input id="name" value="${venue.name}" required></div>
                <div class="form-group"><label>所属分类</label>
                    <select id="categoryId">
                        <c:forEach items="${categories}" var="c">
                            <option value="${c.id}" ${c.id == venue.categoryId ? 'selected' : ''}>${c.name}</option>
                        </c:forEach>
                    </select>
                </div>
                <div style="display:flex;gap:12px">
                    <div class="form-group" style="flex:1"><label>位置</label><input id="location" value="${venue.location}"></div>
                    <div class="form-group" style="width:120px"><label>容纳人数</label>
                        <input id="capacity" type="number" value="${venue.capacity}"></div>
                </div>
                <div class="form-group"><label>每小时价格（元）</label>
                    <input id="pricePerHour" type="number" step="0.01" value="${venue.pricePerHour}"></div>
                <div class="form-group"><label>场地描述</label>
                    <textarea id="description" rows="3">${venue.description}</textarea></div>
                <button type="submit" class="btn">保存修改</button>
                <a class="btn btn-outline" href="${pageContext.request.contextPath}/admin/venue/list">返回列表</a>
            </form>
        </div>
    </div>
</div>
<script>
    document.getElementById('editForm').onsubmit = function (e) {
        e.preventDefault();
        var xhr = new XMLHttpRequest();
        xhr.open('POST', '${pageContext.request.contextPath}/admin/venue/update');
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        xhr.onload = function () {
            var r = JSON.parse(xhr.responseText);
            alert(r.message);
            if (r.success) location.href = '${pageContext.request.contextPath}/admin/venue/list';
        };
        xhr.send('id=' + document.getElementById('id').value
            + '&name=' + encodeURIComponent(document.getElementById('name').value)
            + '&categoryId=' + document.getElementById('categoryId').value
            + '&location=' + encodeURIComponent(document.getElementById('location').value)
            + '&capacity=' + document.getElementById('capacity').value
            + '&pricePerHour=' + document.getElementById('pricePerHour').value
            + '&description=' + encodeURIComponent(document.getElementById('description').value));
    };
</script>
</body>
</html>
