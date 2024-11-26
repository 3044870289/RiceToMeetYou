<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.sql.*, dao.DBConnection" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>ドローンリアルタイムマップ</title>
    <style>
        #map { height: 800px; width: 100%; }
        body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #f9f9f9; }
        h1, h2 { text-align: center; color: #333; }
        .controls {
            text-align: center;
            margin-bottom: 20px;
        }
        .controls button {
            margin: 0 10px;
            padding: 10px 20px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }
        .controls button:hover {
            background-color: #45a049;
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
             display: inline-block !important;
    visibility: visible !important;
    z-index: 9999 !important;
        }
        .button:hover {
            background-color: #45a049;
        }
    </style>
</head>

<body>
    <jsp:include page="menu.jsp" />
    <h1>ドローンリアルタイムマップ</h1>

    <!-- 控制部分 -->
    <div class="controls">
        <button id="showOwnDrones">自分のドローンを表示</button>
        <button id="showAllDrones">すべてのドローンを表示</button>
        <!--   <button id="moveMultipleDrones">複数ドローンを移動</button>  功能有点垃圾 ，只能将固定前几个无人机移动到固定的几个坐标-->
    </div>

    <!-- 地图显示 -->
    <div id="map"></div>

    <!-- 显示历史记录 -->
    <h2>プラン選択履歴</h2>
    <%
        Integer userID = (Integer) session.getAttribute("userID");
        if (userID == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<Map<String, String>> planSelectionHistory = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {
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
    <% } %>

    <!-- 加载 JavaScript 文件 -->
    <script src="/RiceToMeetYou/js/droneMap.js"></script>
    <!-- 异步加载 Google Maps API -->
    <script
        src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAJCDwqKJFUaPhL2xz76qOOSKDCgBKj7OM&callback=initMap"
        async
        defer
    ></script>
</body>
</html>
