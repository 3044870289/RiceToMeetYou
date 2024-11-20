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

@WebServlet("/UpdateUserInfoServlet")
public class UpdateUserInfoServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userID = (String) request.getSession().getAttribute("userID");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String address = request.getParameter("address");

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "UPDATE User SET Password = ?, Email = ?, Address = ? WHERE UserID = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, password);
            stmt.setString(2, email);
            stmt.setString(3, address);
            stmt.setString(4, userID);
            stmt.executeUpdate();
            response.sendRedirect("user.jsp?success=true");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("user.jsp?error=true");
        }
    }
}
