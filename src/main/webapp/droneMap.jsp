<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>ドローンリアルタイムマップ</title>
    <!-- 加载 CSS -->
    <style>
        #map { height: 500px; width: 100%; }
        body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #f9f9f9; }
        h1 { text-align: center; color: #333; }
    </style>
</head>

<body>
        <jsp:include page="menu.jsp" />
    <h1>ドローンリアルタイムマップ</h1>
    <div id="map"></div>
    <!-- 加载 droneMap.js -->
    <script src="/RiceToMeetYou/js/droneMap.js"></script>
    <!-- 异步加载 Google Maps API -->
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAJCDwqKJFUaPhL2xz76qOOSKDCgBKj7OM&callback=initMap" async defer></script>
    
</body>
</html>