<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${venue.name} - 体育场馆预约系统</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>
<%@ include file="common/header.jsp" %>
<div class="container">
    <div class="card">
        <div class="detail-info">
            <div class="thumb">${venue.categoryName}</div>
            <div style="flex:1">
                <h2 style="margin-bottom:12px">${venue.name}
                    <span class="tag tag-blue">${venue.categoryName}</span>
                    <span class="tag ${venue.status == 1 ? 'tag-green' : 'tag-gray'}">
                        ${venue.status == 1 ? '开放中' : '已关闭'}
                    </span>
                </h2>
                <div class="info-row"><b>场地位置：</b>${venue.location}</div>
                <div class="info-row"><b>容纳人数：</b>${venue.capacity} 人</div>
                <div class="info-row"><b>收费标准：</b><span class="price" style="color:#e74c3c;font-weight:bold">¥${venue.pricePerHour}/小时</span>（不足半小时按半小时计）</div>
                <div class="info-row"><b>平均评分：</b><span class="stars">★ ${empty venue.avgRating ? '暂无评分' : venue.avgRating}</span>
                    （${venue.reviewCount} 条评价）</div>
                <div class="info-row"><b>场地介绍：</b>${venue.description}</div>
            </div>
        </div>
    </div>

    <div style="display:grid;grid-template-columns:1fr 1fr;gap:16px">
        <div class="card">
            <h3 style="margin-bottom:12px">📅 在线预约</h3>
            <div class="msg" id="msg"></div>
            <c:choose>
                <c:when test="${empty sessionScope.loginUser}">
                    <p style="color:#999"><a href="${pageContext.request.contextPath}/login">登录</a> 后即可预约该场地</p>
                </c:when>
                <c:otherwise>
                    <form id="reserveForm">
                        <input type="hidden" id="venueId" value="${venue.id}">
                        <div class="form-group">
                            <label>开始时间</label>
                            <input type="text" id="startTime" placeholder="格式：2026-09-22 14:00" required>
                        </div>
                        <div class="form-group">
                            <label>结束时间</label>
                            <input type="text" id="endTime" placeholder="格式：2026-09-22 16:00" required>
                        </div>
                        <div class="form-group">
                            <label>备注（选填）</label>
                            <input type="text" id="remark" placeholder="例如：同学聚会打球">
                        </div>
                        <button type="submit" class="btn">提交预约</button>
                    </form>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="card">
            <h3 style="margin-bottom:12px">💬 用户评价</h3>
            <c:if test="${not empty sessionScope.loginUser}">
                <form id="reviewForm" style="margin-bottom:16px">
                    <div class="form-group rating-input" style="display:flex;gap:8px;align-items:center">
                        <label style="margin:0">评分</label>
                        <select id="rating">
                            <option value="5">★★★★★ 5分</option>
                            <option value="4">★★★★ 4分</option>
                            <option value="3">★★★ 3分</option>
                            <option value="2">★★ 2分</option>
                            <option value="1">★ 1分</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <textarea id="content" rows="2" placeholder="写下你对这个场地的评价..." required></textarea>
                    </div>
                    <button type="submit" class="btn btn-sm">提交评价</button>
                </form>
            </c:if>
            <c:forEach items="${reviews}" var="r">
                <div style="border-bottom:1px solid #f0f0f0;padding:10px 0">
                    <b>${r.username}</b> <span class="stars">★${r.rating}</span>
                    <span style="color:#aaa;font-size:12px;float:right">
                        <fmt:formatDate value="${r.createTime}" pattern="yyyy-MM-dd HH:mm"/>
                    </span>
                    <p style="color:#555;margin-top:4px">${r.content}</p>
                </div>
            </c:forEach>
            <c:if test="${empty reviews}">
                <p style="color:#999">暂无评价</p>
            </c:if>
        </div>
    </div>
</div>
<script>
    function post(url, params, done) {
        var xhr = new XMLHttpRequest();
        xhr.open('POST', url);
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        xhr.onload = function () { done(JSON.parse(xhr.responseText)); };
        xhr.send(params);
    }
    function showMsg(r) {
        var msg = document.getElementById('msg');
        msg.className = 'msg ' + (r.success ? 'success' : 'error');
        msg.innerText = r.message;
        if (r.success) setTimeout(function () { location.reload(); }, 1000);
    }
    document.getElementById('reserveForm').onsubmit = function (e) {
        e.preventDefault();
        post('${pageContext.request.contextPath}/reservation/create',
            'venueId=' + document.getElementById('venueId').value
            + '&startTime=' + encodeURIComponent(document.getElementById('startTime').value)
            + '&endTime=' + encodeURIComponent(document.getElementById('endTime').value)
            + '&remark=' + encodeURIComponent(document.getElementById('remark').value), showMsg);
    };
    var reviewForm = document.getElementById('reviewForm');
    if (reviewForm) {
        reviewForm.onsubmit = function (e) {
            e.preventDefault();
            post('${pageContext.request.contextPath}/review/add',
                'venueId=' + document.getElementById('venueId').value
                + '&rating=' + document.getElementById('rating').value
                + '&content=' + encodeURIComponent(document.getElementById('content').value), showMsg);
        };
    }
</script>
</body>
</html>
