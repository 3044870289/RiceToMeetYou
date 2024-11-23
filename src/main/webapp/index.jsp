<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>

<%
    String username = (String) session.getAttribute("username");
    Integer userRole = (Integer) session.getAttribute("userRole");

    if (username == null || userRole == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 根据用户角色执行相应操作
    if (userRole == 1) {
        // 管理员的操作
    } else if (userRole == 2) {
        // 普通用户的操作
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

<% if (userRole != null && userRole.equals(1)) { %>
    <button onclick="location.href='admin.jsp'">ユーザー管理</button>
<% } else if (userRole.equals(2)) { %>
    <button onclick="location.href='user.jsp'">個人情報編集</button>
<% } %>



    <button onclick="location.href='logout.jsp'">ログアウト</button>
</body>
</html>
