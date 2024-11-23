<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, dao.DBConnection" %>

<%
    // 从会话中获取属性
    String username = (String) session.getAttribute("username");
    Integer userRole = (Integer) session.getAttribute("userRole");
    Integer userID = (Integer) session.getAttribute("userID"); // 从会话中获取 userID

    if (username == null || userRole == null || userID == null) {
        response.sendRedirect("login.jsp");
        return; // 停止后续代码执行
    }

    // 获取用户的计划选择历史
    List<String> planHistory = new ArrayList<>();
    List<Timestamp> selectionTimestamps = new ArrayList<>();

    try (Connection conn = DBConnection.getConnection()) {
        String sql = "SELECT Plan, SelectionTime FROM DronePlanSelection WHERE UserID = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, userID); // 使用 Integer 类型的 userID

        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            planHistory.add(rs.getString("Plan"));
            selectionTimestamps.add(rs.getTimestamp("SelectionTime"));
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<html>
<head>
    <title>ドローンプランの選択</title>
    <style>
        /* 页面整体布局 */
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

        /* 历史记录显示 */
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

    </style>
    <script>
        // 确认清除历史记录
        function confirmClear() {
            return confirm("全ての履歴をクリアしますか？この操作は取り消せません！");
        }
    </script>
</head>
<body>
    <jsp:include page="menu.jsp" />
    <h1>ドローンプランの選択</h1>
    <p>こんにちは、<%= username %>さん！</p>

    <!-- 计划选择卡片 -->
    <div class="card-container">
        <!-- 初心者プラン -->
        <div class="card">
            <h2>初心者プラン</h2>
            <p>価格：10000</p>
            <p>土地面積：3000</p>
            <p>収穫量：5000</p>
            <p>お米の種類：1</p>
            <form action="SelectPlanServlet" method="post">
                <input type="hidden" name="userID" value="<%= userID %>">
                <input type="hidden" name="plan" value="A">
                <button type="submit">このプランを選択</button>
            </form>
        </div>

        <!-- プロフェッショナルプラン -->
        <div class="card">
            <h2>プロフェッショナルプラン</h2>
            <p>価格：20000</p>
            <p>土地面積：5000</p>
            <p>収穫量：10000</p>
            <p>お米の種類：3</p>
            <form action="SelectPlanServlet" method="post">
                <input type="hidden" name="userID" value="<%= userID %>">
                <input type="hidden" name="plan" value="B">
                <button type="submit">このプランを選択</button>
            </form>
        </div>

        <!-- スーパープラン -->
        <div class="card">
            <h2>スーパープラン</h2>
            <p>価格：50000</p>
            <p>土地面積：10000</p>
            <p>収穫量：50000</p>
            <p>お米の種類：10</p>
            <form action="SelectPlanServlet" method="post">
                <input type="hidden" name="userID" value="<%= userID %>">
                <input type="hidden" name="plan" value="C">
                <button type="submit">このプランを選択</button>
            </form>
        </div>
    </div>

    <!-- 计划选择历史记录 -->
    <h2>プラン選択履歴</h2>
    <% if (planHistory.isEmpty()) { %>
        <p>まだプランを選択していません。</p>
    <% } else { %>
        <table>
            <tr>
                <th>プラン</th>
                <th>選択日時</th>
            </tr>
            <% for (int i = 0; i < planHistory.size(); i++) { %>
                <tr>
                    <td><%= planHistory.get(i) %></td>
                    <td><%= selectionTimestamps.get(i) %></td>
                </tr>
            <% } %>
        </table>
    <% } %>

    <!-- 清除历史记录 -->
    <form action="ClearHistoryServlet" method="post" onsubmit="return confirmClear();">
        <input type="hidden" name="userID" value="<%= userID %>">
        <button type="submit">全ての履歴をクリア</button>
    </form>

    <!-- 返回主页按钮 -->
    <button onclick="location.href='index.jsp'">ホームに戻る</button>
    <button onclick="location.href='cart.jsp'">カートを見る</button>
</body>
</html>
