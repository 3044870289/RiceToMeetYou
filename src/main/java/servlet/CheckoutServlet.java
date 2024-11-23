package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.DBConnection;

@WebServlet("/CheckoutServlet")
public class CheckoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 获取用户 ID
        Integer userID = (Integer) request.getSession().getAttribute("userID");
        if (userID == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // 开启事务

            // 获取购物车信息
            List<int[]> cartItems = new ArrayList<>();
            double totalAmount = fetchCartItems(conn, userID, cartItems);

            if (cartItems.isEmpty()) {
                response.sendRedirect("cart.jsp?error=empty_cart");
                return;
            }

            // 插入购买记录
            int purchaseID = insertPurchase(conn, userID, totalAmount);

            // 插入购买详细信息
            insertPurchaseDetails(conn, purchaseID, cartItems);

            // 清空购物车
            clearCart(conn, userID);

            conn.commit(); // 提交事务
            response.sendRedirect("index.jsp?success=checkout");
        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback(); // 回滚事务
                } catch (SQLException rollbackEx) {
                    rollbackEx.printStackTrace();
                }
            }
            response.sendRedirect("index.jsp?error=checkout");
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException closeEx) {
                    closeEx.printStackTrace();
                }
            }
        }
    }

    /**
     * 从购物车获取商品信息和总金额
     */
    private double fetchCartItems(Connection conn, int userID, List<int[]> cartItems) throws SQLException {
        String selectCartSQL = "SELECT ShopID, Quantity FROM cart WHERE UserID = ?";
        double totalAmount = 0;
        try (PreparedStatement selectStmt = conn.prepareStatement(selectCartSQL)) {
            selectStmt.setInt(1, userID);
            try (ResultSet rs = selectStmt.executeQuery()) {
                while (rs.next()) {
                    int shopID = rs.getInt("ShopID");
                    int quantity = rs.getInt("Quantity");
                    cartItems.add(new int[] { shopID, quantity });
                    totalAmount += quantity * getPrice(conn, shopID);
                }
            }
        }
        return totalAmount;
    }

    /**
     * 根据商品 ID 获取商品价格
     */
    private double getPrice(Connection conn, int shopID) throws SQLException {
        String sql = "SELECT Price FROM Shop WHERE ID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, shopID);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("Price");
                } else {
                    throw new SQLException("Price not found for ShopID: " + shopID);
                }
            }
        }
    }

    /**
     * 插入购买记录
     */
    private int insertPurchase(Connection conn, int userID, double totalAmount) throws SQLException {
        String insertPurchaseSQL = "INSERT INTO Purchase (UserID, TotalAmount, Plan) VALUES (?, ?, ?)";
        try (PreparedStatement purchaseStmt = conn.prepareStatement(insertPurchaseSQL, Statement.RETURN_GENERATED_KEYS)) {
            purchaseStmt.setInt(1, userID);
            purchaseStmt.setDouble(2, totalAmount);
            purchaseStmt.setString(3, "Standard Plan"); // 示例计划
            purchaseStmt.executeUpdate();

            try (ResultSet generatedKeys = purchaseStmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                } else {
                    throw new SQLException("Creating purchase failed, no ID obtained.");
                }
            }
        }
    }

    /**
     * 插入购买详细信息
     */
    private void insertPurchaseDetails(Connection conn, int purchaseID, List<int[]> cartItems) throws SQLException {
        String insertDetailSQL = "INSERT INTO PurchaseDetails (PurchaseID, ShopID, Quantity) VALUES (?, ?, ?)";
        try (PreparedStatement detailStmt = conn.prepareStatement(insertDetailSQL)) {
            for (int[] item : cartItems) {
                detailStmt.setInt(1, purchaseID);
                detailStmt.setInt(2, item[0]);
                detailStmt.setInt(3, item[1]);
                detailStmt.addBatch();
            }
            detailStmt.executeBatch();
        }
    }

    /**
     * 清空购物车
     */
    private void clearCart(Connection conn, int userID) throws SQLException {
        String clearCartSQL = "DELETE FROM cart WHERE UserID = ?";
        try (PreparedStatement clearCartStmt = conn.prepareStatement(clearCartSQL)) {
            clearCartStmt.setInt(1, userID);
            clearCartStmt.executeUpdate();
        }
    }
}
