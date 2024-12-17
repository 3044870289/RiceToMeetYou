// 初始化地图和标记数组
let map;
let markers = []; // 存储所有无人机的标记
let selectedDroneID = null; // 当前需要移动的无人机 ID
let stationMarkers = []; // 存储所有站点的标记
let stationsVisible = false; // 记录当前站点是否显示

function initMap() {
    console.log("Initializing map...");
    map = new google.maps.Map(document.getElementById("map"), {
        zoom: 8,
        center: { lat: 35.6895, lng: 139.6917 }, // 东京
    });
    console.log("Map initialized.");

    // 加载所有无人机
    loadDrones(true); // 只显示自己的无人机
    //loadStations();   // 显示所有站点
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

                // 绑定唯一的 droneID
                marker.droneID = drone.droneID;

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
                marker.addListener("click", () => infoWindow.open(map, marker));

                markers.push(marker); // 将标记存入全局数组
            });

            console.log("Markers loaded:", markers);
        })
        .catch(error => {
            console.error("Error loading drones:", error);
        });
}

function clearMarkers() {
    console.log("Clearing existing markers...");
    markers.forEach(marker => marker.setMap(null)); // 从地图中移除标记
    markers = []; // 清空标记数组
}

function animateMarker(marker, targetLat, targetLng, duration, onComplete) {
    const startPos = marker.getPosition();
    const startLat = startPos.lat();
    const startLng = startPos.lng();

    const deltaLat = targetLat - startLat;
    const deltaLng = targetLng - startLng;

    const steps = 120; // 动画帧数
    const interval = duration / steps; // 每帧时间间隔
    let step = 0;

    function move() {
        step++;
        const progress = step / steps;

        const currentLat = startLat + deltaLat * progress;
        const currentLng = startLng + deltaLng * progress;

        marker.setPosition(new google.maps.LatLng(currentLat, currentLng));

        if (step < steps) {
            setTimeout(move, interval);
        } else if (onComplete) {
            onComplete();
        }
    }

    move();
}

function initiateMoveDrone(droneID) {
    console.log(`Initiating move for droneID: ${droneID}`);
    selectedDroneID = droneID;
    alert("マップ上で新しい位置をクリックしてください。");

    // 清除之前的 click 监听器
    google.maps.event.clearListeners(map, "click");

    map.addListener("click", event => {
        if (!selectedDroneID) {
            console.error("No selected droneID. Ignoring click.");
            return;
        }

        const newLat = event.latLng.lat();
        const newLng = event.latLng.lng();

        console.log(`Moving drone ${selectedDroneID} to new location: (${newLat}, ${newLng})`);

        const marker = markers.find(m => m.droneID === selectedDroneID);
        if (!marker) {
            console.error(`Marker for droneID ${selectedDroneID} not found.`);
            return;
        }

        animateMarker(marker, newLat, newLng, 2000, () => {
            console.log(`Drone ${selectedDroneID} animation completed.`);
        });

        fetch('/RiceToMeetYou/updateDroneLocation', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
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
                    console.error(`位置更新に失敗: ${data.message}`);
                }
            })
            .catch(error => console.error("Error updating drone location:", error));

        google.maps.event.clearListeners(map, "click");
        selectedDroneID = null;
    });
}



