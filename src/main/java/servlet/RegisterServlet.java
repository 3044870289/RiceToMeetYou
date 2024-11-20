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

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String address = request.getParameter("address");

        try (Connection conn = DBConnection.getConnection()) {
            // 插入新用户
            String sql = "INSERT INTO User (Username, Password, Email, Address) VALUES (?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, password);
            stmt.setString(3, email);
            stmt.setString(4, address);
            stmt.executeUpdate();

            // 注册成功后重定向到登录页面，传递提示信息
            response.sendRedirect("login.jsp?success=true");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("register.jsp?error=true"); // 注册失败，返回注册页面
        }
    }
}
