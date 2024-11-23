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
import java.util.HashMap;
import java.util.Map;

@WebServlet("/getPlanDetails")
public class GetPlanDetailsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");

        String planIDStr = request.getParameter("planID");
        if (planIDStr == null || planIDStr.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"planID is required\"}");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT planID, planName, contractDuration, harvestAmount, price FROM DronePlans WHERE planID = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(planIDStr));
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Map<String, Object> planDetails = new HashMap<>();
                planDetails.put("planID", rs.getInt("planID"));
                planDetails.put("planName", rs.getString("planName"));
                planDetails.put("contractDuration", rs.getString("contractDuration"));
                planDetails.put("harvestAmount", rs.getInt("harvestAmount"));
                planDetails.put("price", rs.getInt("price"));

                Gson gson = new Gson();
                response.getWriter().write(gson.toJson(planDetails));
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\": \"Plan not found\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"An error occurred while fetching plan details\"}");
        }
    }
}
