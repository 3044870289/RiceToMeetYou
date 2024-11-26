package servlet;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.Map;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

import java.sql.Connection;
import java.sql.PreparedStatement;

import dao.DBConnection;

@WebServlet("/updateDroneLocation")
public class UpdateDroneLocationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // 调试信息：接收请求
        System.out.println("Received request to update drone location.");

        try (BufferedReader reader = request.getReader()) {
            Gson gson = new Gson();
            Map<String, Object> requestBody = gson.fromJson(reader, Map.class);

            // 从请求体中提取参数
            int droneID = ((Double) requestBody.get("droneID")).intValue();
            double latitude = (Double) requestBody.get("latitude");
            double longitude = (Double) requestBody.get("longitude");

            // 打印调试信息
            System.out.printf("Updating droneID: %d to new location: (%.6f, %.6f)%n", droneID, latitude, longitude);

            // 更新数据库中的无人机位置
            try (Connection conn = DBConnection.getConnection()) {
                String sql = "UPDATE DroneStatus SET latitude = ?, longitude = ? WHERE droneID = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setDouble(1, latitude);
                stmt.setDouble(2, longitude);
                stmt.setInt(3, droneID);

                // 执行更新并获取影响行数
                int rowsAffected = stmt.executeUpdate();
                if (rowsAffected > 0) {
                    System.out.println("Drone location updated successfully.");
                    response.getWriter().write("{\"status\": \"success\"}");
                } else {
                    System.out.println("Failed to update: Drone not found.");
                    response.getWriter().write("{\"status\": \"fail\", \"message\": \"Drone not found.\"}");
                }
            } catch (Exception e) {
                System.err.println("Database operation failed: " + e.getMessage());
                e.printStackTrace();
                response.getWriter().write("{\"status\": \"error\", \"message\": \"Internal server error.\"}");
            }
        } catch (Exception e) {
            System.err.println("Error parsing request body: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().write("{\"status\": \"error\", \"message\": \"Invalid request.\"}");
        }
    }
}
