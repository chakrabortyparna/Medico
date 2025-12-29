import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class doctorlogin extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        res.setContentType("text/html");
        PrintWriter out = res.getWriter();

        // Get form parameters
        String doctorId = req.getParameter("doctorId");
        String password = req.getParameter("password");

        try {
            // Load Oracle JDBC Driver
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection con = DriverManager.getConnection(
                    "jdbc:oracle:thin:@localhost:1521:XE", "system", "manager");

            // Prepare SQL to check credentials
            String sql = "SELECT * FROM doctor WHERE doctor_id = ? AND password = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, doctorId);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // Login successful -> redirect to dashboard JSP
                HttpSession session = req.getSession();
                session.setAttribute("doctorId", doctorId);
                session.setAttribute("doctorName", rs.getString("full_name"));
                res.sendRedirect("doctordashboard.jsp");
            } else {
                // Login failed -> show error message
                out.println("<html><body>");
                out.println("<h3>Invalid Doctor ID or Password!</h3>");
                out.println("<a href='doctor-login.html'>Try Again</a>");
                out.println("</body></html>");
            }

            con.close();

        } catch (Exception e) {
            out.println("Error: " + e);
        }
    }

    // Optionally handle GET requests to redirect to login page
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        res.sendRedirect("doctor-login.html");
    }
}
