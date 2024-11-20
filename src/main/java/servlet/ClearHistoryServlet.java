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

@WebServlet("/ClearHistoryServlet")
public class ClearHistoryServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userIDStr = request.getParameter("userID");

        if (userIDStr == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            int userID = Integer.parseInt(userIDStr);

            // 删除用户的所有履历
            String sql = "DELETE FROM DronePlanSelection WHERE UserID = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userID);
            stmt.executeUpdate();

            // 重定向到选择页面
            response.sendRedirect("choosePlan.jsp?cleared=true");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("choosePlan.jsp?error=true");
        }
    }
}
