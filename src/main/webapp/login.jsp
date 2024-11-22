<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
    <title>ログイン</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f9f9f9;
        }
        h1 {
            text-align: center;
            color: #333;
        }
        form {
            max-width: 400px;
            margin: 0 auto;
            padding: 20px;
            background: white;
            border: 1px solid #ddd;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        form label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
        }
        form input {
            width: 100%;
            padding: 8px;
            margin-bottom: 16px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        form button {
            width: 100%;
            padding: 10px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }
        form button:hover {
            background-color: #45a049;
        }
        .message {
            text-align: center;
            margin-bottom: 16px;
        }
        .message a {
            color: #007BFF;
            text-decoration: none;
        }
        .message a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <h1>ログイン</h1>

    <% 
        // 提示メッセージの確認
        String success = request.getParameter("success");
        String error = request.getParameter("error");
    %>

    <% if (success != null) { %>
        <p class="message" style="color: green;">登録に成功しました。ログインしてください。</p>
    <% } %>

    <% if (error != null) { %>
        <p class="message" style="color: red;">ユーザー名またはパスワードが間違っています。再試行してください。</p>
    <% } %>

    <form action="${pageContext.request.contextPath}/LoginServlet" method="post">
        <label for="username">ユーザー名:</label>
        <input type="text" id="username" name="username" required>

        <label for="password">パスワード:</label>
        <input type="password" id="password" name="password" required>

        <button type="submit">ログイン</button>
    </form>

    <p class="message">アカウントをお持ちでない場合は？<a href="register.jsp">こちらをクリックして登録</a></p>
</body>
</html>
