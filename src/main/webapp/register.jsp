<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>ユーザー登録</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f9f9f9;
        }

        .container {
            max-width: 400px;
            margin: 50px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 5px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        h1 {
            text-align: center;
            color: #4CAF50;
            margin-bottom: 20px;
        }

        form {
            display: flex;
            flex-direction: column;
        }

        label {
            margin-bottom: 5px;
            color: #333;
        }

        input[type="text"],
        input[type="password"],
        input[type="email"] {
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ddd;
            border-radius: 3px;
            font-size: 14px;
        }

        button {
            padding: 10px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }

        button:hover {
            background-color: #45a049;
        }

        p {
            text-align: center;
            color: #333;
            margin-top: 10px;
        }

        p a {
            color: #4CAF50;
            text-decoration: none;
        }

        p a:hover {
            text-decoration: underline;
        }

        .error {
            color: red;
            margin-bottom: 15px;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>新規登録</h1>

        <% if (request.getParameter("error") != null) { %>
            <p class="error">登録に失敗しました。入力内容をご確認ください。</p>
        <% } %>

        <form action="RegisterServlet" method="post">
            <label for="username">ユーザー名:</label>
            <input type="text" id="username" name="username" required>
            
            <label for="password">パスワード:</label>
            <input type="password" id="password" name="password" required>
            
            <label for="email">メールアドレス:</label>
            <input type="email" id="email" name="email">
            
            <label for="address">住所:</label>
            <input type="text" id="address" name="address">
            
            <button type="submit">登録</button>
        </form>

        <p>すでにアカウントをお持ちですか？<a href="login.jsp">ログインはこちら</a></p>
    </div>
</body>
</html>
