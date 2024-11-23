<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, dao.DBConnection" %>

<%
    // 获取用户ID
    String userIDStr = request.getParameter("userID");
    if (userIDStr == null) {
        response.sendRedirect("admin.jsp?error=missingUserID");
        return;
    }

    int userID = Integer.parseInt(userIDStr);

    // 初始化变量
    String username = "";
    String password = "";
    String email = "";
    String address = "";
    int role = 0;

    // 从数据库获取用户信息
    try (Connection conn = DBConnection.getConnection()) {
        String sql = "SELECT Username, Password, Email, Address, Role FROM User WHERE UserID = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, userID);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            username = rs.getString("Username");
            password = rs.getString("Password");
            email = rs.getString("Email");
            address = rs.getString("Address");
            role = rs.getInt("Role");
        } else {
            response.sendRedirect("admin.jsp?error=userNotFound");
            return;
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("admin.jsp?error=dbError");
        return;
    }
%>

<html>
<head>
    <title>ユーザー編集</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f9f9f9;
        }
        h1 {
            text-align: center;
            color: #333;
        }
        .form-container {
            max-width: 500px;
            margin: 0 auto;
            background-color: #fff;
            padding: 25px;
            border-radius: 5px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: bold;
        }
        input, select {
            width: 100%;
            padding: 10px;
            margin-bottom: 18px;
            border: 1px solid #ddd;
            border-radius: 3px;
            font-size: 14px;
        }
        button {
            width: 100%;
            padding: 10px 15px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            font-size: 16px;
        }
        button:hover {
            background-color: #45a049;
        }
        .back-button {
            text-align: center;
            margin-top: 20px;
        }
        .back-button button {
            background-color: #008CBA;
        }
        .back-button button:hover {
            background-color: #007bb5;
        }
    </style>
</head>
<body>
    <h1>ユーザー編集</h1>
    <div class="form-container">
        <form action="AdminUpdateUserServlet" method="post">
            <input type="hidden" name="userID" value="<%= userID %>">

            <label for="username">ユーザー名:</label>
            <input type="text" id="username" name="username" value="<%= username %>" readonly>

            <label for="password">パスワード:</label>
            <input type="password" id="password" name="password" value="<%= password %>" required>

            <label for="email">メールアドレス:</label>
            <input type="email" id="email" name="email" value="<%= email %>">

            <label for="address">住所:</label>
            <input type="text" id="address" name="address" value="<%= address %>">

            <label for="role">役割:</label>
            <select name="newRole" id="role">
                <option value="1" <%= (role == 1) ? "selected" : "" %>>管理者</option>
                <option value="2" <%= (role == 2) ? "selected" : "" %>>ユーザー</option>
            </select>

            <button type="submit">保存</button>
        </form>
    </div>

    <div class="back-button">
        <button onclick="location.href='admin.jsp'">ユーザー管理に戻る</button>
    </div>
</body>
</html>
