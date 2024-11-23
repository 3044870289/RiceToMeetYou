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

@WebServlet("/EditPlanServlet")
public class EditPlanServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); // 确保请求的编码为 UTF-8
        String plan = request.getParameter("plan");
        String planName = request.getParameter("planName");
        String duration = request.getParameter("duration");
        String amountStr = request.getParameter("amount");
        String priceStr = request.getParameter("price");

        if (plan == null || planName == null || duration == null || amountStr == null || priceStr == null ||
            plan.isEmpty() || planName.isEmpty() || duration.isEmpty() || amountStr.isEmpty() || priceStr.isEmpty()) {
            response.sendRedirect("managePlans.jsp?error=missing_fields");
            return;
        }

        try {
            int amount = Integer.parseInt(amountStr);
            int price = Integer.parseInt(priceStr);

            try (Connection conn = DBConnection.getConnection()) {
                String sql = "UPDATE DronePlans SET PlanName = ?, ContractDuration = ?, HarvestAmount = ?, Price = ? WHERE Plan = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, planName);  // 更新 PlanName
                stmt.setString(2, duration);
                stmt.setInt(3, amount);
                stmt.setInt(4, price);
                stmt.setString(5, plan);     // 条件是 Plan
                stmt.executeUpdate();
            }
            response.sendRedirect("managePlans.jsp?success=plan_edited");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("managePlans.jsp?error=database_error");
        }
    }
}
