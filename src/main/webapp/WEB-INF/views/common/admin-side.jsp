<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- 管理后台公共侧边栏：${active} 需在使用前定义（venue/category/user/reservation/review） --%>
<div class="admin-side card">
    <a href="${pageContext.request.contextPath}/admin/venue/list"
       class="${active == 'venue' ? 'active' : ''}">🏟️ 场地管理</a>
    <a href="${pageContext.request.contextPath}/admin/category/list"
       class="${active == 'category' ? 'active' : ''}">📁 分类管理</a>
    <a href="${pageContext.request.contextPath}/admin/reservation/list"
       class="${active == 'reservation' ? 'active' : ''}">📅 预约管理</a>
    <a href="${pageContext.request.contextPath}/admin/review/list"
       class="${active == 'review' ? 'active' : ''}">💬 评价管理</a>
    <a href="${pageContext.request.contextPath}/admin/user/list"
       class="${active == 'user' ? 'active' : ''}">👤 用户管理</a>
</div>
