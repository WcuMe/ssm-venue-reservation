<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- 公共头部：${pageTitle} 需在使用前定义 --%>
<nav class="navbar">
    <a class="logo" href="${pageContext.request.contextPath}/index">🏟️ 体育场馆预约系统</a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/index">首页</a>
        <c:if test="${not empty sessionScope.loginUser}">
            <a href="${pageContext.request.contextPath}/my/reservations">我的预约</a>
            <c:if test="${sessionScope.loginUser.role == 'ADMIN'}">
                <a href="${pageContext.request.contextPath}/admin/venue/list">管理后台</a>
            </c:if>
        </c:if>
    </div>
    <div class="user-info">
        <c:choose>
            <c:when test="${not empty sessionScope.loginUser}">
                <span>${sessionScope.loginUser.username}（${sessionScope.loginUser.role == 'ADMIN' ? '管理员' : '用户'}）</span>
                <a href="${pageContext.request.contextPath}/logout" style="color:#fff">退出</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/login">登录</a>
                <a href="${pageContext.request.contextPath}/register" style="color:#fff">注册</a>
            </c:otherwise>
        </c:choose>
    </div>
</nav>
