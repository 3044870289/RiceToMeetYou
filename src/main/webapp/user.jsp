<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
    <title>修改个人信息</title>
</head>
<body>
    <h1>修改个人信息</h1>

    <form action="UpdateUserInfoServlet" method="post">
        <label for="password">密码:</label>
        <input type="password" id="password" name="password"><br><br>
        
        <label for="email">邮箱:</label>
        <input type="email" id="email" name="email"><br><br>

        <label for="address">地址:</label>
        <input type="text" id="address" name="address"><br><br>

        <button type="submit">保存修改</button>
    </form>
</body>
</html>
