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

@WebServlet("/SelectPlanServlet")
public class SelectPlanServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userIDStr = request.getParameter("userID");
        String plan = request.getParameter("plan");

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO DronePlanSelection (UserID, Plan) VALUES (?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(userIDStr)); // 将 userID 转为整数
            stmt.setString(2, plan);
            stmt.executeUpdate();

            response.sendRedirect("choosePlan.jsp?success=true");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("choosePlan.jsp?error=true");
        }
    }
}
