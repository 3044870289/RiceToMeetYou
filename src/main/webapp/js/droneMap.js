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

// 单个无人机动画函数
function animateMarker(marker, targetLat, targetLng, duration, onComplete) {
    const startPos = marker.getPosition();
    const startLat = startPos.lat();
    const startLng = startPos.lng();

    const deltaLat = targetLat - startLat;
    const deltaLng = targetLng - startLng;

    const steps = 120; // 总帧数
    const interval = duration / steps; // 每帧间隔时间
    let step = 0;

    function easeInOutQuad(t) {
        return t < 0.5 ? 2 * t * t : -1 + (4 - 2 * t) * t;
    }

    function move() {
        step++;
        const progress = step / steps;
        const easedProgress = easeInOutQuad(progress); // 使用缓动函数平滑动画

        const currentLat = startLat + deltaLat * easedProgress;
        const currentLng = startLng + deltaLng * easedProgress;

        marker.setPosition(new google.maps.LatLng(currentLat, currentLng));

        if (step < steps) {
            setTimeout(move, interval); // 下一帧
        } else if (onComplete) {
            onComplete(); // 动画完成后的回调
        }
    }

    move(); // 开始动画
}

// 批量移动多个无人机
function animateMultipleMarkers(markers, targets, duration) {
    if (markers.length !== targets.length) {
        console.error("Markers and targets arrays must have the same length!");
        return;
    }

    markers.forEach((marker, index) => {
        const target = targets[index];
        if (target && target.lat !== undefined && target.lng !== undefined) {
            animateMarker(marker, target.lat, target.lng, duration, () => {
                console.log(`Drone ${index + 1} finished moving.`);
            });
        } else {
            console.error(`Invalid target for marker ${index + 1}:`, target);
        }
    });
}

// 测试批量移动
function testMoveMultipleDrones() {
    const targets = [
        { lat: 35.6895, lng: 139.692 }, // 新位置1
        { lat: 35.6897, lng: 139.700 }, // 新位置2
        { lat: 35.6900, lng: 139.710 }  // 新位置3
    ];

    animateMultipleMarkers(markers.slice(0, 3), targets, 2000); // 测试移动前3个无人机
}

function initiateMoveDrone(droneID) {
    selectedDroneID = droneID;
    alert("マップ上で新しい位置をクリックしてください。");

    map.addListener("click", event => {
        if (!selectedDroneID) return;

        const newLat = event.latLng.lat();
        const newLng = event.latLng.lng();

        console.log(`Moving drone ${selectedDroneID} to new location: ${newLat}, ${newLng}`);

        // 单个无人机移动
        const marker = markers.find(m => m.getTitle() === `ドローン ${droneID}`);
        if (marker) {
            animateMarker(marker, newLat, newLng, 2000, () => {
                console.log(`Drone ${droneID} animation completed.`);
            });
        }

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
                if (data.status === "success") {
                    alert("ドローンの位置が更新されました！");
                } else {
                    alert(`位置更新に失敗しました：${data.message}`);
                }
            })
            .catch(error => {
                console.error("Error updating drone location:", error);
                alert("エラーが発生しました。");
            });

        selectedDroneID = null;
    });
}
