package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.DBConnection;

@WebServlet("/SelectPlanServlet")
public class SelectPlanServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userIDStr = request.getParameter("userID");
        String plan = request.getParameter("plan");
        String countStr = request.getParameter("count"); // 新增输入的选择次数

        try (Connection conn = DBConnection.getConnection()) {
            int userID = Integer.parseInt(userIDStr);
            int count = Integer.parseInt(countStr);

            // 检查是否已有相同的 UserID 和 Plan
            String checkSQL = "SELECT Count FROM DronePlanSelection WHERE UserID = ? AND Plan = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkSQL);
            checkStmt.setInt(1, userID);
            checkStmt.setString(2, plan);

            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                // 如果记录已存在，更新 Count 值
                int existingCount = rs.getInt("Count");
                String updateSQL = "UPDATE DronePlanSelection SET Count = ? WHERE UserID = ? AND Plan = ?";
                PreparedStatement updateStmt = conn.prepareStatement(updateSQL);
                updateStmt.setInt(1, existingCount + count);
                updateStmt.setInt(2, userID);
                updateStmt.setString(3, plan);
                updateStmt.executeUpdate();
            } else {
                // 如果记录不存在，插入新记录
                String insertSQL = "INSERT INTO DronePlanSelection (UserID, Plan, Count) VALUES (?, ?, ?)";
                PreparedStatement insertStmt = conn.prepareStatement(insertSQL);
                insertStmt.setInt(1, userID);
                insertStmt.setString(2, plan);
                insertStmt.setInt(3, count);
                insertStmt.executeUpdate();
            }

            response.sendRedirect("choosePlan.jsp?success=true");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("choosePlan.jsp?error=true");
        }
    }
}
