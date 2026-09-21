<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>分类管理 - 管理后台</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>
<%@ include file="../common/header.jsp" %>
<c:set var="active" value="category"/>
<div class="container">
    <div class="admin-layout">
        <%@ include file="../common/admin-side.jsp" %>
        <div class="admin-main card">
            <h2 class="page-title">分类管理</h2>
            <details style="margin-bottom:16px">
                <summary style="cursor:pointer;color:#1e6fff;margin-bottom:10px">➕ 新增分类</summary>
                <form id="addForm" style="max-width:500px;padding-top:10px">
                    <div class="form-group"><label>分类名称</label><input id="name" placeholder="例如：乒乓球馆" required></div>
                    <div class="form-group"><label>分类描述</label><input id="description"></div>
                    <div class="form-group"><label>排序号</label><input id="sortOrder" type="number" value="0"></div>
                    <button type="submit" class="btn">保 存</button>
                </form>
            </details>
            <div class="msg" id="msg"></div>
            <table>
                <thead><tr><th>ID</th><th>分类名称</th><th>描述</th><th>排序</th><th>创建时间</th><th>操作</th></tr></thead>
                <tbody>
                <c:forEach items="${categories}" var="c">
                    <tr>
                        <td>${c.id}</td>
                        <td><input id="name-${c.id}" value="${c.name}" style="width:120px;padding:4px 8px"></td>
                        <td><input id="desc-${c.id}" value="${c.description}" style="width:220px;padding:4px 8px"></td>
                        <td><input id="sort-${c.id}" value="${c.sortOrder}" type="number" style="width:70px;padding:4px 8px"></td>
                        <td><fmt:formatDate value="${c.createTime}" pattern="yyyy-MM-dd"/></td>
                        <td>
                            <button class="btn btn-sm" onclick="updateCategory(${c.id})">保存修改</button>
                            <button class="btn btn-sm btn-danger" onclick="del(${c.id}, '${c.name}')">删除</button>
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
        post('/admin/category/add',
            'name=' + encodeURIComponent(document.getElementById('name').value)
            + '&description=' + encodeURIComponent(document.getElementById('description').value)
            + '&sortOrder=' + document.getElementById('sortOrder').value, showMsg);
    };
    function updateCategory(id) {
        post('/admin/category/update',
            'id=' + id
            + '&name=' + encodeURIComponent(document.getElementById('name-' + id).value)
            + '&description=' + encodeURIComponent(document.getElementById('desc-' + id).value)
            + '&sortOrder=' + document.getElementById('sort-' + id).value, showMsg);
    }
    function del(id, name) {
        if (!confirm('确定删除分类「' + name + '」吗？')) return;
        post('/admin/category/delete', 'id=' + id, showMsg);
    }
</script>
</body>
</html>
