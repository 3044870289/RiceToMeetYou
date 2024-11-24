let map;
let markers = []; // 初始化标记数组

function initMap() {
    console.log("Initializing map...");
    map = new google.maps.Map(document.getElementById("map"), {
        zoom: 5,
        center: { lat: 35.6895, lng: 139.6917 },
    });
    console.log("Map initialized.");
    loadDrones(false); // 默认加载所有无人机

    // 添加按钮事件监听
    document.getElementById("showOwnDrones").addEventListener("click", () => {
        console.log("自分のドローンボタンが押された！");
        loadDrones(true); // 加载用户自己的无人机
    });

    document.getElementById("showAllDrones").addEventListener("click", () => {
        console.log("すべてのドローンボタンが押された！");
        loadDrones(false); // 加载所有无人机
    });
}

function loadDrones(own) {
    console.log(`Loading drones with own = ${own}`);
    clearMarkers(); // 清空现有标记

    fetch(`/RiceToMeetYou/getDroneData?own=${own}`)
        .then(response => response.json())
        .then(data => {
            console.log(`Received drone data:`, data);
            data.forEach(drone => {
                const marker = new google.maps.Marker({
                    position: { lat: drone.latitude, lng: drone.longitude },
                    map: map,
                    title: `ドローン ${drone.droneID}`,
                    icon: '/RiceToMeetYou/images/resized_drone1.png',
                });

                const infoWindow = new google.maps.InfoWindow({
                    content: `
                        <h3>${drone.planName} (ドローンID: ${drone.droneID})</h3>
                        <p>高度: ${drone.altitude} メートル</p>
                        <p>速度: ${drone.speed} km/h</p>
                        <p>バッテリー残量: ${drone.batteryLevel}%</p>
                        <p>契約期間: ${drone.contractDuration}</p>
                        <p>収穫量: ${drone.harvestAmount} kg</p>
                        <p>価格: ¥${drone.price}</p>
                    `
                });

                marker.addListener("click", () => {
                    infoWindow.open(map, marker);
                });

                markers.push(marker); // 保存标记到数组中
            });
        })
        .catch(error => console.error("データ取得エラー:", error));
}

function clearMarkers() {
    console.log("Clearing existing markers...");
    markers.forEach(marker => marker.setMap(null)); // 从地图上移除标记
    markers = []; // 清空数组
}



