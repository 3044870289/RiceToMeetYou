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
    
    // 随机标语及其权重
    String[] slogans = {
        "⭐️稲穂が実るように、あなたの人生も輝きますように！⭐",
        "⭐⭐空を飛ぶドローンのように、稲神が幸せを運びます！⭐⭐",
        "⭐⭐天空の稲神からのお告げ：今すぐお米を食べましょう！⭐⭐",
        "⭐⭐⭐天空のお米から地上の幸せまで、稲神様が守っています。⭐⭐⭐",
        "⭐⭐⭐⭐⭐ドローンの稲神、あなたに幸運を届けます！⭐⭐⭐⭐⭐"
    };
    int[] weights = {30, 30, 25, 10, 5}; // 权重之和应为100

    // 计算随机标语
    String selectedSlogan = "";
    int randomValue = new Random().nextInt(100); // 生成 0-99 的随机数
    int cumulativeWeight = 0;
    for (int i = 0; i < slogans.length; i++) {
        cumulativeWeight += weights[i];
        if (randomValue < cumulativeWeight) {
            selectedSlogan = slogans[i];
            break;
        }
    }
%>

<html lang="ja">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="css/steamstyle.css">
    <title>ホーム</title>  
    <style>
        /* 标语淡入 + 打字机效果 */
        .slogan {
            font-size: 20px;
            font-weight: bold;
            color: #4CAF50;
            white-space: nowrap;
            overflow: hidden;
            animation: typing 3s steps(120, end), blink-caret 0.5s step-end infinite;
        }

        @keyframes typing {
            from {
                width: 0;
            }
            to {
                width: 100%; /* 完全显示 */
            }
        }

        @keyframes blink-caret {
            from, to {
                border-color: transparent;
            }
            50% {
                border-color: #4CAF50;
            }
        }

        /* 按钮容器居中 */
        .button-container {
            text-align: center;
            margin-top: 20px;
        }

        .button-container button {
            margin: 10px; /* 按钮之间的间距 */
        }
    </style>
</head>
<body>
    <jsp:include page="menu.jsp" />
    <div class="container">
        <div class="module">
            <h1>ホームへようこそ</h1>
            <p class="slogan" id="slogan"></p>
            <p><%= username %> 様、ようこそ！</p>

            <div class="button-container">
                <% if (userRole != null && userRole.equals(1)) { %>
                    <button class="button" onclick="location.href='admin.jsp'">ユーザー管理</button>
                <% } %>
                <button class="button" onclick="location.href='logout.jsp'">ログアウト</button>
            </div>

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
            
            <div class="button-container">
                <button class="button" onclick="location.href='droneMap.jsp'">ドローンの位置を見る</button>
                <form action="ClearPlanHistoryServlet" method="post" style="display: inline;">
                    <button class="button" type="submit">プラン選択履歴を清空</button>
                </form>
            </div>
        </div>
    </div>

    <script>
        // 设置标语的文字内容
        const sloganText = "<%= selectedSlogan %>";
        const sloganElement = document.getElementById("slogan");
        sloganElement.innerText = sloganText; // 初始化内容
    </script>
</body>
</html>