//添加无人机站点
document.getElementById("addStationButton").addEventListener("click", () => {
    alert("マップ上でステーションを追加する位置をクリックしてください。");

    google.maps.event.clearListeners(map, "click"); // 清除其他点击监听器

    map.addListener("click", event => {
        const latitude = event.latLng.lat();
        const longitude = event.latLng.lng();

        console.log(`Adding station at: (${latitude}, ${longitude})`);

        fetch('/RiceToMeetYou/addStation', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                latitude: latitude,
                longitude: longitude
            })
        })
            .then(response => response.json())
            .then(data => {
                if (data.status === "success") {
                    alert("ステーションが追加されました！");
                    loadStations(); // 重新加载站点，自动刷新
                } else {
                    alert(`エラー: ${data.message}`);
                }
            })
            .catch(error => {
                console.error("Error adding station:", error);
                alert("ステーションの追加に失敗しました。");
            });

        google.maps.event.clearListeners(map, "click"); // 清除监听器
    });
});
//显示无人机站点逻辑
document.getElementById("toggleStations").addEventListener("click", () => {
    if (!stationsVisible) {
        loadStations(); // 加载并显示站点
        document.getElementById("toggleStations").innerText = "ステーションを非表示"; // 修改按钮文本
    } else {
        clearStationMarkers(); // 隐藏站点
        document.getElementById("toggleStations").innerText = "ステーションを表示"; // 修改按钮文本
    }
    stationsVisible = !stationsVisible; // 切换状态
});
function loadStations() {
    console.log("Loading stations...");
    clearStationMarkers(); // 先清除所有站点标记

    fetch('/RiceToMeetYou/getStations')
        .then(response => response.json())
        .then(data => {
            console.log("Received stations:", data);

            data.forEach(station => {
                const marker = new google.maps.Marker({
                    position: { lat: station.latitude, lng: station.longitude },
                    map: map,
                    title: `ステーションID: ${station.stationID}`,
                    icon: {
                        url: '/RiceToMeetYou/images/station1.png',
                        scaledSize: new google.maps.Size(40, 40)
                    }
                });

                // 添加信息窗口，包含删除按钮
                const infoWindowContent = `
                    <h3>ステーションID: ${station.stationID}</h3>
                    <p>緯度: ${station.latitude}</p>
                    <p>経度: ${station.longitude}</p>
                    <button onclick="deleteStation(${station.stationID})">削除</button>
                `;
                const infoWindow = new google.maps.InfoWindow({ content: infoWindowContent });
                marker.addListener("click", () => infoWindow.open(map, marker));

                stationMarkers.push(marker); // 保存站点标记到数组
            });
            console.log("Station markers loaded:", stationMarkers);
        })
        .catch(error => {
            console.error("Error loading stations:", error);
            alert("ステーションの読み込みに失敗しました。");
        });
}


function clearStationMarkers() {
    console.log("Clearing station markers...");
    // 遍历所有站点标记，将其从地图上移除
    stationMarkers.forEach(marker => {
        if (marker) {
            marker.setMap(null);
        }
    });
    stationMarkers.length = 0; // 清空数组，确保没有引用残留
    console.log("Station markers cleared.");
}

function loadStations() {
    console.log("Loading stations...");
    fetch('/RiceToMeetYou/getStations') // 请求后端Servlet
        .then(response => response.json()) // 解析JSON数据
        .then(data => {
            console.log("Received stations:", data);

            data.forEach(station => {
                const marker = new google.maps.Marker({
                    position: { lat: station.latitude, lng: station.longitude },
                    map: map,
                    title: `ステーションID: ${station.stationID}`,
                    icon: {
                        url: '/RiceToMeetYou/images/station1.png',
                        scaledSize: new google.maps.Size(40, 40) // 图标大小
                    }
                });

                // 添加信息窗口，包含删除按钮
                const infoWindowContent = `
                    <h3>ステーションID: ${station.stationID}</h3>
                    <p>緯度: ${station.latitude}</p>
                    <p>経度: ${station.longitude}</p>
                    <button onclick="deleteStation(${station.stationID})">削除</button>
                `;
                const infoWindow = new google.maps.InfoWindow({
                    content: infoWindowContent
                });

                marker.addListener("click", () => infoWindow.open(map, marker));
            });
        })
        .catch(error => {
            console.error("Error loading stations:", error);
            alert("ステーションの読み込みに失敗しました。");
        });
}


function deleteStation(stationID) {
    if (!confirm("このステーションを削除しますか？")) {
        return;
    }

    console.log(`Deleting station with ID: ${stationID}`);

    fetch('/RiceToMeetYou/deleteStation', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ stationID: stationID }) // 传递 stationID
    })
    .then(response => response.json())
    .then(data => {
        if (data.status === "success") {
            alert("ステーションが削除されました！");
            location.reload(); // 刷新页面
        } else {
            alert(`削除に失敗しました: ${data.message}`);
        }
    })
    .catch(error => {
        console.error("Error deleting station:", error);
        alert("ステーションの削除に失敗しました。");
    });
}


