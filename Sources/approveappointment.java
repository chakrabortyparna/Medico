import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.sql.*;

public class approveappointment extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String appointmentId = request.getParameter("appointment_id");
        String status = request.getParameter("status");

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");

            Connection con = DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521:XE",
                "system", "manager"
            );

            String sql = "UPDATE appointment SET status=? WHERE appointment_id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, status);
            ps.setString(2, appointmentId);
            ps.executeUpdate();

            con.close();

            response.sendRedirect("pendingapp.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
