<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
    <title>用户注册</title>
</head>
<body>
    <h1>注册</h1>

    <% if (request.getParameter("error") != null) { %>
        <p style="color: red;">注册失败，请检查输入。</p>
    <% } %>

    <form action="RegisterServlet" method="post">
        <label for="username">用户名:</label>
        <input type="text" id="username" name="username" required><br><br>
        
        <label for="password">密码:</label>
        <input type="password" id="password" name="password" required><br><br>
        
        <label for="email">邮箱:</label>
        <input type="email" id="email" name="email"><br><br>
        
        <label for="address">地址:</label>
        <input type="text" id="address" name="address"><br><br>
        
        <button type="submit">注册</button>
    </form>

    <p>已有账户？<a href="login.jsp">点击登录</a></p>
</body>
</html>
