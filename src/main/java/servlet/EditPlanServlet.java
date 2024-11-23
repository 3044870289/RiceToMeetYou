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

        // 获取请求参数
        String planIDStr = request.getParameter("planID");
        String planName = request.getParameter("planName");
        String duration = request.getParameter("duration");
        String amountStr = request.getParameter("amount");
        String priceStr = request.getParameter("price");

        // 检查是否有缺失的字段
        if (planIDStr == null || planName == null || duration == null || amountStr == null || priceStr == null ||
            planIDStr.isEmpty() || planName.isEmpty() || duration.isEmpty() || amountStr.isEmpty() || priceStr.isEmpty()) {
            response.sendRedirect("managePlans.jsp?error=missing_fields");
            return;
        }

        try {
            // 将输入的数值参数转换为整数
            int planID = Integer.parseInt(planIDStr);
            int amount = Integer.parseInt(amountStr);
            int price = Integer.parseInt(priceStr);

            // 数据库更新操作
            try (Connection conn = DBConnection.getConnection()) {
                String sql = "UPDATE DronePlans SET PlanName = ?, ContractDuration = ?, HarvestAmount = ?, Price = ? WHERE planID = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, planName);  // 更新 PlanName
                stmt.setString(2, duration);  // 更新 ContractDuration
                stmt.setInt(3, amount);       // 更新 HarvestAmount
                stmt.setInt(4, price);        // 更新 Price
                stmt.setInt(5, planID);       // 条件是 planID
                stmt.executeUpdate();
            }

            // 成功后重定向到管理页面
            response.sendRedirect("managePlans.jsp?success=plan_edited");
        } catch (NumberFormatException e) {
            // 处理数字转换错误
            e.printStackTrace();
            response.sendRedirect("managePlans.jsp?error=invalid_input");
        } catch (Exception e) {
            // 处理数据库相关错误
            e.printStackTrace();
            response.sendRedirect("managePlans.jsp?error=database_error");
        }
    }
}
