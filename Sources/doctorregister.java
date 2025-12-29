import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class doctorregister extends HttpServlet {
    public void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException {

        res.setContentType("text/html");
        PrintWriter out = res.getWriter();

        // Get parameters from form
        String doctorId = req.getParameter("doctorId");
        String fullName = req.getParameter("name");
        String password = req.getParameter("password");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String licenseNumber = req.getParameter("license");
        String specialization = req.getParameter("specialisation");
        String qualification = req.getParameter("qualification");
        String clinicName = req.getParameter("clinicName");
        String feeStr = req.getParameter("fees");
        String schedule = req.getParameter("schedule");

        try {
            double fee = Double.parseDouble(feeStr);

            // Load Oracle JDBC Driver
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection con = DriverManager.getConnection(
                    "jdbc:oracle:thin:@localhost:1521:XE", "system", "manager");

            // Use PreparedStatement to prevent SQL injection
            String sql = "INSERT INTO doctor (doctor_id, full_name, password, email, phone, license_number, specialization, qualification, clinic_name, fee_per_patient, weekly_schedule) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, doctorId);
            ps.setString(2, fullName);
            ps.setString(3, password);
            ps.setString(4, email);
            ps.setString(5, phone);
            ps.setString(6, licenseNumber);
            ps.setString(7, specialization);
            ps.setString(8, qualification);
            ps.setString(9, clinicName);
            ps.setDouble(10, fee);
            ps.setString(11, schedule);

            int x = ps.executeUpdate();
            if (x > 0) {
                out.println("<html><body>Registration successful! <br>");
                out.println("<a href='doctor-login.html'>Go to Login Page</a></body></html>");
            } else {
                out.println("Registration failed!");
            }

            con.close();
        } catch (Exception e) {
            out.println("Error: " + e);
        }
    }
}
