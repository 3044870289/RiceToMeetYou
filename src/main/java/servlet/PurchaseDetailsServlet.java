package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.DBConnection;

@WebServlet("/PurchaseDetailsServlet")
public class PurchaseDetailsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 获取 purchaseID 参数
        String purchaseIDParam = request.getParameter("purchaseID");
        Integer purchaseID = null;

        try {
            purchaseID = Integer.valueOf(purchaseIDParam);
        } catch (NumberFormatException e) {
            response.sendRedirect("index.jsp?error=invalidPurchaseID");
            return;
        }

        if (purchaseID == null) {
            response.sendRedirect("index.jsp?error=invalidPurchaseID");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            // 查询 PurchaseDetails 表中的数据
            String sql = "SELECT Shop.Name, Shop.Price, PurchaseDetails.Quantity " +
                         "FROM PurchaseDetails JOIN Shop ON PurchaseDetails.ShopID = Shop.ID " +
                         "WHERE PurchaseDetails.PurchaseID = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, purchaseID);

            ResultSet rs = stmt.executeQuery();
            List<Map<String, String>> details = new ArrayList<>();

            // 遍历结果集并存储数据
            while (rs.next()) {
                Map<String, String> detail = new HashMap<>();
                detail.put("name", rs.getString("Name"));
                detail.put("price", rs.getString("Price"));
                detail.put("quantity", rs.getString("Quantity"));
                details.add(detail);
            }

            // 将详情数据添加到请求属性中并转发到 JSP 页面
            request.setAttribute("details", details);
            request.getRequestDispatcher("purchaseDetails.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("index.jsp?error=exception");
        }
    }
}
