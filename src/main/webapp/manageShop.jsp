<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, dao.DBConnection" %>

<%
    String successMessage = request.getParameter("success");
    String errorMessage = request.getParameter("error");

    if ("item_deleted".equals(successMessage)) {
%>
        <p style="color: green; text-align: center;">商品が正常に削除されました。</p>
<%
    } else if ("database_error".equals(errorMessage)) {
%>
        <p style="color: red; text-align: center;">商品を削除中にエラーが発生しました。</p>
<%
    } else if ("missing_id".equals(errorMessage)) {
%>
        <p style="color: red; text-align: center;">商品IDが見つかりません。</p>
<%
    }
%>

<%
    String username = (String) session.getAttribute("username");
    Integer userRole = (Integer) session.getAttribute("userRole");

    if (username == null || userRole == null || userRole != 1) {
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
            product.put("price", rs.getDouble("Price"));
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
    <title>商品管理</title>
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
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: center;
        }
        th {
            background-color: #f2f2f2;
        }
        .actions {
            margin-top: 20px;
            text-align: center;
        }
        .button {
            padding: 10px 15px;
            background-color: #4CAF50;
            color: white;
            border: none;
            cursor: pointer;
            border-radius: 5px;
            margin-right: 10px;
        }
        .button:hover {
            background-color: #45a049;
        }
        .form-container {
            margin: 20px 0;
            padding: 20px;
            border: 1px solid #ddd;
            background-color: #fff;
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <jsp:include page="menu.jsp" />
    <h1>商品管理</h1>

    <!-- 商品表格 -->
    <% if (products.isEmpty()) { %>
        <p>現在、ショップに商品はありません。</p>
    <% } else { %>
        <table>
            <tr>
                <th>ID</th>
                <th>商品名</th>
                <th>説明</th>
                <th>価格</th>
                <th>在庫</th>
                <th>画像</th>
                <th>操作</th>
            </tr>
            <% for (Map<String, Object> product : products) { %>
                <tr>
                    <td><%= product.get("id") %></td>
                    <td><%= product.get("name") %></td>
                    <td><%= product.get("comment") %></td>
                    <td>¥<%= product.get("price") %></td>
                    <td><%= product.get("stock") %></td>
                    <td><img src="images/<%= product.get("photo") %>" alt="<%= product.get("name") %>" style="max-height: 50px;"></td>
                    <td>
                        <!-- 编辑表单 -->
                        <meta charset="UTF-8">
                       <form action="editItem.jsp" method="get" style="display: inline;">
    <input type="hidden" name="id" value="<%= product.get("id") %>">
    <button type="submit" class="button">編集</button>
</form>

                        <!-- 删除表单 -->
                        <form action="DeleteItemServlet" method="post" style="display: inline;" onsubmit="return confirm('この商品を削除しますか？');">
                            <input type="hidden" name="id" value="<%= product.get("id") %>">
                            <button type="submit" class="button" style="background-color: #f44336;">削除</button>
                        </form>
                    </td>
                </tr>
            <% } %>
        </table>
    <% } %>

    <!-- 新增商品表单 -->
    <div class="form-container">
    <h2>新商品を追加</h2>
    <form action="AddItemServlet" method="post" enctype="multipart/form-data">
        <p>
            商品名: <input type="text" name="name" required>
        </p>
        <p>
            説明: <input type="text" name="comment" required>
        </p>
        <p>
            価格: <input type="number" name="price" step="0.01" required>
        </p>
        <p>
            在庫: <input type="number" name="stock" min="0" required>
        </p>
        <p>
            画像ファイル: <input type="file" name="photo" accept="image/*" required>
        </p>
        <button type="submit" class="button">追加</button>
    </form>
</div>

</body>
</html>
