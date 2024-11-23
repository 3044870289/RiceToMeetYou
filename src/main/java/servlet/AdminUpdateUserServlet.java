package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import dao.DBConnection;

@WebServlet("/AdminUpdateUserServlet")
public class AdminUpdateUserServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userIDStr = request.getParameter("userID");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String roleStr = request.getParameter("newRole");

        int userID = Integer.parseInt(userIDStr);
        int role = Integer.parseInt(roleStr);

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "UPDATE User SET Password = ?, Email = ?, Address = ?, Role = ? WHERE UserID = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, password);
            stmt.setString(2, email);
            stmt.setString(3, address);
            stmt.setInt(4, role);
            stmt.setInt(5, userID);
            stmt.executeUpdate();
            response.sendRedirect("admin.jsp?success=true");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin.jsp?error=true");
        }
    }
}
