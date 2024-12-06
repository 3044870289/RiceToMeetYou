<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>ログイン</title>
    <link rel="stylesheet" href="css/loginstyle.css">
    <link rel="icon" href="path/to/favicon.ico" type="image/x-icon">
    <style>
        /* 动画标题的样式 */
        .header-title {
            font-size: 40px;
            margin-top: -150px; /* 将标题向上移动 */
            font-weight: bold;
            text-align: center;
            color: #ffffff;
            font-family: "Arial", sans-serif;
            text-shadow: 2px 2px 5px rgba(0, 0, 0, 0.6);
            overflow: hidden; /* 为动画做准备 */
            white-space: nowrap;
            width: 0; /* 初始宽度为 0 */
            border-right: 2px solid #ffffff; /* 添加一个光标效果 */
            animation: typing 4s steps(30, end), blink 0.5s step-end infinite; /* 打字机效果 */
            animation-fill-mode: forwards; /* 动画完成后保持最后的状态 */
        }

        /* box 调整 */
        .box {
            margin-top: 50px; /* 避免标题遮挡 box */
            text-align: center; /* 内容居中 */
        }

        /* 打字机动画 */
        @keyframes typing {
            from {
                width: 0; /* 动画从 0 宽度开始 */
            }
            to {
                width: 100%; /* 最终展示完整标题 */
            }
        }

        /* 光标闪烁动画 */
        @keyframes blink {
            from {
                border-color: transparent;
            }
            to {
                border-color: #ffffff;
            }
        }

        .btn-box button {
            width: 120px; /* 设置按钮宽度 */
            height: 40px; /* 设置按钮高度 */
            border: none; /* 去除边框 */
            background: #4CAF50; /* 按钮绿色背景 */
            color: white; /* 按钮文字白色 */
            border-radius: 5px; /* 按钮圆角 */
            cursor: pointer; /* 鼠标样式 */
            transition: background-color 0.3s ease; /* 鼠标悬停效果 */
        }

        .btn-box button:hover {
            background: #45a049; /* 鼠标悬停时更深的绿色 */
        }

        .register-link {
            margin-top: 20px; /* 与按钮之间的间距 */
            font-size: 14px;
        }

        .register-link a {
            color: #4CAF50; /* 绿色超链接 */
            text-decoration: none; /* 去除下划线 */
        }

        .register-link a:hover {
            color: #45a049; /* 鼠标悬停时更深的绿色 */
        }
    </style>
</head>
<body>
    <!-- 动画标题 -->
    <div class="header-title">
        展望未来！随心所欲の高品質農作物を収穫しよう！
    </div>

    <div class="box">
        <h2>ログイン</h2>
        <% 
            // 提示メッセージ的处理
            String success = request.getParameter("success");
            String error = request.getParameter("error");
        %>
        <% if (success != null) { %>
            <p class="message" style="color: green;">登録に成功しました。ログインしてください。</p>
        <% } %>
        <% if (error != null) { %>
            <p class="message" style="color: red;">ユーザー名またはパスワードが間違っています。再試行してください。</p>
        <% } %>
        <form action="LoginServlet" method="post">
            <div class="input-box">
                <label for="username">ユーザー名</label>
                <input type="text" id="username" name="username" required>
            </div>
            <div class="input-box">
                <label for="password">パスワード</label>
                <input type="password" id="password" name="password" required>
            </div>
            <div class="btn-box">
                <button type="submit">ログイン</button>
            </div>
        </form>

        <!-- 添加“没有账号？现在注册”链接 -->
        <p class="register-link">
            アカウントがありませんか？ <a href="register.jsp">今すぐ登録</a>
        </p>
    </div>
</body>
</html>
