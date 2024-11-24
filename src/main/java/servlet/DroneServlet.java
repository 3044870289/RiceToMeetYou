package servlet;

import service.DroneService;
import model.Drone;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/drones")
public class DroneServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String globalViewParam = request.getParameter("globalView");
        
        boolean globalView = globalViewParam != null && globalViewParam.equals("true");

        Integer userID = (Integer) request.getSession().getAttribute("userID");
        DroneService droneService = new DroneService();

        try {
            List<Drone> drones = droneService.getDrones(userID, globalView);
            request.setAttribute("drones", drones); // 确保此处正确设置
            request.getRequestDispatcher("drones.jsp").forward(request, response);
            System.out.println("Drones: " + drones);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error fetching drones");
        }
    }
}
