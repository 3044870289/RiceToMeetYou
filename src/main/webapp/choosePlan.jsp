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
    <link rel="stylesheet" href="css/steamstyle.css">
</head>
<body>
    <jsp:include page="menu.jsp" />
     <div class="container">
        <div class="module">
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
                 <h1>価格: ¥<%= plan.get("price") %></h1>
                <p>契約期間: <%= plan.get("duration") %></p>
                <p>収穫量: 約<%= plan.get("amount") %>kg</p>
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
    <div class="container">
     <div class="box">
            <h2>統一の説明</h2>
            <p>すべてのプランは以下のルールを守ります。</p>
            <p></p>
        </div>
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
</div>
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
