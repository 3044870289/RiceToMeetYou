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
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String ownParam = request.getParameter("own");
        Integer userID = (Integer) request.getSession().getAttribute("userID");

        List<Map<String, Object>> drones = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {
            String sql;
            if ("true".equalsIgnoreCase(ownParam) && userID != null) {
                sql = "SELECT ds.droneID, ds.latitude, ds.longitude, ds.altitude, ds.speed, " +
                      "ds.batteryLevel, dp.planID, dp.planName, dp.contractDuration, dp.harvestAmount, dp.price " +
                      "FROM DroneStatus ds " +
                      "JOIN DronePlans dp ON ds.planID = dp.planID " +
                      "WHERE ds.userID = ?";
            } else {
                sql = "SELECT ds.droneID, ds.latitude, ds.longitude, ds.altitude, ds.speed, " +
                      "ds.batteryLevel, dp.planID, dp.planName, dp.contractDuration, dp.harvestAmount, dp.price " +
                      "FROM DroneStatus ds " +
                      "JOIN DronePlans dp ON ds.planID = dp.planID";
            }

            PreparedStatement stmt = conn.prepareStatement(sql);
            if ("true".equalsIgnoreCase(ownParam) && userID != null) {
                stmt.setInt(1, userID);
            }

            ResultSet rs = stmt.executeQuery();

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
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"An error occurred while fetching drone data.\"}");
            return;
        }

        Gson gson = new Gson();
        response.getWriter().write(gson.toJson(drones));
    }
}
