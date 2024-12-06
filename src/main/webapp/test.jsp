<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>CSS 样式测试</title>
    <link rel="stylesheet" href="css/jsp.css">
</head>
<body>
    <div class="container">
        <div class="module">
            <h1>模块 1</h1>
            <p>测试样式内容。</p>
            <button>测试按钮</button>
        </div>
        <div class="module">
            <h1>模块 2</h1>
            <p>点击按钮返回顶部：</p>
            <button id="backToTop">↑</button>
        </div>
    </div>
    <footer>
        <p>页脚测试</p>
    </footer>
    <div style="height: 2000px;">滚动测试内容</div>
    <script>
        const backToTopButton = document.getElementById("backToTop");
        window.addEventListener("scroll", () => {
            if (window.scrollY > 200) {
                backToTopButton.style.display = "flex";
            } else {
                backToTopButton.style.display = "none";
            }
        });
        backToTopButton.addEventListener("click", () => {
            window.scrollTo({ top: 0, behavior: "smooth" });
        });
    </script>
</body>
</html>
