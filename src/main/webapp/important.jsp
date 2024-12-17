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
            line-height: 1.8;
            margin: 10px 0;
        }
    </style>
</head>
<body>
<jsp:include page="menu.jsp" />

    <h1>注意事項</h1>

    <div class="container">
        <!-- 購入方法 -->
        <div class="box">
            <h2>1. 購入方法</h2>
            <p>購入する商品をお選びいただき、「カートに入れる」をクリックしてください。</p>
            <p>その後、カートページで購入内容や数量をご確認いただけます。</p>
            <p>必要な情報（お名前、配送先住所、連絡先など）をご入力いただき、注文を確定してください。</p>
            <p>お支払いはクレジットカード、銀行振込、代金引換がご利用いただけます。</p>
        </div>

        <!-- 配送情報 -->
        <div class="box">
            <h2>2. 配送情報</h2>
            <p>配送は通常、ご注文確定後3〜5営業日以内に発送されます。</p>
            <p>配送料は配送地域および重量によって異なります。</p>
            <p>発送後、追跡番号がメールで送付されますので、配送状況をご確認ください。</p>
            <p>離島や一部地域では配送に時間がかかる場合がございます。</p>
        </div>

        <!-- 返品情報 -->
        <div class="box">
            <h2>3. 返品について</h2>
            <p>商品の返品・交換は、商品到着後7日以内にご連絡ください。</p>
            <p>返品は未使用・未開封の状態に限り受け付けております。</p>
            <p>お客様のご都合による返品の場合、送料はお客様のご負担となります。</p>
            <p>不良品や誤配送の場合は、送料当社負担にて交換対応をさせていただきます。</p>
            <p>返品・交換をご希望の場合は、カスタマーサポートまでお問い合わせください。</p>
        </div>
    </div>
</body>
</html>
