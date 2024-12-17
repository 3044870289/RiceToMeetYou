<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.sql.*, dao.DBConnection" %>


<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8"> <!-- 잘못된 부분 수정 -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Main Page</title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>

    <!-- Main Section -->
    <div class="main-section">
        <!-- Right top icon buttons -->
<div class="icon-buttons">
    <div class="icon" onclick="location.href='../login.jsp';">👤</div>
    <div class="icon" onclick="location.href='otherPage.jsp';">⋮</div>
</div>


        <!-- Left bottom fixed buttons -->
        <div class="floating-buttons">
            <button class="button">PLANS</button>
            <button class="button">PURCHASE</button>
        </div>
    </div>

    <!-- slideshow -->
    <div class="horizontal-slideshow">
        <div class="slide-container">
            <div class="slide"><img src="nishi1.jpg" alt="Image 1"></div>
            <div class="slide"><img src="nishi2.jpg" alt="Image 2"></div>
            <div class="slide"><img src="nishi1.jpg" alt="Image 3"></div>
            <div class="slide"><img src="nishi2.jpg" alt="Image 4"></div>
            <div class="slide"><img src="nishi1.jpg" alt="Image 5"></div>
        </div>
    </div>

    <!-- 西川町紹介-->
    <div class="slide-description-section">
        <h1>西川町</h1>
        <p>出羽三山の月山と朝日連峰の朝日岳が町の南端と北端に位置する。町の東西に伸びる交通路は、県庁所在地のある内陸部の村山地方と、日本海に面した庄内地方を結ぶ短絡経路になっている。国道112号および山形自動車道が通り、東部で寒河江市と接続する。
        町のほぼ中央部にある月山湖は、町を横断する寒河江川につくられた寒河江ダムによるダム湖で、村山地方を潤す水源の1つであり、100mを越える高さまで水を噴き出す巨大な噴水「月山湖大噴水」が観光名所にもなっている。
        国土庁（当時）「水の郷百選」認定されている。また、名水百選「月山山麓湧水群」の選定も受けており、1983年（昭和58年）から「月山自然水」が販売されている。湧水と風土を生かした日本酒、ワイン、ビールの醸造元があり、これら3種類の醸造元がある自治体は山形県で唯一である。
        月山湖ではカヌーの全国大会も開かれているほか、豪雪地帯であるため7月まで夏スキーも行われている。
        山：月山、朝日岳
        河川：寒河江川
        湖沼：月山湖</p>
    </div>

    <!-- Color Section with 3 colored backgrounds -->
<div class="color-section">
    <div class="color-item color1">
        <img src="rice-image.png" alt="Rice Image 1">
        <div class="description">「つや姫」は「コシヒカリ」
        に比較し粒の大きさのバラツキが小さく、
        玄米の大きさ（粒厚）2.0mm以上の割合が
        「コシヒカリ」と比較し5％程度多く、
        粒ぞろいが良好です。</div> <!-- Description added here -->
    </div>
    <div class="color-item color2">
        <img src="rice-image.png" alt="Rice Image 2">
        <div class="description">This is Rice Image 2 description.</div> <!-- Description added here -->
    </div>
    <div class="color-item color3">
        <img src="rice-image.png" alt="Rice Image 3">
        <div class="description">This is Rice Image 3 description.</div> <!-- Description added here -->
    </div>
</div>


    <!-- Floating Field Section (Common Background) -->
    <div class="floating-field common-background">
        <div class="field-image"></div>
    </div>

    <script>
        let currentIndex = 0; // Start index
        const slidesToShow = 2; // Number of slides visible at a time
        
        function startSlideshow() {
            const slideContainer = document.querySelector('.slide-container');
            const totalSlides = document.querySelectorAll('.slide').length;
        
            // Automatically slide every 3 seconds
            setInterval(() => {
                currentIndex += slidesToShow; // Move by two slides at a time
                if (currentIndex >= totalSlides) {
                    currentIndex = 0; // Reset to start
                }
        
                // Calculate and apply the new translation
                const offset = -(currentIndex * (100 / slidesToShow));
                slideContainer.style.transform = `translateX(${offset}%)`;
            }, 3000); // 3 seconds interval
        }
        
        // Initialize the slideshow on page load
        document.addEventListener('DOMContentLoaded', startSlideshow);
    </script>

</body>
</html>
