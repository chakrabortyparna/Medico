import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;


public class updatestatus extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String orderId = request.getParameter("orderId");
        String status = request.getParameter("status");

        Connection con = null;
        PreparedStatement ps = null;

        try {
            // Load Oracle JDBC Driver
            Class.forName("oracle.jdbc.driver.OracleDriver");

            // Database connection
            con = DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521:xe",
                "system",
                "manager"
            );

            // Update status in pharmacy_order table
            String sql = "UPDATE pharmacy_order SET status=? WHERE order_id=?";
            ps = con.prepareStatement(sql);
            ps.setString(1, status);
            ps.setString(2, orderId);

            ps.executeUpdate();

            // Redirect back to pharmacy_order.jsp
            response.sendRedirect("pharmacyorders.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error updating order status");
        } finally {
            try { if(ps != null) ps.close(); } catch(Exception e){}
            try { if(con != null) con.close(); } catch(Exception e){}
        }
    }
}
