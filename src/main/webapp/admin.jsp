<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, dao.DBConnection" %>

<%
    String userRole = (String) session.getAttribute("userRole");
    if (!"1".equals(userRole)) {
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
        button {
            padding: 10px 15px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        button:hover {
            background-color: #45a049;
        }
        .back-button {
            margin-top: 20px;
            text-align: center;
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
