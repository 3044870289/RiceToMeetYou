<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, dao.DBConnection" %>

<%
    Integer userID = (Integer) session.getAttribute("userID");
    Integer userRole = (Integer) session.getAttribute("userRole");
    String username = (String) session.getAttribute("username");

    if (userID == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>ショッピングカート</title>
    <link rel="stylesheet" href="css/steamstyle.css">
</head>
<body>
    <jsp:include page="menu.jsp" />
    <div class="container">
        <div class="module">
            <h1>ショッピングカート</h1>
            <%
                int totalPrice = 0;
                boolean hasItems = false;
            %>
            <table>
                <tr>
                    <th>商品名</th>
                    <th>単価</th>
                    <th>数量</th>
                    <th>合計金額</th>
                    <th>操作</th>
                </tr>
                <%
                    try (Connection conn = DBConnection.getConnection()) {
                        String sql = "SELECT Shop.Name, Shop.Price, cart.Quantity, Shop.Price * cart.Quantity AS TotalPrice, cart.CartID " +
                                     "FROM cart JOIN Shop ON cart.ShopID = Shop.ID WHERE cart.UserID = ?";
                        PreparedStatement stmt = conn.prepareStatement(sql);
                        stmt.setInt(1, userID);
                        ResultSet rs = stmt.executeQuery();

                        while (rs.next()) {
                            hasItems = true;
                            int totalPriceForItem = rs.getInt("TotalPrice");
                            totalPrice += totalPriceForItem;
                %>
                            <tr>
                                <td><%= rs.getString("Name") %></td>
                                <td>¥<%= rs.getInt("Price") %></td>
                                <td><%= rs.getInt("Quantity") %></td>
                                <td>¥<%= totalPriceForItem %></td>
                                <td>
                                    <form action="RemoveFromCartServlet" method="post">
                                        <input type="hidden" name="cartID" value="<%= rs.getInt("CartID") %>">
                                        <button type="submit">削除</button>
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

            <% if (hasItems) { %>
                <p class="total"><strong>合計金額: ¥<%= totalPrice %></strong></p>
                <div class="actions">
                    <form action="CheckoutServlet" method="post">
                        <input type="hidden" name="userID" value="<%= userID %>">
                        <button type="submit">お支払い</button>
                    </form>
                    <button onclick="location.href='shop.jsp'">ショップに戻る</button>
                    <button onclick="location.href='index.jsp'">ホームに戻る</button>
                </div>
            <% } else { %>
                <p class="empty-cart">ショッピングカートは空です。</p>
                <div class="actions">
                    <button onclick="location.href='shop.jsp'">ショップを見る</button>
                    <button onclick="location.href='index.jsp'">ホームに戻る</button>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>
