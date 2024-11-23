<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>ご購入ありがとうございました</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f9f9f9;
        }

        .container {
            text-align: center;
            padding: 50px;
            background-color: white;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            max-width: 600px;
            margin: 100px auto;
            border-radius: 10px;
        }

        h1 {
            color: #4CAF50;
            font-size: 24px;
        }

        p {
            font-size: 18px;
            color: #333;
            margin-bottom: 30px;
        }

        button {
            padding: 10px 20px;
            font-size: 16px;
            color: white;
            background-color: #4CAF50;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        button:hover {
            background-color: #45a049;
        }

        .footer {
            margin-top: 20px;
            font-size: 14px;
            color: #777;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>ご購入ありがとうございました！</h1>
        <p>ご注文は正常に処理されました。</p>

        <button onclick="location.href='index.jsp'">ホームページに戻る</button>

        <div class="footer">
            <p>またのご利用をお待ちしております。</p>
        </div>
    </div>
</body>
</html>
