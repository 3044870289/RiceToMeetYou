<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, dao.DBConnection" %>

<%
    Integer userRole = (Integer) session.getAttribute("userRole");
    if (userRole == null || userRole != 1) {
        response.sendRedirect("index.jsp");
        return;
    }
%>

<html>
<head>
    <title>ユーザー管理</title>
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
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
            background-color: #fff;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
            color: #333;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        button {
            padding: 8px 12px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 3px;
            cursor: pointer;
        }
        button:hover {
            background-color: #45a049;
        }
        .back-button {
            margin-top: 20px;
            text-align: center;
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
    <h1>ユーザー管理</h1>

    <table>
        <tr>
            <th>ユーザー名</th>
            <th>パスワード</th>
            <th>メールアドレス</th>
            <th>住所</th>
            <th>役割</th>
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
                    int role = rs.getInt("Role");

                    // 将角色整数值转换为字符串表示
                    String roleDisplay = "";
                    if (role == 1) {
                        roleDisplay = "admin";
                    } else if (role == 2) {
                        roleDisplay = "user";
                    } else {
                        roleDisplay = "unknown";
                    }
        %>
                    <tr>
                        <td><%= username %></td>
                        <td><%= password %></td>
                        <td><%= email %></td>
                        <td><%= address %></td>
                        <td><%= roleDisplay %></td>
                        <td>
                            <form action="adminEditUser.jsp" method="get" style="display:inline;">
                                <input type="hidden" name="userID" value="<%= userID %>">
                                <button type="submit">編集</button>
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

    <!-- メインページへ戻るボタン -->
    <div class="back-button">
        <button onclick="location.href='index.jsp'">メインページへ戻る</button>
    </div>
</body>
</html>
