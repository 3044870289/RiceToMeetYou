package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import dao.DBConnection;

@WebServlet("/UpdateRoleServlet")
public class UpdateRoleServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userIDStr = request.getParameter("userID");
        String newRoleStr = request.getParameter("newRole");

        int userID = Integer.parseInt(userIDStr);
        int newRole = Integer.parseInt(newRoleStr);

        // 当前登录的用户ID
        int currentUserID = (Integer) request.getSession().getAttribute("userID");

        // 验证是否修改当前用户
        if (userID == currentUserID) {
            response.getWriter().println("无法修改自己的权限");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "UPDATE User SET Role = ? WHERE UserID = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, newRole);
            stmt.setInt(2, userID);
            stmt.executeUpdate();
            response.sendRedirect("admin.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin.jsp?error=true");
        }
    }
}
