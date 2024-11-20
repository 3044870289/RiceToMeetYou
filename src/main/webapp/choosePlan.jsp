<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, dao.DBConnection" %>

<%
    // 获取 session 属性
    String username = (String) session.getAttribute("username");
    String userRole = (String) session.getAttribute("userRole");
    String userIDStr = (String) session.getAttribute("userID"); // 从 session 中获取 userID

    if (username == null || userRole == null || userIDStr == null) {
        response.sendRedirect("login.jsp");
        return; // 停止执行后续代码
    }

    int userID = Integer.parseInt(userIDStr); // 将 userID 转为整数类型

    // 查询用户的方案选择历史记录
    List<String> planHistory = new ArrayList<>();
    List<Timestamp> selectionTimestamps = new ArrayList<>();

    try (Connection conn = DBConnection.getConnection()) {
        String sql = "SELECT Plan, SelectionTime FROM DronePlanSelection WHERE UserID = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, userID);

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
    <title>选择无人机重点方案</title>
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

        /* 显示历史记录 */
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
        // 清除履历确认函数
        function confirmClear() {
            return confirm("确定要清除所有履历吗？此操作不可撤销！");
        }
    </script>
</head>
<body>
    <h1>无人机方案选择</h1>
    <p>您好，<%= username %>！</p>

    <!-- 方案选择卡片 -->
    <div class="card-container">
        <!-- 见习农夫 -->
        <div class="card">
            <h2>见习农夫</h2>
            <p>价格：10000</p>
            <p>土地面积：3000</p>
            <p>收获量：5000</p>
            <p>米的种类：1</p>
            <form action="SelectPlanServlet" method="post">
                <input type="hidden" name="userID" value="<%= userID %>">
                <input type="hidden" name="plan" value="A">
                <button type="submit">选择此方案</button>
            </form>
        </div>

        <!-- 专业农夫 -->
        <div class="card">
            <h2>专业农夫</h2>
            <p>价格：20000</p>
            <p>土地面积：5000</p>
            <p>收获量：10000</p>
            <p>米的种类：3</p>
            <form action="SelectPlanServlet" method="post">
                <input type="hidden" name="userID" value="<%= userID %>">
                <input type="hidden" name="plan" value="B">
                <button type="submit">选择此方案</button>
            </form>
        </div>

        <!-- 超人农夫 -->
        <div class="card">
            <h2>超人农夫</h2>
            <p>价格：50000</p>
            <p>土地面积：10000</p>
            <p>收获量：50000</p>
            <p>米的种类：10</p>
            <form action="SelectPlanServlet" method="post">
                <input type="hidden" name="userID" value="<%= userID %>">
                <input type="hidden" name="plan" value="C">
                <button type="submit">选择此方案</button>
            </form>
        </div>
    </div>

    <!-- 显示方案选择历史 -->
    <h2>您的方案选择历史</h2>
    <% if (planHistory.isEmpty()) { %>
        <p>您尚未选择任何方案。</p>
    <% } else { %>
        <table>
            <tr>
                <th>方案</th>
                <th>选择时间</th>
            </tr>
            <% for (int i = 0; i < planHistory.size(); i++) { %>
                <tr>
                    <td><%= planHistory.get(i) %></td>
                    <td><%= selectionTimestamps.get(i) %></td>
                </tr>
            <% } %>
        </table>
    <% } %>

    <!-- 清除所有履历 -->
    <form action="ClearHistoryServlet" method="post" onsubmit="return confirmClear();">
        <input type="hidden" name="userID" value="<%= userID %>">
        <button type="submit">清除所有履历</button>
    </form>

    <!-- 返回主页按钮 -->
    <button onclick="location.href='index.jsp'">返回主页</button>
</body>
</html>
