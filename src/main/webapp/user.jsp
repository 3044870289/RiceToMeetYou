<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, dao.DBConnection" %>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>個人情報の編集</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 500px;
            margin: 50px auto;
            background-color: #fff;
            padding: 30px 40px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            border-radius: 8px;
        }
        h1 {
            text-align: center;
            color: #333;
            margin-bottom: 30px;
        }
        label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: bold;
        }
        input[type="password"],
        input[type="email"],
        input[type="text"] {
            width: 100%;
            padding: 10px 15px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 16px;
        }
        button {
            width: 100%;
            padding: 12px;
            background-color: #4CAF50;
            color: #fff;
            font-size: 18px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-top: 10px;
        }
        button:hover {
            background-color: #45a049;
        }
        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #333;
            text-decoration: none;
            font-size: 16px;
        }
        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>個人情報の編集</h1>
        <%
            // 从会话中获取用户名和用户ID
            String username = (String) session.getAttribute("username");
            Integer userID = (Integer) session.getAttribute("userID");
            if (username == null || userID == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            String email = "";
            String address = "";

            // 从数据库获取用户的当前邮箱和地址
            try (Connection conn = DBConnection.getConnection()) {
                String sql = "SELECT Email, Address FROM User WHERE UserID = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setInt(1, userID);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    email = rs.getString("Email");
                    address = rs.getString("Address");
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        %>
        <form action="UpdateUserInfoServlet" method="post">
            <label for="password">変更したいパスワード：</label>
            <input type="password" id="password" name="password" required>
            
            <label for="email">メールアドレス：</label>
            <input type="email" id="email" name="email" value="<%= email %>" required>
    
            <label for="address">住所：</label>
            <input type="text" id="address" name="address" value="<%= address %>" required>
    
            <button type="submit">変更を保存</button>
        </form>
        <a href="index.jsp" class="back-link">ホームページに戻る</a>
    </div>
</body>
</html>
