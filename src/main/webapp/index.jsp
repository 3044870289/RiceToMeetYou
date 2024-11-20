<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String username = (String) session.getAttribute("username");
    String userRole = (String) session.getAttribute("userRole");

    if (username == null || userRole == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<html>
<head>
    <title>主页</title>
</head>
<body>
    <h1>欢迎来到主页</h1>
    <p>您好，<%= username %>！ 您的角色是：<%= userRole %>。</p>

    <% if ("admin".equals(userRole)) { %>
        <button onclick="location.href='admin.jsp'">管理用户</button>
    <% } else if ("user".equals(userRole)) { %>
        <button onclick="location.href='user.jsp'">修改个人信息</button>
    <% } %>

    <button onclick="location.href='logout.jsp'">退出登录</button>
    <button onclick="location.href='choosePlan.jsp'">选择无人机重点方案</button>
</body>
</html>
