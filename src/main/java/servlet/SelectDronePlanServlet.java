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

@WebServlet("/selectDronePlan")
public class SelectDronePlanServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String planIDStr = request.getParameter("planID");
        String userIDStr = request.getParameter("userID");

        if (planIDStr == null || userIDStr == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Missing planID or userID\"}");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            int planID = Integer.parseInt(planIDStr);

            // 生成随机位置
            double latitude = GeoUtils.generateRandomLatitude();
            double longitude = GeoUtils.generateRandomLongitude();

            // 插入数据到 DroneStatus 表
            String sql = "INSERT INTO DroneStatus (latitude, longitude, altitude, speed, batteryLevel, planID) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setDouble(1, latitude);
            stmt.setDouble(2, longitude);
            stmt.setInt(3, 0); // 初始高度
            stmt.setInt(4, 0); // 初始速度
            stmt.setInt(5, 100); // 初始电池电量
            stmt.setInt(6, planID);
            stmt.executeUpdate();

            response.setContentType("application/json");
            response.getWriter().write("{\"success\": true}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"An error occurred while processing the request\"}");
        }
    }
}
