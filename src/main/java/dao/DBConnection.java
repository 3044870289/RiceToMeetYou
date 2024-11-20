package dao;
import java.sql.Connection;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Enumeration;

public class DBConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/riceDB";
    private static final String USER = "root";
    private static final String PASSWORD = "qq5452";

    public static Connection getConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // 在应用停止时注销 JDBC 驱动
    public static void closeAllDrivers() {
        Enumeration<Driver> drivers = DriverManager.getDrivers();
        while (drivers.hasMoreElements()) {
            Driver driver = drivers.nextElement();
            try {
                DriverManager.deregisterDriver(driver);
                System.out.println("已注销 JDBC 驱动: " + driver);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // 停止 MySQL 清理线程
    public static void shutdownCleanupThread() throws InterruptedException {
        com.mysql.cj.jdbc.AbandonedConnectionCleanupThread.checkedShutdown();
		System.out.println("MySQL 清理线程已停止");
    }
}
