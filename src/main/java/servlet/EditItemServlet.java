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

@WebServlet("/EditItemServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50   // 50MB
)
public class EditItemServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String UPLOAD_DIR = "images";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String idStr = request.getParameter("id");
        String name = request.getParameter("name");
        String comment = request.getParameter("comment");
        String priceStr = request.getParameter("price");
        String stockStr = request.getParameter("stock");
        Part filePart = request.getPart("photo"); // 上传的图片文件

        if (idStr == null || name == null || comment == null || priceStr == null || stockStr == null ||
            idStr.isEmpty() || name.isEmpty() || comment.isEmpty() || priceStr.isEmpty() || stockStr.isEmpty()) {
            response.sendRedirect("manageShop.jsp?error=missing_fields");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            double price = Double.parseDouble(priceStr);
            int stock = Integer.parseInt(stockStr);
            String fileName = null;

            if (filePart != null && filePart.getSize() > 0) {
                String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdir();
                }

                fileName = new File(filePart.getSubmittedFileName()).getName();
                String filePath = uploadPath + File.separator + fileName;
                filePart.write(filePath);
            }

            try (Connection conn = DBConnection.getConnection()) {
                String sql = "UPDATE Shop SET Name = ?, Comment = ?, Price = ?, Stock = ?"
                        + (fileName != null ? ", Photo = ?" : "")
                        + " WHERE ID = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, name);
                stmt.setString(2, comment);
                stmt.setDouble(3, price);
                stmt.setInt(4, stock);
                if (fileName != null) {
                    stmt.setString(5, fileName);
                    stmt.setInt(6, id);
                } else {
                    stmt.setInt(5, id);
                }
                stmt.executeUpdate();
            }
            response.sendRedirect("manageShop.jsp?success=item_edited");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manageShop.jsp?error=database_error");
        }
    }
}
