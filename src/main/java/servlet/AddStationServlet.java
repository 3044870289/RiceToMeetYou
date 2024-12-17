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
import java.util.Map;


@WebServlet("/addStation")
public class AddStationServlet extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    System.out.println("Received request to add station."); // 调试日志
	    response.setContentType("application/json");
	    response.setCharacterEncoding("UTF-8");

	    try {
	        Gson gson = new Gson();
	        Map<String, Double> stationData = gson.fromJson(request.getReader(), Map.class);
	        double latitude = stationData.get("latitude");
	        double longitude = stationData.get("longitude");

	        System.out.printf("Adding station at latitude: %.6f, longitude: %.6f%n", latitude, longitude);

	        try (Connection conn = DBConnection.getConnection()) {
	            String sql = "INSERT INTO Stations (latitude, longitude) VALUES (?, ?)";
	            PreparedStatement stmt = conn.prepareStatement(sql);
	            stmt.setDouble(1, latitude);
	            stmt.setDouble(2, longitude);
	            stmt.executeUpdate();

	            response.getWriter().write("{\"status\": \"success\"}");
	        } catch (Exception e) {
	            e.printStackTrace();
	            response.getWriter().write("{\"status\": \"error\", \"message\": \"Failed to save station to database\"}");
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        response.getWriter().write("{\"status\": \"error\", \"message\": \"Invalid request data\"}");
	    }
	}
}