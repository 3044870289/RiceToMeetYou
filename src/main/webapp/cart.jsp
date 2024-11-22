<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, dao.DBConnection" %>

<%
    String userID = (String) session.getAttribute("userID");
    if (userID == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>ショッピングカート</title>
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

        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
            background-color: #fff;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            border-radius: 5px;
        }

        th, td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: center;
        }

        th {
            background-color: #f2f2f2;
        }

        button {
            padding: 10px 15px;
            background-color: #4CAF50;
            color: white;
            border: none;
            cursor: pointer;
            border-radius: 5px;
        }

        button:hover {
            background-color: #45a049;
        }

        .actions {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-top: 20px;
        }

        .empty-cart {
            text-align: center;
            font-size: 18px;
            color: #888;
            margin-top: 30px;
        }

        .total {
            text-align: right;
            font-size: 18px;
            margin-top: 10px;
            color: #333;
        }
    </style>
</head>
<body>
<jsp:include page="menu.jsp" />
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
                stmt.setInt(1, Integer.parseInt(userID));
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
</body>
</html>
