package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletResponse;

import dao.DBConnection;

@WebServlet("/RemoveFromCartServlet")
public class RemoveFromCartServlet extends HttpServlet {
    protected void doPost(javax.servlet.http.HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int cartID = Integer.parseInt(request.getParameter("cartID"));

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "DELETE FROM cart WHERE CartID = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, cartID);
            stmt.executeUpdate();
            response.sendRedirect("cart.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("cart.jsp?error=true");
        }
    }
}
