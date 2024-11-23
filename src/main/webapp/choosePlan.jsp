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

    try (Connection conn = DBConnection.getConnection()) {
        String sql = "SELECT Plan, Count, SelectionTime FROM DronePlanSelection WHERE UserID = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, userID);

        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            planHistory.add(rs.getString("Plan"));
            counts.add(rs.getInt("Count"));
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
    </style>
</head>
<body>
    <jsp:include page="menu.jsp" />
    <h1>ドローンプランの選択</h1>
    <p>こんにちは、<%= username %>さん！</p>

    <!-- 卡片布局 -->
    <div class="card-container">
        <div class="card">
            <h2>スターター・プラン</h2>
            <p>契約期間: 1年</p>
            <p>収穫量: 約146kg（1機）</p>
            <p>価格: ¥500,000</p>
            <form action="SelectPlanMultipleServlet" method="post">
                <input type="hidden" name="userID" value="<%= userID %>">
                <input type="hidden" name="plan" value="A">
                <label>選択回数:</label>
                <input type="number" name="count" min="1" value="1">
                <button type="submit">このプランを選択</button>
            </form>
        </div>

        <div class="card">
            <h2>プロフェッショナル・プラン</h2>
            <p>契約期間: 3年</p>
            <p>収穫量: 約292kg（2機）</p>
            <p>価格: ¥3,000,000</p>
            <form action="SelectPlanMultipleServlet" method="post">
                <input type="hidden" name="userID" value="<%= userID %>">
                <input type="hidden" name="plan" value="B">
                <label>選択回数:</label>
                <input type="number" name="count" min="1" value="1">
                <button type="submit">このプランを選択</button>
            </form>
        </div>

        <div class="card">
            <h2>アルティメット・プラン</h2>
            <p>契約期間: 5～10年</p>
            <p>収穫量: 約584kg（4機）</p>
            <p>価格: ¥8,000,000</p>
            <form action="SelectPlanMultipleServlet" method="post">
                <input type="hidden" name="userID" value="<%= userID %>">
                <input type="hidden" name="plan" value="C">
                <label>選択回数:</label>
                <input type="number" name="count" min="1" value="1">
                <button type="submit">このプランを選択</button>
            </form>
        </div>
    </div>

    <!-- 详细说明 -->
    <div class="details-box">
        <h2>詳細</h2>
        <p>収穫回数: 年に3回</p>
        <p>1回あたりの収穫量: 1機が48kgの収穫</p>
        <p>年間収穫量計算:</p>
        <ul>
            <li>スターター・プラン: 1機 × 3回 × 48kg = 144kg</li>
            <li>プロフェッショナル・プラン: 2機 × 3回 × 48kg = 288kg</li>
            <li>アルティメット・プラン: 4機 × 3回 × 48kg = 576kg</li>
        </ul>
    </div>

    <!-- プラン選択履歴 -->
    <h2>プラン選択履歴</h2>
    <% if (planHistory.isEmpty()) { %>
        <p>まだプランを選択していません。</p>
    <% } else { %>
        <table>
            <tr>
                <th>プラン</th>
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

    <!-- 清空履歴 -->
    <form action="ClearHistoryServlet" method="post" onsubmit="return confirm('全ての履歴をクリアしますか？');">
        <input type="hidden" name="userID" value="<%= userID %>">
        <button type="submit">全ての履歴をクリア</button>
    </form>
</body>
</html>
