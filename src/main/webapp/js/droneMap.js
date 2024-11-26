let map;
let markers = []; // 初始化标记数组
let selectedDroneID = null; // 当前需要移动的无人机ID

function initMap() {
    console.log("Initializing map...");
    map = new google.maps.Map(document.getElementById("map"), {
        zoom: 5,
        center: { lat: 35.6895, lng: 139.6917 }, // 东京
    });
    console.log("Map initialized.");

    // 加载所有无人机
    loadDrones(false);

    // 按钮事件监听
    document.getElementById("showOwnDrones").addEventListener("click", () => {
        console.log("自分のドローンボタンが押された！");
        loadDrones(true);
    });

    document.getElementById("showAllDrones").addEventListener("click", () => {
        console.log("すべてのドローンボタンが押された！");
        loadDrones(false);
    });

    document.getElementById("moveMultipleDrones").addEventListener("click", () => {
        console.log("複数ドローン移動ボタンが押された！");
        testMoveMultipleDrones(); // 批量移动无人机
    });
}

function loadDrones(own) {
    console.log(`Loading drones with own = ${own}`);
    clearMarkers();

    fetch(`/RiceToMeetYou/getDroneData?own=${own}`)
        .then(response => response.json())
        .then(data => {
            console.log("Received drone data:", data);
            data.forEach(drone => {
                const marker = new google.maps.Marker({
                    position: { lat: drone.latitude, lng: drone.longitude },
                    map: map,
                    title: `ドローン ${drone.droneID}`,
                    icon: '/RiceToMeetYou/images/resized_drone1.png', // 确保路径正确
                });

                const infoWindowContent = `
                    <h3>${drone.planName} (ドローンID: ${drone.droneID})</h3>
                    <p>高度: ${drone.altitude} メートル</p>
                    <p>速度: ${drone.speed} km/h</p>
                    <p>バッテリー残量: ${drone.batteryLevel}%</p>
                    <p>契約期間: ${drone.contractDuration}</p>
                    <p>収穫量: ${drone.harvestAmount} kg</p>
                    <p>価格: ¥${drone.price}</p>
                    <button onclick="initiateMoveDrone(${drone.droneID})">移動</button>
                    
                `;

                const infoWindow = new google.maps.InfoWindow({
                    content: infoWindowContent,
                });
                marker.addListener("click", () => {
                    infoWindow.open(map, marker);
                });

                markers.push(marker);
            });
        })
        .catch(error => {
            console.error("Error loading drones:", error);
        });
}

function clearMarkers() {
    console.log("Clearing existing markers...");
    markers.forEach(marker => marker.setMap(null));
    markers = [];
}

function initiateMoveDrone(droneID) {
    selectedDroneID = droneID;
    alert("マップ上で新しい位置をクリックしてください。");

    // 添加地图点击事件监听
    map.addListener("click", handleMapClick);
}

function handleMapClick(event) {
    if (!selectedDroneID) return;

    const newLat = event.latLng.lat();
    const newLng = event.latLng.lng();

    console.log(`Moving drone ${selectedDroneID} to new location: ${newLat}, ${newLng}`);

    fetch(`/RiceToMeetYou/updateDroneLocation`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
            droneID: selectedDroneID,
            latitude: newLat,
            longitude: newLng,
        }),
    })
        .then(response => response.json())
        .then(data => {
            console.log("Server response for drone move:", data);
            if (data.status === "success") {
                alert("ドローンの位置が更新されました！");
                loadDrones(false); // 刷新地图
            } else {
                alert(`位置更新に失敗しました：${data.message}`);
            }
        })
        .catch(error => {
            console.error("Error updating drone location:", error);
            alert("エラーが発生しました。");
        })
        .finally(() => {
            // 移除点击事件监听
            google.maps.event.clearListeners(map, "click");
            selectedDroneID = null;
        });
}

// 批量移动无人机动画
function animateMultipleMarkers(markers, targets, duration) {
    if (markers.length !== targets.length) {
        console.error("Markers and targets length mismatch!");
        return;
    }

    markers.forEach((marker, index) => {
        const target = targets[index];
        if (!target) return;

        const startPos = marker.getPosition();
        const endPos = new google.maps.LatLng(target.lat, target.lng);

        const deltaLat = (endPos.lat() - startPos.lat()) / (duration / 20);
        const deltaLng = (endPos.lng() - startPos.lng()) / (duration / 20);

        let step = 0;
        const steps = duration / 20;

        function move() {
            step++;
            const lat = startPos.lat() + deltaLat * step;
            const lng = startPos.lng() + deltaLng * step;
            marker.setPosition(new google.maps.LatLng(lat, lng));

            if (step < steps) {
                requestAnimationFrame(move);
            }
        }
        move();
    });
}

// 测试批量移动无人机
function testMoveMultipleDrones() {
    const targets = [
        { lat: 35.6895, lng: 139.692 }, // 第1个无人机目标位置
        { lat: 35.6897, lng: 139.700 }, // 第2个无人机目标位置
        { lat: 35.6900, lng: 139.710 }  // 第3个无人机目标位置
    ];

    animateMultipleMarkers(markers.slice(0, 3), targets, 2000); // 移动前3个无人机
}
