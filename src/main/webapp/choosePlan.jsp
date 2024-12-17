<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, dao.DBConnection" %>
<%@ page import="java.text.NumberFormat"%>
<%
    NumberFormat currencyFormat = NumberFormat.getInstance(Locale.JAPAN); // 日本格式

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
<!DOCTYPE html>
<html>
<head>
    <title>ドローンプランの選択</title>
    <link rel="stylesheet" href="css/steamstyle.css">
    <style>
    
        .card-container {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
        }

        .card {
            position: relative;
            width: 300px;
            border: 1px solid #ccc;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            transition: transform 0.2s ease-in-out;
        }

        .card:hover {
            transform: scale(1.05);
        }

        .card-header {
            padding: 20px;
            background-color: #fff;
        }

        .detail-popup {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 300px;
            padding: 20px;
            background-color: white;
            border: 1px solid #ccc;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            z-index: 1000;
        }

        .detail-popup.active {
            display: block !important;
        }

        .modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 999;
        }

        .modal-overlay.active {
            display: block;
        }

        @keyframes zoom {
            0%, 100% {
                transform: scale(1);
            }
            50% {
                transform: scale(1.2);
            }
        }

        .card-header h1 {
            font-size: clamp(20px, 2.5vw, 24px);
            font-weight: bold;
            color: #4CAF50;
            text-align: center;
            min-height: 50px;
            line-height: 50px;
            word-spacing: 2px;
            animation: zoom 2s infinite ease-in-out; 
        }
        .box {
    background-color: #fff;
    border: 1px solid #ddd;
    border-radius: 5px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    margin-bottom: 20px;
    margin-top: 20px;
    padding: 20px;
    text-align: center; /* 文本居中对齐 */
}

.box h2 {
    font-size: 24px; /* 字体更大 */
    color: #007BFF; /* 使用适合的蓝色（如Bootstrap默认蓝色） */
    margin-bottom: 15px;
}

.box p {
    font-size: 18px; /* 增大字体 */
    color: #333; /* 与蓝色标题区分开来 */
    line-height: 1.6;
    margin: 5px 0;
}
        
    </style>
</head>
<body>
    <jsp:include page="menu.jsp" />
    <div class="container">
        <div class="module">
            <h1>ドローンプランの選択</h1>
            <div class="actions">
                <% if (userRole != null && userRole.equals(1)) { %>
                    <button onclick="location.href='managePlans.jsp'">プランを管理</button>
                <% } %>
            </div>

            <div class="card-container">
                <% for (Map<String, Object> plan : plans) { 
                   Integer pid = (Integer) plan.get("planID");
                   String pname = (String) plan.get("planName");
                   String duration = (String) plan.get("duration");
                   Integer amount = (Integer) plan.get("amount");
                   Integer price = (Integer) plan.get("price");
                %>
                    <div class="card">
                        <div class="card-header">
                            <h2><%= pname %></h2>
                            <h1>価格: ¥<%= currencyFormat.format(price) %></h1><br>
                            <p>契約期間: <%= duration %></p>
                            <p>収穫量: 約<%= amount %>kg</p>
                            <form action="SelectPlanMultipleServlet" method="post">
                                <input type="hidden" name="userID" value="<%= userID %>">
                                <input type="hidden" name="planID" value="<%= pid %>">
                                <label>選択回数:</label>
                                <input type="number" name="count" min="1" value="1">
                                <button type="submit">このプランを選択</button>
                                <button class="details-button" type="button" onclick="showDetail('<%= pid %>')">詳細</button>
                            </form>
                        </div>
                    </div>
                <% } %>
            </div>
            
            <div class="container">
                <div class="box">
        <h2>統一の説明</h2>
        <p><strong>収穫量: 米俵 約73個</strong>：</p>
        <p>ここでの「米俵約73個」とは、選択したプランによって期待される年間の収穫量を示します。1米俵は一定の重量を示し、この数値はおおよその収穫量目安です。</p>
        
        <p><strong>ドローン2機</strong>：</p>
        <p>ドローンの台数は、実際にカバーできる農地の面積や効率を表します。2機の場合、1機よりも広い範囲やより迅速な収穫作業が可能です。</p>
        
        <p><strong>方案の選択回数</strong>：</p>
        <p>選択回数は、同じプランをどれだけ繰り返し利用するかを示します。例えば、あるプランを年内に複数回選択することで、より多くの収穫機会やサービス提供が得られます。</p>
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
            

    
    <div class="modal-overlay" onclick="closeAllPopups()"></div>

    <%-- 在此处统一生成弹窗 --%>
 <% for (Map<String, Object> plan : plans) { 
   Integer pid = (Integer) plan.get("planID");
   String pname = (String) plan.get("planName");
   String duration = (String) plan.get("duration");
   Integer amount = (Integer) plan.get("amount");
   Integer price = (Integer) plan.get("price");
   out.println("<!-- DEBUG: Generating popup with ID = popup-" + pid + " -->");
%>
<div id="popup-<%= pid %>" class="detail-popup">
    <% if (pid == 1) { %>
        
        <h2>タスケ丸</h2>
        <p>￥880万</p>
        <p>予想収穫量: 米俵 約32個</p>
        <p>ドローン1機</p>
        <p>お米1種まで選択可能</p>
        <p>4000円/5kg</p>
    <% } else if (pid == 2) { %>
      
        <h2>スピード鳥</h2>
        <p>￥15400000</p>
        <p>収穫量: 米俵 約73個</p>
        <p>ドローン2機</p>
        <p>お米2種まで選択可能</p>
        <p>3500円/5kg</p>
    <% } else if (pid == 3) { %>
     
        <h2>天空侍</h2>
        <p>￥19800000</p>
        <p>収穫量：米俵 約110個</p>
        <p>ドローン3機</p>
        <p>お米3種まで選択可能</p>
        <p>3000円/5kg</p>
    <% } else { %>
        <!-- 对于其他ID的计划，按原逻辑显示数据库数据 -->
        <h2><%= pname %> の詳細</h2>
        <p>契約期間: <%= duration %></p>
        <p>収穫量: 約<%= amount %>kg</p>
        <p>価格: ¥<%= currencyFormat.format(price) %></p>
    <% } %>
    <button onclick="hideDetail('<%= pid %>')">閉じる</button>
</div>
<% } %>


    <script>
        function togglePlanHistory() {
            const historyDiv = document.getElementById('plan-history');
            if (historyDiv.style.display === 'none') {
                historyDiv.style.display = 'block';
            } else {
                historyDiv.style.display = 'none';
            }
        }

        function showDetail(planID) {
            console.trace("showDetail called with planID:", planID);
            const popup = document.getElementById("popup-" + planID);
            if (!popup) {
                console.error("Popup not found. ID: popup-" + planID);
            } else {
                popup.classList.add("active");
                document.querySelector(".modal-overlay").classList.add("active");
            }
        }

        function hideDetail(planID) {
            console.log("hideDetail called with planID:", planID);
            const popup = document.getElementById("popup-" + planID);
            if (popup) {
                popup.classList.remove("active");
                document.querySelector(".modal-overlay").classList.remove("active");
            } else {
                console.error("No popup found to hide with ID: popup-" + planID);
            }
        }

        function closeAllPopups() {
            document.querySelectorAll('.detail-popup.active').forEach(popup => {
                popup.classList.remove('active');
            });
            document.querySelector(".modal-overlay").classList.remove("active");
        }
    </script>
</body>
</html>
