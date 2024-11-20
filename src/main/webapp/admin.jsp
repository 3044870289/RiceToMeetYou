<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, dao.DBConnection" %>

<%
    String userRole = (String) session.getAttribute("userRole");
    if (!"admin".equals(userRole)) {
        response.sendRedirect("index.jsp");
        return;
    }
%>

<html>
<head>
    <title>用户管理</title>
</head>
<body>
    <h1>用户管理</h1>

    <table border="1">
        <tr>
            <th>用户名</th>
            <th>密码</th>
            <th>邮箱</th>
            <th>地址</th>
            <th>角色</th>
            <th>操作</th>
        </tr>
        <%
            try (Connection conn = DBConnection.getConnection()) {
                String sql = "SELECT UserID, Username, Password, Email, Address, Role FROM User";
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql);

                while (rs.next()) {
                    String userID = rs.getString("UserID");
                    String username = rs.getString("Username");
                    String password = rs.getString("Password");
                    String email = rs.getString("Email");
                    String address = rs.getString("Address");
                    String role = rs.getString("Role");
        %>
                    <tr>
                        <td><%= username %></td>
                        <td><%= password %></td>
                        <td><%= email %></td>
                        <td><%= address %></td>
                        <td><%= role %></td>
                        <td>
                            <form action="adminEditUser.jsp" method="get" style="display:inline;">
                                <input type="hidden" name="userID" value="<%= userID %>">
                                <button type="submit">编辑</button>
                            </form>
                        </td>
                    </tr>
        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        %>
    </table>
</body>
</html>
