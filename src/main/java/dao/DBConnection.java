package dao;

import java.sql.Connection;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBConnection {
	private static final String URL = "jdbc:mysql://localhost:3306/riceDB?useUnicode=true&characterEncoding=UTF-8";
    private static final String USER = "root";
    private static final String PASSWORD = "qq5452";
    private static final Logger LOGGER = Logger.getLogger(DBConnection.class.getName());

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "MySQL JDBC 驱动加载失败", e);
        }
    }

    /**
     * 获取数据库连接
     *
     * @return 数据库连接对象
     */
    public static Connection getConnection() {
        try {
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            LOGGER.info("成功获取数据库连接");
            return conn;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "获取数据库连接失败", e);
            return null;
        }
    }

    /**
     * 注销所有 JDBC 驱动
     */
    public static void closeAllDrivers() {
        Enumeration<Driver> drivers = DriverManager.getDrivers();
        while (drivers.hasMoreElements()) {
            Driver driver = drivers.nextElement();
            try {
                DriverManager.deregisterDriver(driver);
                LOGGER.info("已注销 JDBC 驱动: " + driver);
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "注销 JDBC 驱动失败", e);
            }
        }
    }

    /**
     * 停止 MySQL 清理线程
     */
    public static void shutdownCleanupThread() {
        com.mysql.cj.jdbc.AbandonedConnectionCleanupThread.checkedShutdown();
		LOGGER.info("MySQL 清理线程已停止");
    }
}
