<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map, java.text.NumberFormat, java.util.Locale" %>
<html lang="ja">
<head>
    <title>購入詳細</title>
    <style>
        /* 全局样式 */
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f9f9f9;
            color: #333;
        }
        h1 {
            font-size: 24px;
            text-align: center;
            margin-bottom: 20px;
            color: #4CAF50;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
            background-color: #fff;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        th, td {
            border: 1px solid #ddd;
            padding: 12px 15px;
            text-align: center;
        }
        th {
            background-color: #4CAF50;
            color: #fff;
            font-size: 16px;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        tr:hover {
            background-color: #f1f1f1;
        }
        td {
            font-size: 14px;
        }
        .back-button {
            display: inline-block;
            padding: 10px 20px;
            margin-top: 20px;
            background-color: #4CAF50;
            color: #fff;
            border: none;
            border-radius: 5px;
            text-decoration: none;
            font-size: 14px;
            cursor: pointer;
            text-align: center;
            transition: background-color 0.3s ease;
        }
        .back-button:hover {
            background-color: #45a049;
        }
        .empty-row {
            text-align: center;
            font-size: 14px;
            color: #666;
        }
    </style>
</head>
<body>
    <h1>購入詳細</h1>
    <table>
        <tr>
            <th>商品名</th>
            <th>単価</th>
            <th>数量</th>
        </tr>
        <%
            // 获取从 Servlet 设置的购买详情数据
            List<Map<String, String>> details = (List<Map<String, String>>) request.getAttribute("details");

            // 定义 NumberFormat 对象（用于格式化金额）
            NumberFormat currencyFormat = NumberFormat.getNumberInstance(Locale.JAPAN);

            // 遍历购买详情并渲染表格内容
            if (details != null && !details.isEmpty()) {
                for (Map<String, String> detail : details) {
                    String priceStr = detail.get("price");
                    double price = Double.parseDouble(priceStr); // 转换为数值
        %>
                    <tr>
                        <td><%= detail.get("name") %></td>
                        <td>¥<%= currencyFormat.format(price) %></td>
                        <td><%= detail.get("quantity") %></td>
                    </tr>
        <% 
                }
            } else { 
        %>
                <tr>
                    <td colspan="3" class="empty-row">購入詳細が見つかりません。</td>
                </tr>
        <% 
            } 
        %>
    </table>
    <div style="text-align: center;">
        <button class="back-button" onclick="location.href='index.jsp'">戻る</button>
    </div>
</body>
</html>
