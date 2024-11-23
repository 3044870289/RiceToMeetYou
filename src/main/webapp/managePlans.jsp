<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, dao.DBConnection" %>

<%
    String username = (String) session.getAttribute("username");
    Integer userRole = (Integer) session.getAttribute("userRole");

    if (username == null || userRole == null || userRole != 1) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Map<String, Object>> plans = new ArrayList<>();
    try (Connection conn = DBConnection.getConnection()) {
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
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<html>
<head>
    <title>プラン管理</title>
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
        .back-button {
            display: block;
            margin: 20px auto;
            padding: 10px 20px;
            background-color: #007BFF;
            color: white;
            border: none;
            border-radius: 5px;
            text-align: center;
            text-decoration: none;
            font-size: 16px;
            cursor: pointer;
            max-width: 200px;
        }
        .back-button:hover {
            background-color: #0056b3;
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
            font-size: 20px;
            color: #333;
            text-align: center;
            margin-bottom: 20px;
        }
        .card form p {
            margin-bottom: 15px;
        }
        .card form label {
            display: block;
            font-weight: bold;
            margin-bottom: 5px;
        }
        .card form input {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            box-sizing: border-box;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .card form button {
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
        .card form button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <h1>プラン管理</h1>
    <a href="choosePlan.jsp" class="back-button">プラン選択に戻る</a>
    
    <div class="card-container">
        <% for (Map<String, Object> plan : plans) { %>
            <div class="card">
                <h2><%= plan.get("planName") %></h2>
                <form action="EditPlanServlet" method="post">
                    <input type="hidden" name="planID" value="<%= plan.get("planID") %>">

                    <p>
                        <label for="planName_<%= plan.get("planID") %>">プラン名称:</label>
                        <input type="text" id="planName_<%= plan.get("planID") %>" name="planName" value="<%= plan.get("planName") %>" required>
                    </p>
                    <p>
                        <label for="duration_<%= plan.get("planID") %>">契約期間:</label>
                        <input type="text" id="duration_<%= plan.get("planID") %>" name="duration" value="<%= plan.get("duration") %>" required>
                    </p>
                    <p>
                        <label for="amount_<%= plan.get("planID") %>">収穫量:</label>
                        <input type="number" id="amount_<%= plan.get("planID") %>" name="amount" value="<%= plan.get("amount") %>" required>
                    </p>
                    <p>
                        <label for="price_<%= plan.get("planID") %>">価格:</label>
                        <input type="number" id="price_<%= plan.get("planID") %>" name="price" value="<%= plan.get("price") %>" required>
                    </p>
                    <button type="submit">保存</button>
                </form>
            </div>
        <% } %>
    </div>
</body>
</html>
