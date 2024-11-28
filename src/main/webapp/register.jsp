<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>ユーザー登録</title>
    <link rel="stylesheet" href="css/loginstyle.css">
    <style>
        /* 新增样式 */
        .message {
            color: white; /* 设置文字为白色 */
            font-weight: bold; /* 设置文字加粗 */
            text-align: center; /* 居中显示（可选，根据需求） */
        }

        .message a {
            color: #4CAF50; /* 超链接为绿色 */
            text-decoration: none; /* 去除下划线 */
        }

        .message a:hover {
            color: #45a049; /* 鼠标悬停时的颜色 */
        }
    </style>
</head>
<body>
    <div class="box">
        <h2>新規登録</h2>

        <% if (request.getParameter("error") != null) { %>
            <p class="message" style="color: red;">登録に失敗しました。入力内容をご確認ください。</p>
        <% } %>

        <form action="RegisterServlet" method="post">
            <div class="input-box">
                <label for="username">ユーザー名:</label>
                <input type="text" id="username" name="username" required>
            </div>
            
            <div class="input-box">
                <label for="password">パスワード:</label>
                <input type="password" id="password" name="password" required>
            </div>
            
            <div class="input-box">
                <label for="email">メールアドレス:</label>
                <input type="email" id="email" name="email">
            </div>
            
            <div class="input-box">
                <label for="address">住所:</label>
                <input type="text" id="address" name="address">
            </div>
            
            <div class="btn-box">
                <button type="submit">登録</button>
            </div>
        </form>

        <!-- "すでにアカウントをお持ちですか" 用白色加粗 -->
        <p class="message">すでにアカウントをお持ちですか？<a href="login.jsp">ログインはこちら</a></p>
    </div>
</body>
</html>
