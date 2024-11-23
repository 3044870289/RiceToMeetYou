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

@WebServlet("/SelectPlanMultipleServlet")
public class SelectPlanMultipleServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userIDStr = request.getParameter("userID");
        String plan = request.getParameter("plan");
        String countStr = request.getParameter("count");

        try (Connection conn = DBConnection.getConnection()) {
            int userID = Integer.parseInt(userIDStr);
            int count = Integer.parseInt(countStr);

            // 插入一条新记录
            String insertSQL = "INSERT INTO DronePlanSelection (UserID, Plan, Count) VALUES (?, ?, ?)";
            PreparedStatement insertStmt = conn.prepareStatement(insertSQL);
            insertStmt.setInt(1, userID);
            insertStmt.setString(2, plan);
            insertStmt.setInt(3, count);
            insertStmt.executeUpdate();

            response.sendRedirect("choosePlan.jsp?success=true");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("choosePlan.jsp?error=true");
        }
    }
}
