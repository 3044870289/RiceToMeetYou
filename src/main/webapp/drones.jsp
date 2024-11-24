<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>ドローンリアルタイムマップ</title>
    <style>
        #map { height: 500px; width: 100%; }
        body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #f9f9f9; }
        h1 { text-align: center; color: #333; }
        .buttons {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-bottom: 20px;
        }
        .buttons button {
            padding: 10px 15px;
            font-size: 16px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .btn-global {
            background-color: #4CAF50;
            color: white;
        }
        .btn-personal {
            background-color: #007BFF;
            color: white;
        }
        .btn-global:hover, .btn-personal:hover {
            opacity: 0.8;
        }
    </style>
</head>
<body>
    <jsp:include page="menu.jsp" />
    <h1>ドローンリアルタイムマップ</h1>

    <div class="buttons">
        <button class="btn-global" onclick="toggleView(true)">全体表示</button>
        <button class="btn-personal" onclick="toggleView(false)">自分のドローンのみ</button>
    </div>

    <div id="map"></div>

    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAJCDwqKJFUaPhL2xz76qOOSKDCgBKj7OM&callback=initMap" async defer></script>
    <script>
        let map;
        let globalView = true; // 初期显示为全体

        function initMap() {
            map = new google.maps.Map(document.getElementById("map"), {
                center: { lat: 35.6895, lng: 139.6917 }, // 默认东京中心点
                zoom: 5,
            });

            loadDrones();
        }

        function toggleView(view) {
            globalView = view;
            loadDrones();
        }

        function loadDrones() {
            const url = `/RiceToMeetYou/getDroneData?globalView=${globalView}`;
            fetch(url)
                .then((response) => response.json())
                .then((drones) => {
                    const bounds = new google.maps.LatLngBounds();
                    map.clearOverlays = function () {
                        for (let i = 0; i < this.overlays.length; i++) {
                            this.overlays[i].setMap(null);
                        }
                        this.overlays = [];
                    };
                    map.clearOverlays();

                    drones.forEach((drone) => {
                        const position = { lat: drone.latitude, lng: drone.longitude };
                        const marker = new google.maps.Marker({
                            position,
                            map,
                            title: `Drone ID: ${drone.droneID}`,
                        });

                        const infoWindow = new google.maps.InfoWindow({
                            content: `
                                <div>
                                    <h3>Drone ID: ${drone.droneID}</h3>
                                    <p>Altitude: ${drone.altitude}m</p>
                                    <p>Speed: ${drone.speed}km/h</p>
                                    <p>Battery: ${drone.batteryLevel}%</p>
                                    <p>Plan: ${drone.planName}</p>
                                </div>
                            `,
                        });

                        marker.addListener("click", () => {
                            infoWindow.open(map, marker);
                        });

                        bounds.extend(position);
                        map.setCenter(position);
                    });

                    if (!drones.length) {
                        alert("選択された条件でドローンは見つかりませんでした。");
                    } else {
                        map.fitBounds(bounds);
                    }
                })
                .catch((error) => console.error("Error loading drones:", error));
        }
    </script>
</body>
</html>
