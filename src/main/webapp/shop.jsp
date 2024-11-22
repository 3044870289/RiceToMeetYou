<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, dao.DBConnection" %>

<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Map<String, Object>> products = new ArrayList<>();
    try (Connection conn = DBConnection.getConnection()) {
        String sql = "SELECT ID, Name, Comment, Price, Stock, Photo FROM Shop";
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(sql);

        while (rs.next()) {
            Map<String, Object> product = new HashMap<>();
            product.put("id", rs.getInt("ID"));
            product.put("name", rs.getString("Name"));
            product.put("comment", rs.getString("Comment"));
            product.put("price", rs.getInt("Price"));
            product.put("stock", rs.getInt("Stock"));
            product.put("photo", rs.getString("Photo"));
            products.add(product);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>ショップ</title>
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
        .product-container {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            justify-content: center;
        }
        .product-card {
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 10px;
            width: 300px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            text-align: center;
            background-color: white;
        }
        .product-card img {
            width: 100%;
            height: auto;
            max-height: 200px;
            object-fit: contain;
        }
        .product-card h2 {
            font-size: 18px;
            color: #333;
        }
        .product-card p {
            font-size: 14px;
            color: #666;
        }
        .product-card button {
            padding: 10px 15px;
            background-color: #4CAF50;
            color: white;
            border: none;
            cursor: pointer;
            border-radius: 5px;
            margin-top: 10px;
        }
        .product-card button:hover {
            background-color: #45a049;
        }
        .actions {
            text-align: center;
            margin-top: 20px;
        }
        .empty-shop {
            text-align: center;
            font-size: 18px;
            color: #888;
            margin-top: 30px;
        }
    </style>
</head>
<body>
<jsp:include page="menu.jsp" />
    <h1>ショップ</h1>

    <% if (products.isEmpty()) { %>
        <p class="empty-shop">現在、ショップに商品はありません。</p>
    <% } else { %>
        <div class="product-container">
            <% for (Map<String, Object> product : products) { %>
                <div class="product-card">
                    <img src="images/<%= product.get("photo") %>" alt="<%= product.get("name") %>">
                    <h2><%= product.get("name") %></h2>
                    <p><%= product.get("comment") %></p>
                    <p>価格: ¥<%= product.get("price") %></p>
                    <p>在庫: <%= product.get("stock") %> 個</p>
                    <form action="AddToCartServlet" method="post">
                        <input type="hidden" name="userID" value="<%= session.getAttribute("userID") %>">
                        <input type="hidden" name="shopID" value="<%= product.get("id") %>">
                        <input type="number" name="quantity" min="1" value="1" required>
                        <button type="submit">カートに追加</button>
                    </form>
                </div>
            <% } %>
        </div>
    <% } %>

    <div class="actions">
        <button onclick="location.href='index.jsp'">ホームに戻る</button>
        <button onclick="location.href='cart.jsp'">カートを見る</button>
    </div>
</body>
</html>
