package servlet;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import dao.DBConnection;

@WebServlet("/AddItemServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50   // 50MB
)
public class AddItemServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String UPLOAD_DIR = "images";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	request.setCharacterEncoding("UTF-8"); // 设置请求参数的编码为 UTF-8
    	String name = request.getParameter("name");
        String comment = request.getParameter("comment");
        String priceStr = request.getParameter("price");
        String stockStr = request.getParameter("stock");
        Part filePart = request.getPart("photo"); // 获取上传的图片文件     
        if (name == null || comment == null || priceStr == null || stockStr == null || filePart == null ||
            name.isEmpty() || comment.isEmpty() || priceStr.isEmpty() || stockStr.isEmpty() || filePart.getSize() == 0) {
            response.sendRedirect("manageShop.jsp?error=missing_fields");
            return;
        }

        try {
            double price = Double.parseDouble(priceStr);
            int stock = Integer.parseInt(stockStr);

            // 保存图片文件到服务器
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir(); // 创建图片目录
            }

            String fileName = new File(filePart.getSubmittedFileName()).getName();
            String filePath = uploadPath + File.separator + fileName;
            filePart.write(filePath); // 保存图片

            try (Connection conn = DBConnection.getConnection()) {
                String sql = "INSERT INTO Shop (Name, Comment, Price, Stock, Photo) VALUES (?, ?, ?, ?, ?)";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, name);
                stmt.setString(2, comment);
                stmt.setDouble(3, price);
                stmt.setInt(4, stock);
                stmt.setString(5, fileName); // 存储文件名到数据库
                stmt.executeUpdate();
                

            }
            response.sendRedirect("manageShop.jsp?success=item_added");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manageShop.jsp?error=database_error");
        }
    }
}
