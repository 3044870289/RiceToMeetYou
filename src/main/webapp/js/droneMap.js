// droneMap.js 文件
window.initMap = function () {
    const map = new google.maps.Map(document.getElementById("map"), {
        zoom: 5,
        center: { lat: 35.6895, lng: 139.6917 }
    });

    fetch('/RiceToMeetYou/getDroneData')
        .then(response => response.json())
        .then(data => {
            data.forEach(drone => {
                const marker = new google.maps.Marker({
                    position: { lat: drone.latitude, lng: drone.longitude },
                    map: map,
                    title: `ドローン ${drone.droneID}`,
                    icon: '/RiceToMeetYou/images/resized_drone1.png' // 自定义图标
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
            });
        })
        .catch(error => console.error('データ取得エラー:', error));
};
