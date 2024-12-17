<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, dao.DBConnection" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.text.NumberFormat"%>
<%
    NumberFormat currencyFormat = NumberFormat.getInstance(Locale.JAPAN); // 日本格式
%>
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
                                <td>¥<%= currencyFormat.format(rs.getInt("Price")) %></td> <!-- 格式化单价 -->
                                <td><%= rs.getInt("Quantity") %></td>
                                <td>¥<%= currencyFormat.format(totalPriceForItem) %></td> <!-- 格式化单项总价 -->
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
                <p class="total"><strong>合計金額: ¥<%= currencyFormat.format(totalPrice) %></strong></p> <!-- 格式化总金额 -->
                <div class="actions">
                    <form action="CheckoutServlet" method="post">
                        <input type="hidden" name="userID" value="<%= userID %>">
                        <button type="submit">お支払い</button>
                    </form>
                </div>
            <% } else { %>
                <p class="empty-cart">ショッピングカートは空です。</p>     
            <% } %>
        </div>
    </div>
</body>
</html>
