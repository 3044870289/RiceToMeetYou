<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>ドローンプランの選択</title>
    <style>
        .detail-popup {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 300px;
            padding: 20px;
            background-color: white;
            border: 1px solid #ccc;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            z-index: 1000;
        }

        .detail-popup.active {
             display: block !important;
        }

        .modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 999;
        }

        .modal-overlay.active {
            display: block;
        }

        .card-container {
            display: flex;
            gap: 20px;
            justify-content: center;
            margin-top: 50px;
        }

        .card {
            border: 1px solid #ccc;
            border-radius: 10px;
            width: 250px;
            padding: 20px;
            background: #fff;
            text-align: center;
        }

        .card h2 {
            color: #4CAF50;
            margin-bottom: 10px;
        }

        .card button {
            background-color: #4CAF50;
            color: #fff;
            border: none;
            padding: 10px;
            border-radius: 5px;
            cursor: pointer;
        }

        .card button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <div class="card-container">
        <!-- Aプラン -->
        <div class="card">
            <h2>Aプラン</h2>
            <p>￥880万</p>
            <p>予想収穫量: 米俵 約32個</p>
            <button type="button" onclick="showDetail('A')">詳細</button>
        </div>

        <!-- Bプラン -->
        <div class="card">
            <h2>Bプラン</h2>
            <p>￥15400000</p>
            <p>収穫量: 米俵 約73個</p>
            <button type="button" onclick="showDetail('B')">詳細</button>
        </div>

        <!-- Cプラン -->
        <div class="card">
            <h2>Cプラン</h2>
            <p>￥19800000</p>
            <p>収穫量：米俵 約110個</p>
            <button type="button" onclick="showDetail('C')">詳細</button>
        </div>
    </div>

    <!-- 遮罩层 -->
    <div class="modal-overlay" onclick="closeAllPopups()"></div>

    <!-- Aプラン弹窗 -->
    <div id="popup-A" class="detail-popup">
        <h2>Aプラン詳細</h2>
        <p>ドローン1機</p>
        <p>お米1種まで選択可能</p>
        <p>4000円/5kg</p>
        <button onclick="hideDetail('A')">閉じる</button>
    </div>

    <!-- Bプラン弹窗 -->
    <div id="popup-B" class="detail-popup">
        <h2>Bプラン詳細</h2>
        <p>ドローン2機</p>
        <p>お米2種まで選択可能</p>
        <p>3500円/5kg</p>
        <button onclick="hideDetail('B')">閉じる</button>
    </div>

    <!-- Cプラン弹窗 -->
    <div id="popup-C" class="detail-popup">
        <h2>Cプラン詳細</h2>
        <p>ドローン3機</p>
        <p>お米3種まで選択可能</p>
        <p>3000円/5kg</p>
        <button onclick="hideDetail('C')">閉じる</button>
    </div>

    <script>
        function showDetail(planID) {
            const popup = document.getElementById("popup-" + planID);
            if (popup) {
                popup.classList.add("active");
                document.querySelector(".modal-overlay").classList.add("active");
            }
        }

        function hideDetail(planID) {
            const popup = document.getElementById("popup-" + planID);
            if (popup) {
                popup.classList.remove("active");
                document.querySelector(".modal-overlay").classList.remove("active");
            }
        }

        function closeAllPopups() {
            document.querySelectorAll('.detail-popup.active').forEach(popup => {
                popup.classList.remove('active');
            });
            document.querySelector(".modal-overlay").classList.remove('active');
        }
    </script>
</body>
</html>
