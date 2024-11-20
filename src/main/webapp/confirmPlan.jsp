<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String plan = request.getParameter("plan");
%>
<html>
<head>
    <title>确认选择</title>
</head>
<body>
    <h1>确认您的选择</h1>
    <p>您选择了方案: <strong><%= plan %></strong></p>
    <button onclick="location.href='choosePlan.jsp'">返回选择页面</button>
    <button onclick="location.href='index.jsp'">返回主页</button>
</body>
</html>
