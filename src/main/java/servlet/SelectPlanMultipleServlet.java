package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.DBConnection;

@WebServlet("/SelectPlanMultipleServlet")
public class SelectPlanMultipleServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userIDStr = request.getParameter("userID");
        String planIDStr = request.getParameter("planID");
        String countStr = request.getParameter("count");

        try (Connection conn = DBConnection.getConnection()) {
            int userID = Integer.parseInt(userIDStr);
            int planID = Integer.parseInt(planIDStr);
            int count = Integer.parseInt(countStr);

            // 插入选择记录
            String insertSelectionSQL = "INSERT INTO DronePlanSelection (UserID, planID, Count, SelectionTime) VALUES (?, ?, ?, NOW())";
            try (PreparedStatement stmt = conn.prepareStatement(insertSelectionSQL)) {
                stmt.setInt(1, userID);
                stmt.setInt(2, planID);
                stmt.setInt(3, count);
                stmt.executeUpdate();
            }

            // 随机生成无人机坐标
            for (int i = 0; i < count; i++) {
                double latitude = 35.0 + Math.random(); // 模拟随机纬度
                double longitude = 139.0 + Math.random(); // 模拟随机经度
                int altitude = (int) (100 + Math.random() * 200); // 高度随机值
                int speed = (int) (30 + Math.random() * 50); // 速度随机值
                int batteryLevel = (int) (50 + Math.random() * 50); // 电量随机值

                String insertDroneSQL = "INSERT INTO DroneStatus (latitude, longitude, altitude, speed, batteryLevel, planID, userID) VALUES (?, ?, ?, ?, ?, ?, ?)";
                try (PreparedStatement droneStmt = conn.prepareStatement(insertDroneSQL)) {
                    droneStmt.setDouble(1, latitude);
                    droneStmt.setDouble(2, longitude);
                    droneStmt.setInt(3, altitude);
                    droneStmt.setInt(4, speed);
                    droneStmt.setInt(5, batteryLevel);
                    droneStmt.setInt(6, planID);
                    droneStmt.setInt(7, userID);
                    droneStmt.executeUpdate();
                }
            }

            response.sendRedirect("choosePlan.jsp?success=true");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("choosePlan.jsp?error=true");
        }
    }
}
