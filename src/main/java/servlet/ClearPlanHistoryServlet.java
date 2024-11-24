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

@WebServlet("/ClearPlanHistoryServlet")
public class ClearPlanHistoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 获取当前会话中的用户ID
        Integer userID = (Integer) request.getSession().getAttribute("userID");
        if (userID == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            // 删除用户的方案选择记录
            String clearHistorySQL = "DELETE FROM DronePlanSelection WHERE UserID = ?";
            PreparedStatement clearHistoryStmt = conn.prepareStatement(clearHistorySQL);
            clearHistoryStmt.setInt(1, userID);
            int historyRowsAffected = clearHistoryStmt.executeUpdate();

            // 删除用户的无人机记录
            String deleteDronesSQL = "DELETE FROM DroneStatus WHERE userID = ?";
            PreparedStatement deleteDronesStmt = conn.prepareStatement(deleteDronesSQL);
            deleteDronesStmt.setInt(1, userID);
            int dronesRowsAffected = deleteDronesStmt.executeUpdate();

            // 根据执行结果返回成功或信息提示
            if (historyRowsAffected > 0 || dronesRowsAffected > 0) {
                response.sendRedirect("index.jsp?success=clear_plan_history");
            } else {
                response.sendRedirect("index.jsp?info=no_plan_history_or_drones");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("index.jsp?error=clear_plan_history");
        }
    }
}
