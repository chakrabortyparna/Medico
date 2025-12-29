import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class patientregister extends HttpServlet {

    public void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException {

        res.setContentType("text/html");
        PrintWriter out = res.getWriter();

        String p_id = req.getParameter("patient_id");
        String name = req.getParameter("name");
        String password = req.getParameter("password");
        String email = req.getParameter("email");
        String address = req.getParameter("address");
        String dob = req.getParameter("dob");
        String history = req.getParameter("medical_history");
        String phone = req.getParameter("phone");
        String gender = req.getParameter("gender");

        try {
            // Load Oracle JDBC Driver
            Class.forName("oracle.jdbc.driver.OracleDriver");

            Connection con = DriverManager.getConnection(
                    "jdbc:oracle:thin:@localhost:1521:XE",
                    "system",
                    "manager");

            String sql = "INSERT INTO PATIENT "
                    + "(PATIENT_ID, NAME, PASSWORD, EMAIL, ADDRESS, DOB, MEDICAL_HISTORY, PHONE, GENDER) "
                    + "VALUES (?, ?, ?, ?, ?, TO_DATE(?,'YYYY-MM-DD'), ?, ?, ?)";

            PreparedStatement pst = con.prepareStatement(sql);

            pst.setString(1, p_id);
            pst.setString(2, name);
            pst.setString(3, password);
            pst.setString(4, email);
            pst.setString(5, address);
            pst.setString(6, dob);
            pst.setString(7, history);
            pst.setString(8, phone);
            pst.setString(9, gender);

            int x = pst.executeUpdate();

            if (x > 0) {
                out.println("<html><body style='font-family:Arial;'>");
                out.println("<h2>Patient Registration Successful</h2>");
                out.println("<p>Your Patient ID: <b>" + p_id + "</b></p>");
                out.println("<a href='patient-login.html'>Go to Login</a>");
                out.println("</body></html>");
            } else {
                out.println("Registration Failed!");
            }

            con.close();

        } catch (Exception e) {
            out.println("<html><body style='font-family:Arial;'>");
                out.println("<h2>Patient Registration Successful</h2>");
                out.println("<p>Your Patient ID: <b>" + p_id + "</b></p>");
                out.println("<a href='patient-login.html'>Go to Login</a>");
                out.println("</body></html>");
        }
    }
}
