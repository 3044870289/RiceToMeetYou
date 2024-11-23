<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map" %> <!-- 导入必要的类 -->

<html>
<head>
    <title>購入詳細</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: center;
        }
        th {
            background-color: #f4f4f4;
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

            // 遍历购买详情并渲染表格内容
            if (details != null) {
                for (Map<String, String> detail : details) {
        %>
                    <tr>
                        <td><%= detail.get("name") %></td>
                        <td>¥<%= detail.get("price") %></td>
                        <td><%= detail.get("quantity") %></td>
                    </tr>
        <% 
                }
            } else { 
        %>
                <tr>
                    <td colspan="3">購入詳細が見つかりません。</td>
                </tr>
        <% 
            } 
        %>
    </table>
    <button onclick="location.href='index.jsp'">戻る</button>
</body>
</html>
