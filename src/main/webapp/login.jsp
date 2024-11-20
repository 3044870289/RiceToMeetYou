<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
    <title>用户登录</title>
</head>
<body>
    <h1>登录</h1>

    <% 
        // 检查是否有提示信息
        String success = request.getParameter("success");
        String error = request.getParameter("error");
    %>

    <% if (success != null) { %>
        <p style="color: green;">注册成功，请登录。</p>
    <% } %>

    <% if (error != null) { %>
        <p style="color: red;">用户名或密码错误，请重试。</p>
    <% } %>

    <form action="${pageContext.request.contextPath}/LoginServlet" method="post">
        <label for="username">用户名:</label>
        <input type="text" id="username" name="username" required><br><br>

        <label for="password">密码:</label>
        <input type="password" id="password" name="password" required><br><br>

        <button type="submit">登录</button>
    </form>

    <p>还没有账户？<a href="register.jsp">点击注册</a></p>
</body>
</html>
