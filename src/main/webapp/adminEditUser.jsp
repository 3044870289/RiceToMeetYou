<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, dao.DBConnection" %>

<%
    String userID = request.getParameter("userID");
    String username = "", password = "", email = "", address = "", role = "";

    try (Connection conn = DBConnection.getConnection()) {
        String sql = "SELECT Username, Password, Email, Address, Role FROM User WHERE UserID = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, userID);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            username = rs.getString("Username");
            password = rs.getString("Password");
            email = rs.getString("Email");
            address = rs.getString("Address");
            role = rs.getString("Role");
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<html>
<head>
    <title>编辑用户信息</title>
</head>
<body>
    <h1>编辑用户信息</h1>
    <form action="AdminUpdateUserServlet" method="post">
        <input type="hidden" name="userID" value="<%= userID %>">
        <label for="username">用户名:</label>
        <input type="text" id="username" name="username" value="<%= username %>" required><br><br>
        <label for="password">密码:</label>
        <input type="password" id="password" name="password" value="<%= password %>" required><br><br>
        <label for="email">邮箱:</label>
        <input type="email" id="email" name="email" value="<%= email %>"><br><br>
        <label for="address">地址:</label>
        <input type="text" id="address" name="address" value="<%= address %>"><br><br>
        <label for="role">角色:</label>
        <select id="role" name="role">
            <option value="user" <%= "user".equals(role) ? "selected" : "" %>>普通用户</option>
            <option value="admin" <%= "admin".equals(role) ? "selected" : "" %>>管理员</option>
        </select><br><br>
        <button type="submit">保存修改</button>
    </form>
</body>
</html>
