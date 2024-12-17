<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>简单弹窗测试</title>
    <style>
        /* 主体样式 */
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }

        button {
            padding: 10px 20px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        button:hover {
            background-color: #45a049;
        }

        /* 弹窗样式 */
        .popup {
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
            text-align: center;
        }

        .popup.active {
            display: block;
        }

        /* 背景遮罩样式 */
        .overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 999;
        }

        .overlay.active {
            display: block;
        }
    </style>
</head>
<body>
    <h1>简单弹窗测试</h1>

    <!-- 测试按钮 -->
    <button onclick="showPopup()">打开弹窗</button>

    <!-- 弹窗 -->
    <div id="popup" class="popup">
        <h2>这是一个弹窗</h2>
        <p>测试弹窗的功能</p>
        <button onclick="closePopup()">关闭</button>
    </div>

    <!-- 背景遮罩 -->
    <div id="overlay" class="overlay" onclick="closePopup()"></div>

    <script>
        // 显示弹窗
        function showPopup() {
            document.getElementById("popup").classList.add("active");
            document.getElementById("overlay").classList.add("active");
        }

        // 关闭弹窗
        function closePopup() {
            document.getElementById("popup").classList.remove("active");
            document.getElementById("overlay").classList.remove("active");
        }
    </script>
</body>
</html>
