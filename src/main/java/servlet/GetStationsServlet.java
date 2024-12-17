package servlet;

import com.google.gson.Gson;
import dao.DBConnection;

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

@WebServlet("/getStations")
public class GetStationsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        List<Map<String, Object>> stations = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT stationID, latitude, longitude FROM Stations";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Map<String, Object> station = new HashMap<>();
                station.put("stationID", rs.getInt("stationID"));
                station.put("latitude", rs.getDouble("latitude"));
                station.put("longitude", rs.getDouble("longitude"));
                stations.add(station);
            }

            String json = new Gson().toJson(stations);
            response.getWriter().write(json);
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"status\": \"error\", \"message\": \"Failed to load stations\"}");
        }
    }
}
