<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>首页 - 体育场馆预约系统</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>
<%@ include file="common/header.jsp" %>
<div class="container">
    <div class="card">
        <div class="filter-bar">
            <form method="get" action="${pageContext.request.contextPath}/index" id="filterForm">
                <select name="categoryId" onchange="document.getElementById('filterForm').submit()">
                    <option value="">全部分类</option>
                    <c:forEach items="${categories}" var="c">
                        <option value="${c.id}" ${c.id == currentCategoryId ? 'selected' : ''}>${c.name}</option>
                    </c:forEach>
                </select>
                <input type="text" name="keyword" value="${keyword}" placeholder="搜索场地名称">
                <button type="submit" class="btn btn-sm">搜索</button>
            </form>
        </div>
        <div class="venue-grid">
            <c:forEach items="${venues}" var="v">
                <div class="venue-card">
                    <div class="thumb">${v.categoryName}</div>
                    <div class="body">
                        <div class="name">${v.name}</div>
                        <div class="meta">📍 ${v.location} ｜ 容纳 ${v.capacity} 人</div>
                        <div class="meta stars">
                                ★ ${empty v.avgRating ? '暂无评分' : v.avgRating}
                            <span style="color:#999">（${v.reviewCount} 条评价）</span>
                        </div>
                        <div style="display:flex;justify-content:space-between;align-items:center;margin-top:8px">
                            <span class="price">¥${v.pricePerHour}/小时</span>
                            <a class="btn btn-sm" href="${pageContext.request.contextPath}/venue/detail?id=${v.id}">查看详情</a>
                        </div>
                    </div>
                </div>
            </c:forEach>
            <c:if test="${empty venues}">
                <p style="color:#999;padding:20px">没有找到符合条件的场地</p>
            </c:if>
        </div>
    </div>
</div>
</body>
</html>
