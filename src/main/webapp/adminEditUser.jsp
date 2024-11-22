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
    <title>ユーザー情報の編集</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f9f9f9;
        }
        h1 {
            text-align: center;
            color: #333;
        }
        form {
            max-width: 500px;
            margin: 0 auto;
            background-color: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        input, select {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        button {
            width: 100%;
            padding: 10px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <h1>ユーザー情報の編集</h1>
    <form action="AdminUpdateUserServlet" method="post">
        <input type="hidden" name="userID" value="<%= userID %>">

        <label for="username">ユーザー名:</label>
        <input type="text" id="username" name="username" value="<%= username %>" required>

        <label for="password">パスワード:</label>
        <input type="password" id="password" name="password" value="<%= password %>" required>

        <label for="email">メールアドレス:</label>
        <input type="email" id="email" name="email" value="<%= email %>">

        <label for="address">住所:</label>
        <input type="text" id="address" name="address" value="<%= address %>">

        <label for="role">役割:</label>
        <select id="role" name="role">
            <option value="user" <%= "user".equals(role) ? "selected" : "" %>>一般ユーザー</option>
            <option value="admin" <%= "admin".equals(role) ? "selected" : "" %>>管理者</option>
        </select>

        <button type="submit">変更を保存</button>
    </form>
</body>
</html>
