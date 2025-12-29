import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.sql.*;

public class orderplaced extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Read form parameters
        String orderId = request.getParameter("orderId");
        String patientId = request.getParameter("patientId");
        String patientName = request.getParameter("patientName");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");
        String items = request.getParameter("items");
        String totalCostStr = request.getParameter("totalCost");
        String paymentMode = request.getParameter("paymentMode");

        double totalCost = 0;
        try {
            totalCost = Double.parseDouble(totalCostStr);
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

        Connection con = null;
        PreparedStatement ps = null;

        try {
            // Load Oracle JDBC Driver
            Class.forName("oracle.jdbc.driver.OracleDriver");

            // Connect to Oracle DB (replace username/password with yours)
            con = DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521:XE",
                "system", "manager"
            );

            // Insert into pharmacy_order table
            String sql = "INSERT INTO pharmacy_order "
                    + "(order_id, patient_id, patient_name, address, phone, items, total_cost, payment_mode, status) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

            ps = con.prepareStatement(sql);
            ps.setString(1, orderId);
            ps.setString(2, patientId);
            ps.setString(3, patientName);
            ps.setString(4, address);
            ps.setString(5, phone);
            ps.setString(6, items);
            ps.setDouble(7, totalCost);
            ps.setString(8, paymentMode);
            ps.setString(9, "shipped"); // default status

            int i = ps.executeUpdate();

            // Redirect or show success message
            if (i > 0) {
                response.setContentType("text/html");
                PrintWriter out = response.getWriter();
                out.println("<html><body>Order Placed successfully <br>");
                out.println("<button onclick=\"window.location.href='patientdashboard.jsp'\">Dashboard</button><br>");
                out.println("<button onclick=\"window.location.href='pharmacy.html'\">Pharmacy store</button>");

            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error placing order: " + e.getMessage());
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) { e.printStackTrace(); }
            try { if (con != null) con.close(); } catch (Exception e) { e.printStackTrace(); }
        }
    }
}
