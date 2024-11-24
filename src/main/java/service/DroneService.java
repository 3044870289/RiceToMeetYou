package service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import dao.DBConnection;
import model.Drone; // 引用 Drone 模型类

public class DroneService {

    /**
     * 获取无人机列表
     * @param userID 用户ID（如果 globalView 为 true 则传 null）
     * @param globalView 是否查看全局无人机
     * @return 无人机列表
     * @throws Exception 数据库异常
     */
    public List<Drone> getDrones(Integer userID, boolean globalView) throws Exception {
        List<Drone> drones = new ArrayList<>();
        String sql;

        if (globalView) {
            sql = "SELECT * FROM DroneStatus";
        } else {
            sql = "SELECT * FROM DroneStatus WHERE userID = ?";
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            if (!globalView && userID != null) {
                stmt.setInt(1, userID);
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Drone drone = new Drone(
                        rs.getInt("droneID"),
                        rs.getDouble("latitude"),
                        rs.getDouble("longitude"),
                        rs.getInt("altitude"),
                        rs.getInt("speed"),
                        rs.getInt("batteryLevel"),
                        rs.getInt("planID"),
                        rs.getInt("userID")
                    );
                    drones.add(drone);
                }
            }
        }

        return drones;
    }
}
