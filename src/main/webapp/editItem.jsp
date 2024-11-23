<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, dao.DBConnection, java.util.Map, java.util.HashMap" %>

<%
    String idStr = request.getParameter("id");
    if (idStr == null || idStr.isEmpty()) {
        response.sendRedirect("manageShop.jsp?error=missing_id");
        return;
    }

    Map<String, Object> product = null;
    try (Connection conn = DBConnection.getConnection()) {
        String sql = "SELECT ID, Name, Comment, Price, Stock, Photo FROM Shop WHERE ID = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, Integer.parseInt(idStr));
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            product = new HashMap<>();
            product.put("id", rs.getInt("ID"));
            product.put("name", rs.getString("Name"));
            product.put("comment", rs.getString("Comment"));
            product.put("price", rs.getDouble("Price"));
            product.put("stock", rs.getInt("Stock"));
            product.put("photo", rs.getString("Photo"));
        } else {
            response.sendRedirect("manageShop.jsp?error=invalid_id");
            return;
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("manageShop.jsp?error=database_error");
        return;
    }
%>

<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>商品編集</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f9f9f9;
        }
        h1 {
            text-align: center;
            color: #4CAF50;
        }
        .form-container {
            margin: 20px auto;
            padding: 20px;
            border: 1px solid #ddd;
            background-color: #fff;
            border-radius: 5px;
            max-width: 500px;
        }
        .form-container p {
            margin-bottom: 15px;
        }
        .form-container label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        .form-container input, .form-container button {
            width: 100%;
            padding: 8px;
            box-sizing: border-box;
        }
        .form-container button {
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .form-container button:hover {
            background-color: #45a049;
        }
        .image-preview {
            text-align: center;
            margin: 15px 0;
        }
        .image-preview img {
            max-width: 100%;
            height: auto;
            max-height: 200px;
            border: 1px solid #ddd;
            padding: 5px;
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <h1>商品編集</h1>
    <div class="form-container">
        <form action="EditItemServlet" method="post" enctype="multipart/form-data">
            <input type="hidden" name="id" value="<%= product.get("id") %>">

            <p>
                <label for="name">商品名:</label>
                <input type="text" name="name" id="name" value="<%= product.get("name") %>" required>
            </p>
            <p>
                <label for="comment">説明:</label>
                <input type="text" name="comment" id="comment" value="<%= product.get("comment") %>" required>
            </p>
            <p>
                <label for="price">価格:</label>
                <input type="number" name="price" id="price" step="0.01" value="<%= product.get("price") %>" required>
            </p>
            <p>
                <label for="stock">在庫:</label>
                <input type="number" name="stock" id="stock" min="0" value="<%= product.get("stock") %>" required>
            </p>
            <p class="image-preview">
                <label>現在の画像:</label>
                <img src="images/<%= product.get("photo") %>" alt="商品画像">
            </p>
            <p>
                <label for="photo">画像ファイル (変更する場合のみ):</label>
                <input type="file" name="photo" id="photo" accept="image/*">
            </p>
            <button type="submit">保存</button>
        </form>
    </div>
</body>
</html>
