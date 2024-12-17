<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, dao.DBConnection" %>
<%@ page import="java.text.NumberFormat"%>
<%
    NumberFormat currencyFormat = NumberFormat.getInstance(Locale.JAPAN); // 日本格式
%>
<%
    String username = (String) session.getAttribute("username");
    Integer userRole = (Integer) session.getAttribute("userRole");

    if (username == null || userRole == null) {
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

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>ショップ</title>
    <link rel="stylesheet" href="css/steamstyle.css">
</head>
<body>
    <jsp:include page="menu.jsp" />    
    <div class="container">
      <div class="module">
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
                        <p>価格: ¥<%= currencyFormat.format(product.get("price")) %></p>
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
            <% if (userRole.equals(1)) { %>
                <a href="manageShop.jsp" class="button">商品を管理</a>
            <% } %>
            <button onclick="location.href='cart.jsp'" class="button">カートを見る</button>
        </div>
       </div>
    </div>
</body>
</html>
