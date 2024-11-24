<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, dao.DBConnection" %>

<%
    String username = (String) session.getAttribute("username");
    Integer userRole = (Integer) session.getAttribute("userRole");
    Integer userID = (Integer) session.getAttribute("userID");

    if (username == null || userRole == null || userID == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<String> planHistory = new ArrayList<>();
    List<Integer> counts = new ArrayList<>();
    List<Timestamp> selectionTimestamps = new ArrayList<>();

    List<Map<String, Object>> plans = new ArrayList<>();
    try (Connection conn = DBConnection.getConnection()) {
        // 获取 DronePlans 数据
        String sql = "SELECT planID, planName, contractDuration, harvestAmount, price FROM DronePlans";
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(sql);

        while (rs.next()) {
            Map<String, Object> plan = new HashMap<>();
            plan.put("planID", rs.getInt("planID"));
            plan.put("planName", rs.getString("planName"));
            plan.put("duration", rs.getString("contractDuration"));
            plan.put("amount", rs.getInt("harvestAmount"));
            plan.put("price", rs.getInt("price"));
            plans.add(plan);
        }

        // 获取用户历史选择数据
        sql = "SELECT planID, Count, SelectionTime FROM DronePlanSelection WHERE UserID = ?";
        PreparedStatement stmtHistory = conn.prepareStatement(sql);
        stmtHistory.setInt(1, userID);
        ResultSet historyRs = stmtHistory.executeQuery();

        while (historyRs.next()) {
            planHistory.add(historyRs.getString("planID"));
            counts.add(historyRs.getInt("Count"));
            selectionTimestamps.add(historyRs.getTimestamp("SelectionTime"));
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<html>
<head>
    <title>ドローンプランの選択</title>
     <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f4f4f9;
        }

        h1 {
            text-align: center;
            color: #333;
        }

        .card-container {
            display: flex;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 20px;
            margin-top: 20px;
        }

        .card {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 30%;
            padding: 20px;
            box-sizing: border-box;
            transition: transform 0.3s;
        }

        .card:hover {
            transform: translateY(-10px);
        }

        .card h2 {
            font-size: 24px;
            color: #333;
            text-align: center;
        }

        .card p {
            font-size: 16px;
            color: #666;
            margin-bottom: 10px;
        }

        .card input[type="number"] {
            width: 100%;
            padding: 8px;
            margin-top: 10px;
            font-size: 16px;
            box-sizing: border-box;
            border: 1px solid #ddd;
            border-radius: 5px;
        }

        .card button {
            display: block;
            width: 100%;
            padding: 10px;
            background-color: #4CAF50;
            color: white;
            font-size: 16px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-top: 10px;
        }

        .card button:hover {
            background-color: #45a049;
        }

        table {
            width: 100%;
            margin-top: 20px;
            border-collapse: collapse;
        }

        table, th, td {
            border: 1px solid #ddd;
        }

        th, td {
            padding: 8px 12px;
            text-align: left;
        }

        th {
            background-color: #f4f4f9;
        }

        .details-box {
            margin-top: 20px;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 20px;
            font-size: 16px;
            color: #333;
            line-height: 1.6;
        }

        .actions {
            margin-top: 20px;
            text-align: center;
        }

        .actions button {
            padding: 10px 20px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }

        .actions button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <jsp:include page="menu.jsp" />
    <h1>ドローンプランの選択</h1>
    <div class="actions">
        <% if (userRole.equals(1)) { %>
            <button onclick="location.href='managePlans.jsp'">プランを管理</button>
        <% } %>
    </div>

    <div class="card-container">
        <% for (Map<String, Object> plan : plans) { %>
            <div class="card">
                <h2><%= plan.get("planName") %></h2>
                <p>契約期間: <%= plan.get("duration") %></p>
                <p>収穫量: 約<%= plan.get("amount") %>kg</p>
                <p>価格: ¥<%= plan.get("price") %></p>
                <form action="SelectPlanMultipleServlet" method="post">
                    <input type="hidden" name="userID" value="<%= userID %>">
                    <input type="hidden" name="planID" value="<%= plan.get("planID") %>">
                    <label>選択回数:</label>
                    <input type="number" name="count" min="1" value="1">
                    <button type="submit">このプランを選択</button>
                </form>
            </div>
        <% } %>
    </div>

    <h2>プラン選択履歴</h2>
<div id="plan-history">
    <% if (planHistory.isEmpty()) { %>
        <p>まだプランを選択していません。</p>
    <% } else { %>
        <table>
            <tr>
                <th>プランID</th>
                <th>選択回数</th>
                <th>選択日時</th>
            </tr>
            <% for (int i = 0; i < planHistory.size(); i++) { %>
                <tr>
                    <td><%= planHistory.get(i) %></td>
                    <td><%= counts.get(i) %></td>
                    <td><%= selectionTimestamps.get(i) %></td>
                </tr>
            <% } %>
        </table>
    <% } %>
</div>

<div class="actions">
    <button onclick="togglePlanHistory()">プラン履歴を表示/非表示</button>
      <button class="button" onclick="location.href='droneMap.jsp'">ドローンの位置を見る</button>
</div>

<script>
    function togglePlanHistory() {
        const historyDiv = document.getElementById('plan-history');
        if (historyDiv.style.display === 'none') {
            historyDiv.style.display = 'block';
        } else {
            historyDiv.style.display = 'none';
        }
    }
</script>

</body>
</html>
