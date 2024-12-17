package servlet;

import utils.GeoUtils;
import dao.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/selectDronePlan")
public class SelectDronePlanServlet extends HttpServlet {

    private static final int DEFAULT_ALTITUDE = 0;
    private static final int DEFAULT_SPEED = 0;
    private static final int DEFAULT_BATTERY_LEVEL = 100;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String planIDStr = request.getParameter("planID");
        String userIDStr = request.getParameter("userID");

        // 输入校验
        if (planIDStr == null || userIDStr == null || !planIDStr.matches("\\d+") || !userIDStr.matches("\\d+")) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Invalid or missing planID or userID\"}");
            return;
        }

        int planID = Integer.parseInt(planIDStr);
        int userID = Integer.parseInt(userIDStr);

        try (Connection conn = DBConnection.getConnection()) {
            // 生成随机位置
        	// double latitude = GeoUtils.generateRandomLatitude();
        	// double longitude = GeoUtils.generateRandomLatitude();

            // 条件打印调试信息
            if (System.getenv("DEBUG") != null && System.getenv("DEBUG").equals("true")) {
            	//        System.out.println("Inserting Latitude: " + latitude + ", Longitude: " + longitude);
            }

            // 插入数据到 DroneStatus 表
            String sql = "INSERT INTO DroneStatus (latitude, longitude, altitude, speed, batteryLevel, planID, userID) VALUES (?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            	//  stmt.setDouble(1, latitude);
            	//   stmt.setDouble(2, longitude);
                stmt.setInt(3, DEFAULT_ALTITUDE);
                stmt.setInt(4, DEFAULT_SPEED);
                stmt.setInt(5, DEFAULT_BATTERY_LEVEL);
                stmt.setInt(6, planID);
                stmt.setInt(7, userID);
                stmt.executeUpdate();
            }

            // 成功响应
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": true}");
        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Database error occurred\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"An unexpected error occurred\"}");
        }
    }
}
