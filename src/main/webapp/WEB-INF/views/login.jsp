<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>登录 - 体育场馆预约系统</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>
<div class="login-box">
    <div class="card">
        <h2>用户登录</h2>
        <div class="msg" id="msg"></div>
        <form id="loginForm">
            <div class="form-group">
                <label>用户名</label>
                <input type="text" id="username" name="username" placeholder="用户名" required>
            </div>
            <div class="form-group">
                <label>密码</label>
                <input type="password" id="password" name="password" placeholder="密码" required>
            </div>
            <button type="submit" class="btn" style="width:100%">登 录</button>
        </form>
        <p class="tip">还没有账号？<a href="${pageContext.request.contextPath}/register">立即注册</a></p>
        <p class="tip">测试账号：admin / 123456（管理员），zhangsan / 123456（用户）</p>
    </div>
</div>
<script>
    document.getElementById('loginForm').onsubmit = function (e) {
        e.preventDefault();
        var msg = document.getElementById('msg');
        var xhr = new XMLHttpRequest();
        xhr.open('POST', '${pageContext.request.contextPath}/login');
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        xhr.onload = function () {
            var r = JSON.parse(xhr.responseText);
            if (r.success) {
                msg.className = 'msg success';
                msg.innerText = r.message + '，正在跳转...';
                setTimeout(function () { location.href = '${pageContext.request.contextPath}/index'; }, 600);
            } else {
                msg.className = 'msg error';
                msg.innerText = r.message;
            }
        };
        xhr.send('username=' + encodeURIComponent(document.getElementById('username').value)
            + '&password=' + encodeURIComponent(document.getElementById('password').value));
    };
</script>
</body>
</html>
