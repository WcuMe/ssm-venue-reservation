<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>注册 - 体育场馆预约系统</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>
<div class="login-box">
    <div class="card">
        <h2>用户注册</h2>
        <div class="msg" id="msg"></div>
        <form id="registerForm">
            <div class="form-group">
                <label>用户名</label>
                <input type="text" id="username" name="username" placeholder="用户名" required>
            </div>
            <div class="form-group">
                <label>密码</label>
                <input type="password" id="password" name="password" placeholder="密码" required>
            </div>
            <div class="form-group">
                <label>真实姓名</label>
                <input type="text" id="realName" name="realName" placeholder="真实姓名">
            </div>
            <div class="form-group">
                <label>手机号</label>
                <input type="text" id="phone" name="phone" placeholder="手机号">
            </div>
            <button type="submit" class="btn" style="width:100%">注 册</button>
        </form>
        <p class="tip">已有账号？<a href="${pageContext.request.contextPath}/login">去登录</a></p>
    </div>
</div>
<script>
    document.getElementById('registerForm').onsubmit = function (e) {
        e.preventDefault();
        var msg = document.getElementById('msg');
        var xhr = new XMLHttpRequest();
        xhr.open('POST', '${pageContext.request.contextPath}/register');
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        xhr.onload = function () {
            var r = JSON.parse(xhr.responseText);
            if (r.success) {
                msg.className = 'msg success';
                msg.innerText = r.message + '，正在跳转登录页...';
                setTimeout(function () { location.href = '${pageContext.request.contextPath}/login'; }, 800);
            } else {
                msg.className = 'msg error';
                msg.innerText = r.message;
            }
        };
        xhr.send('username=' + encodeURIComponent(document.getElementById('username').value)
            + '&password=' + encodeURIComponent(document.getElementById('password').value)
            + '&realName=' + encodeURIComponent(document.getElementById('realName').value)
            + '&phone=' + encodeURIComponent(document.getElementById('phone').value));
    };
</script>
</body>
</html>
