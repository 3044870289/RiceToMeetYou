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

@WebServlet("/CheckoutServlet")
public class CheckoutServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int userID = Integer.parseInt(request.getParameter("userID"));

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "DELETE FROM cart WHERE UserID = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userID);
            stmt.executeUpdate();

            // 跳转到感谢页面
            response.sendRedirect("thankyou.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("cart.jsp?error=true");
        }
    }
}
