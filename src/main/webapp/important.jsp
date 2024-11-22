<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>注意事項</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f9f9f9;
        }

        h1 {
            text-align: center;
            margin: 20px 0;
            color: #333;
        }

        .container {
            max-width: 900px;
            margin: 0 auto;
            padding: 20px;
        }

        .box {
            background-color: #fff;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
            padding: 20px;
        }

        .box h2 {
            font-size: 18px;
            color: #4CAF50;
            margin-bottom: 15px;
        }

        .box p {
            font-size: 14px;
            color: #555;
            line-height: 1.6;
            margin: 5px 0;
        }
    </style>
</head>
<jsp:include page="menu.jsp" />
<body>
    <h1>注意事項</h1>

    <div class="container">
        <!-- 購入方法 -->
        <div class="box">
            <h2>1. 購入方法</h2>
            <p>商品を選択してください。</p>
            <p>「カートに入れる」をクリックし、購入内容を確認してください。</p>
            <p>...</p>
        </div>

        <!-- 配送情報 -->
        <div class="box">
            <h2>2. 配送情報</h2>
            <p>配送料金は、発送元と配送先により異なります。</p>
            <p>詳細は商品ページをご確認ください。</p>
            <p>...</p>
        </div>

        <!-- 返品情報 -->
        <div class="box">
            <h2>3. 返品について</h2>
            <p>返品が必要な場合はお問い合わせください。</p>
            <p>...</p>
        </div>
    </div>
</body>
</html>
