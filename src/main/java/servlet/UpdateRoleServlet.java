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

@WebServlet("/UpdateRoleServlet")
public class UpdateRoleServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userID = request.getParameter("userID");
        String newRole = request.getParameter("newRole");

        // 当前登录的用户
        String currentUserID = (String) request.getSession().getAttribute("userID");

        if (userID.equals(currentUserID)) {
            response.getWriter().println("不能修改自己的角色！");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "UPDATE User SET Role = ? WHERE UserID = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, newRole);
            stmt.setString(2, userID);
            stmt.executeUpdate();
            response.sendRedirect("admin.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin.jsp?error=true");
        }
    }
}
