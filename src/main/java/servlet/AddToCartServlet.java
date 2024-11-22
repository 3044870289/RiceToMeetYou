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

@WebServlet("/AddToCartServlet")
public class AddToCartServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int userID = Integer.parseInt(request.getParameter("userID"));
        int shopID = Integer.parseInt(request.getParameter("shopID"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO cart (UserID, ShopID, Quantity) VALUES (?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userID);
            stmt.setInt(2, shopID);
            stmt.setInt(3, quantity);
            stmt.executeUpdate();
            response.sendRedirect("cart.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("shop.jsp?error=true");
        }
    }
}
