import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class saveprescription extends HttpServlet {

    public void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        res.setContentType("text/html");
        PrintWriter out = res.getWriter();

        // Get form parameters
        String appointmentId = req.getParameter("appointment_id");
        String doctorId = req.getParameter("doctor_id");
        String doctorName = req.getParameter("full_name");
        String patientId = req.getParameter("patient_id");
        String patientName = req.getParameter("name");
        String ageStr = req.getParameter("age");
        String symptoms = req.getParameter("symptoms");
        String diagnosis = req.getParameter("diagnosis");
        String medicines = req.getParameter("medicines");
        String notes = req.getParameter("notes");

        int age = 0;
        if (ageStr != null && !ageStr.isEmpty()) {
            age = Integer.parseInt(ageStr);
        }

        // Generate unique prescription ID
        String prescriptionId = "PRSC" + System.currentTimeMillis();

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection con = DriverManager.getConnection(
                    "jdbc:oracle:thin:@localhost:1521:XE", "system", "manager");

            String sql = "INSERT INTO prescription (prescription_id, appointment_id, doctor_id, full_name, "
                    + "patient_id, name, age, symptoms, diagnosis, medicines, notes, prescribed_date) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, SYSDATE)";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, prescriptionId);
            ps.setString(2, appointmentId);
            ps.setString(3, doctorId);
            ps.setString(4, doctorName);
            ps.setString(5, patientId);
            ps.setString(6, patientName);
            ps.setInt(7, age);
            ps.setString(8, symptoms);
            ps.setString(9, diagnosis);
            ps.setString(10, medicines);
            ps.setString(11, notes);

            int x = ps.executeUpdate();

            if (x > 0) {
                out.println("<html><body>");
                out.println("<h3>Prescription saved successfully!</h3>");
                out.println("<a href='doctorDashboard.jsp'>Back to Dashboard</a>");
                out.println("</body></html>");
            } else {
                out.println("<html><body>");
                out.println("<h3 style='color:red;'>Failed to save prescription!</h3>");
                out.println("<a href='writePrescription.jsp?appointment_id=" + appointmentId + "'>Try Again</a>");
                out.println("</body></html>");
            }

            con.close();

        } catch (Exception e) {
            out.println("<h4 style='color:red'>Error: " + e + "</h4>");
            e.printStackTrace();
        }
    }
}