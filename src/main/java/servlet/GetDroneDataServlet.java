package servlet;

import dao.DBConnection;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/getDroneData")
public class GetDroneDataServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String ownParam = request.getParameter("own"); // 获取own参数
        Integer userID = (Integer) request.getSession().getAttribute("userID");

        List<Map<String, Object>> drones = new ArrayList<>();
        String sql = ""; // 初始化 SQL

        try (Connection conn = DBConnection.getConnection()) {
            // 确保 userID 存在，或者为全局显示的情况设置 SQL
            if ("true".equalsIgnoreCase(ownParam) && userID != null) {
                sql = "SELECT ds.droneID, ds.latitude, ds.longitude, ds.altitude, ds.speed, " +
                      "ds.batteryLevel, dp.planID, dp.planName, dp.contractDuration, dp.harvestAmount, dp.price " +
                      "FROM DroneStatus ds " +
                      "JOIN DronePlans dp ON ds.planID = dp.planID " +
                      "WHERE ds.userID = ?";
                System.out.println("Filtered SQL (own=true): " + sql + ", userID=" + userID);
            } else {
                sql = "SELECT ds.droneID, ds.latitude, ds.longitude, ds.altitude, ds.speed, " +
                      "ds.batteryLevel, dp.planID, dp.planName, dp.contractDuration, dp.harvestAmount, dp.price " +
                      "FROM DroneStatus ds " +
                      "JOIN DronePlans dp ON ds.planID = dp.planID";
                System.out.println("General SQL (own=false): " + sql);
            }

            // 准备 SQL 并绑定参数
            PreparedStatement stmt = conn.prepareStatement(sql);
            if ("true".equalsIgnoreCase(ownParam) && userID != null) {
                stmt.setInt(1, userID);
            }

            // 执行查询
            ResultSet rs = stmt.executeQuery();
            System.out.println("Query executed, fetching results...");

            // 解析结果
            while (rs.next()) {
                Map<String, Object> drone = new HashMap<>();
                drone.put("droneID", rs.getInt("droneID"));
                drone.put("latitude", rs.getDouble("latitude"));
                drone.put("longitude", rs.getDouble("longitude"));
                drone.put("altitude", rs.getInt("altitude"));
                drone.put("speed", rs.getInt("speed"));
                drone.put("batteryLevel", rs.getInt("batteryLevel"));
                drone.put("planID", rs.getInt("planID"));
                drone.put("planName", rs.getString("planName"));
                drone.put("contractDuration", rs.getString("contractDuration"));
                drone.put("harvestAmount", rs.getInt("harvestAmount"));
                drone.put("price", rs.getInt("price"));

                drones.add(drone);
            }
            System.out.println("Query result size: " + drones.size());
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"An error occurred while fetching drone data.\"}");
            return;
        }

        // 返回 JSON 数据
        Gson gson = new Gson();
        response.getWriter().write(gson.toJson(drones));
    }
}
