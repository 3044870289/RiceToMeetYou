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

@WebServlet("/deleteStation")
public class DeleteStationServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            Gson gson = new Gson();
            Map<String, Object> requestData = gson.fromJson(request.getReader(), Map.class);
            int stationID = ((Number) requestData.get("stationID")).intValue();


            System.out.printf("Deleting station with ID: %d%n", stationID);

            try (Connection conn = DBConnection.getConnection()) {
                String sql = "DELETE FROM Stations WHERE stationID = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setInt(1, stationID);
                int rowsAffected = stmt.executeUpdate();

                if (rowsAffected > 0) {
                    response.getWriter().write("{\"status\": \"success\"}");
                } else {
                    response.getWriter().write("{\"status\": \"error\", \"message\": \"Station not found\"}");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"status\": \"error\", \"message\": \"Failed to delete station\"}");
        }
    }
}
