<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
    .menu-container {
        display: flex;
        justify-content: space-around;
        align-items: center;
        background-color: #e8f5e9; /* 淡绿色背景 */
        padding: 10px 0;
        position: sticky;
        top: 0;
        z-index: 1000;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    }

    .menu-container a {
        text-decoration: none;
        color: #388e3c; /* 深绿色文字 */
        font-size: 16px;
        padding: 10px 20px;
        transition: background-color 0.3s, color 0.3s;
    }

    .menu-container a:hover {
        background-color: #c8e6c9; /* 更浅的绿色 */
        color: #2e7d32; /* 深一点的绿色文字 */
        border-radius: 5px;
    }
</style>

<div class="menu-container">
    <a href="index.jsp">ホーム</a>
    <a href="shop.jsp">ショップ</a>
    <a href="cart.jsp">カート</a>
    <a href="choosePlan.jsp">プラン選択</a>
    <a href="important.jsp">注意事項</a>
</div>
