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

@WebServlet("/DeleteItemServlet")
public class DeleteItemServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); // 设置请求编码为 UTF-8
        String idStr = request.getParameter("id");

        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect("manageShop.jsp?error=missing_id");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);

            try (Connection conn = DBConnection.getConnection()) {
                String sql = "DELETE FROM Shop WHERE ID = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setInt(1, id);
                stmt.executeUpdate();
            }

            // 删除成功后，重定向回管理页面
            response.sendRedirect("manageShop.jsp?success=item_deleted");
        } catch (Exception e) {
            e.printStackTrace();
            // 删除失败，返回管理页面并提示错误
            response.sendRedirect("manageShop.jsp?error=database_error");
        }
    }
}
