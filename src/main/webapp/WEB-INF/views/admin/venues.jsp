<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>场地管理 - 管理后台</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>
<%@ include file="../common/header.jsp" %>
<c:set var="active" value="venue"/>
<div class="container">
    <div class="admin-layout">
        <%@ include file="../common/admin-side.jsp" %>
        <div class="admin-main card">
            <h2 class="page-title">场地管理</h2>
            <details style="margin-bottom:16px">
                <summary style="cursor:pointer;color:#1e6fff;margin-bottom:10px">➕ 新增场地</summary>
                <form id="addForm" style="max-width:600px;padding-top:10px">
                    <div class="form-group"><label>场地名称</label><input id="name" required></div>
                    <div class="form-group"><label>所属分类</label>
                        <select id="categoryId">
                            <c:forEach items="${categories}" var="c"><option value="${c.id}">${c.name}</option></c:forEach>
                        </select>
                    </div>
                    <div style="display:flex;gap:12px">
                        <div class="form-group" style="flex:1"><label>位置</label><input id="location"></div>
                        <div class="form-group" style="width:120px"><label>容纳人数</label><input id="capacity" type="number" value="20"></div>
                    </div>
                    <div class="form-group"><label>每小时价格（元）</label><input id="pricePerHour" type="number" step="0.01" value="50"></div>
                    <div class="form-group"><label>场地描述</label><textarea id="description" rows="2"></textarea></div>
                    <button type="submit" class="btn">保 存</button>
                </form>
            </details>
            <div class="msg" id="msg"></div>
            <table>
                <thead>
                <tr><th>ID</th><th>场地名称</th><th>分类</th><th>位置</th><th>容量</th>
                    <th>价格/时</th><th>评分</th><th>状态</th><th>操作</th></tr>
                </thead>
                <tbody>
                <c:forEach items="${venues}" var="v">
                    <tr>
                        <td>${v.id}</td>
                        <td>${v.name}</td>
                        <td><span class="tag tag-blue">${v.categoryName}</span></td>
                        <td>${v.location}</td>
                        <td>${v.capacity}</td>
                        <td>¥${v.pricePerHour}</td>
                        <td class="stars">${empty v.avgRating ? '-' : v.avgRating}</td>
                        <td><span class="tag ${v.status == 1 ? 'tag-green' : 'tag-gray'}">${v.status == 1 ? '开放' : '关闭'}</span></td>
                        <td>
                            <c:choose>
                                <c:when test="${v.status == 1}">
                                    <button class="btn btn-sm btn-warning" onclick="setStatus(${v.id}, 0)">关闭</button>
                                </c:when>
                                <c:otherwise>
                                    <button class="btn btn-sm btn-success" onclick="setStatus(${v.id}, 1)">开放</button>
                                </c:otherwise>
                            </c:choose>
                            <a class="btn btn-sm btn-outline" href="${pageContext.request.contextPath}/admin/venue/edit?id=${v.id}">编辑</a>
                            <button class="btn btn-sm btn-danger" onclick="del(${v.id}, '${v.name}')">删除</button>
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
    document.getElementById('addForm').onsubmit = function (e) {
        e.preventDefault();
        post('/admin/venue/add',
            'name=' + encodeURIComponent(document.getElementById('name').value)
            + '&categoryId=' + document.getElementById('categoryId').value
            + '&location=' + encodeURIComponent(document.getElementById('location').value)
            + '&capacity=' + document.getElementById('capacity').value
            + '&pricePerHour=' + document.getElementById('pricePerHour').value
            + '&description=' + encodeURIComponent(document.getElementById('description').value)
            + '&status=1', showMsg);
    };
    function setStatus(id, status) { post('/admin/venue/status', 'id=' + id + '&status=' + status, showMsg); }
    function del(id, name) {
        if (!confirm('确定删除场地「' + name + '」吗？')) return;
        post('/admin/venue/delete', 'id=' + id, showMsg);
    }
</script>
</body>
</html>
