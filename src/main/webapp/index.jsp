<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>

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
    <title>ホーム</title>
</head>
<body>
    <jsp:include page="menu.jsp" />
    <h1>ホームへようこそ</h1>
    <p><%= username %> 様、ようこそ！</p>

    <% if ("1".equals(userRole)) { %>
        <button onclick="location.href='admin.jsp'">ユーザー管理</button>
    <% } else if ("2".equals(userRole)) { %>
        <button onclick="location.href='user.jsp'">個人情報編集</button>
    <% } %>

    <button onclick="location.href='logout.jsp'">ログアウト</button>
</body>
</html>
