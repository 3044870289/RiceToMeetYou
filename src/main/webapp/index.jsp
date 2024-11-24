<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.sql.*, dao.DBConnection" %>

<%
    // 从会话中获取必要的用户信息
    Integer userID = (Integer) session.getAttribute("userID");
    Integer userRole = (Integer) session.getAttribute("userRole");
    String username = (String) session.getAttribute("username");

    if (userID == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Map<String, String>> purchaseHistory = new ArrayList<>();
    List<Map<String, String>> planSelectionHistory = new ArrayList<>();

    // 查询数据库记录
    try (Connection conn = DBConnection.getConnection()) {
        // 查询购买记录
        String purchaseQuery = "SELECT PurchaseID, TotalAmount, PurchaseTime FROM Purchase WHERE UserID = ?";
        PreparedStatement purchaseStmt = conn.prepareStatement(purchaseQuery);
        purchaseStmt.setInt(1, userID);
        ResultSet purchaseRS = purchaseStmt.executeQuery();

        while (purchaseRS.next()) {
            Map<String, String> record = new HashMap<>();
            record.put("purchaseID", String.valueOf(purchaseRS.getInt("PurchaseID")));
            record.put("totalAmount", String.valueOf(purchaseRS.getInt("TotalAmount")));
            record.put("purchaseTime", purchaseRS.getString("PurchaseTime"));
            purchaseHistory.add(record);
        }

        // 查询方案选择记录
        String planQuery = "SELECT dp.planName, dps.Count, dps.SelectionTime FROM DronePlanSelection dps " +
                           "INNER JOIN DronePlans dp ON dps.planID = dp.planID WHERE dps.UserID = ?";
        PreparedStatement planStmt = conn.prepareStatement(planQuery);
        planStmt.setInt(1, userID);
        ResultSet planRS = planStmt.executeQuery();

        while (planRS.next()) {
            Map<String, String> record = new HashMap<>();
            record.put("plan", planRS.getString("planName"));
            record.put("count", String.valueOf(planRS.getInt("Count")));
            record.put("selectionTime", planRS.getString("SelectionTime"));
            planSelectionHistory.add(record);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>ホーム</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f9f9f9;
        }

        h1, h2 {
            color: #333;
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

        .button {
            padding: 10px 15px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .button:hover {
            background-color: #45a049;
        }

        .message {
            margin: 10px 0;
            font-size: 16px;
            padding: 10px;
            border-radius: 5px;
        }

        .success {
            color: green;
            background-color: #e8f5e9;
        }

        .error {
            color: red;
            background-color: #ffebee;
        }

        .info {
            color: blue;
            background-color: #e3f2fd;
        }
    </style>
</head>
<body>
    <jsp:include page="menu.jsp" />
    <h1>ホームへようこそ</h1>
    <p><%= username %> 様、ようこそ！</p>

    <% if (userRole != null && userRole.equals(1)) { %>
        <button class="button" onclick="location.href='admin.jsp'">ユーザー管理</button>
    <% } else if (userRole.equals(2)) { %>
        <button class="button" onclick="location.href='user.jsp'">個人情報編集</button>
    <% } %>
    <button class="button" onclick="location.href='logout.jsp'">ログアウト</button>

    <!-- 消息显示 -->
   <% 
    String successMessage = request.getParameter("success");
    String infoMessage = request.getParameter("info");
    String errorMessage = request.getParameter("error");
%>

<% if ("clear_plan_history".equals(successMessage)) { %>
    <p class="success-message">プラン履歴と関連ドローンが正常に削除されました。</p>
<% } else if ("no_plan_history_or_drones".equals(infoMessage)) { %>
    <p class="info-message">削除するプラン履歴やドローンがありません。</p>
<% } else if ("clear_plan_history".equals(errorMessage)) { %>
    <p class="error-message">プラン履歴の削除中にエラーが発生しました。</p>
<% } %>

    <h2>購入履歴</h2>
    <table>
        <tr>
            <th>購入金額</th>
            <th>購入日時</th>
            <th>詳細</th>
        </tr>
        <% for (Map<String, String> record : purchaseHistory) { %>
            <tr>
                <td>¥<%= record.get("totalAmount") %></td>
                <td><%= record.get("purchaseTime") %></td>
                <td>
                    <form action="PurchaseDetailsServlet" method="get">
                        <input type="hidden" name="purchaseID" value="<%= record.get("purchaseID") %>">
                        <button class="button" type="submit">詳細を見る</button>
                    </form>
                </td>
            </tr>
        <% } %>
    </table>

    <h2>プラン選択履歴</h2>
    <table>
        <tr>
            <th>プラン</th>
            <th>選択回数</th>
            <th>選択日時</th>
        </tr>
        <% if (planSelectionHistory.isEmpty()) { %>
            <tr>
                <td colspan="3">プラン選択履歴がありません。</td>
            </tr>
        <% } else { 
            for (Map<String, String> record : planSelectionHistory) { %>
                <tr>
                    <td><%= record.get("plan") %></td>
                    <td><%= record.get("count") %></td>
                    <td><%= record.get("selectionTime") %></td>
                </tr>
        <% } } %>
    </table>

   <% if (!planSelectionHistory.isEmpty()) { %>
    <form action="ClearPlanHistoryServlet" method="post" onsubmit="return confirm('プラン選択履歴を清空しますか？');">
        <button class="button" type="submit">プラン選択履歴を清空</button>     
    </form>
    <button class="button" onclick="location.href='droneMap.jsp'">ドローンの位置を見る</button>
<% } %>

</body>
</html>
