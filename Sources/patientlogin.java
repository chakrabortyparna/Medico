import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class patientlogin extends HttpServlet {

    public void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException {

        res.setContentType("text/html");
        PrintWriter out = res.getWriter();

        String patientId = req.getParameter("patient_id");
        String password = req.getParameter("password");

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");

            Connection con = DriverManager.getConnection(
                    "jdbc:oracle:thin:@localhost:1521:XE",
                    "system",
                    "manager");

            String sql = "SELECT * FROM patient WHERE patient_id=? AND password=?";
            PreparedStatement pst = con.prepareStatement(sql);

            pst.setString(1, patientId);
            pst.setString(2, password);

            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                // Login Success → open dashboard
                HttpSession session = req.getSession();
                session.setAttribute("patient_id", patientId);
                session.setAttribute("patient_name", rs.getString("name"));
                res.sendRedirect("patientdashboard.jsp");
            } else {
                out.println("<html><body>");
                out.println("<h3 style='color:red;'>Invalid Patient ID or Password</h3>");
                out.println("<a href='patient-login.html'>Try Again</a>");
                out.println("</body></html>");
            }

            con.close();

        } catch (Exception e) {
            out.println("<h3>Error: " + e + "</h3>");
        }
    }
}
