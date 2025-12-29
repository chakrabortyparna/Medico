import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class appointment extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        res.setContentType("text/html");
        PrintWriter out = res.getWriter();

        // Fetch form values
        String appointmentId = req.getParameter("appointment_id");
        String patientId = req.getParameter("patient_id");
        String doctorId = req.getParameter("doctor_id");
        String symptoms = req.getParameter("symptoms");
        String appointmentDate = req.getParameter("appointment_date");
        String feeStr = req.getParameter("fee");

        try {
            double fee = Double.parseDouble(feeStr);

            // Load Oracle Driver
            Class.forName("oracle.jdbc.driver.OracleDriver");

            // DB Connection
            Connection con = DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521:XE",
                "system", "manager"
            );

            // SQL Insert Query
            String sql = "INSERT INTO appointment " +
                         "(appointment_id, patient_id, doctor_id, symptoms, appointment_date, fee) " +
                         "VALUES (?, ?, ?, ?, TO_DATE(?,'YYYY-MM-DD'), ?)";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, appointmentId);
            ps.setString(2, patientId);
            ps.setString(3, doctorId);
            ps.setString(4, symptoms);
            ps.setString(5, appointmentDate);
            ps.setDouble(6, fee);

            int result = ps.executeUpdate();

            if (result > 0) {
                out.println("<html><body style='font-family:Arial;'>");
                out.println("<h2>✅ Appointment Booked Successfully. Wait for approved appointment</h2>");
                out.println("<p>Appointment ID: <b>" + appointmentId + "</b></p>");
                out.println("<a href='patientdashboard.jsp'>Back to Dashboard</a>");
                out.println("</body></html>");
            } else {
                out.println("<h3>❌ Appointment Booking Failed</h3>");
            }

            con.close();

        } catch (Exception e) {
            out.println("<h3>Error Occurred:</h3>");
            out.println("<pre>" + e + "</pre>");
        }
    }
}
