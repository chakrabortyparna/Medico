<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<!DOCTYPE html>
<html>
<head>
    <title>Pending Appointments</title>

    <style>
        body {
            font-family: Arial;
            background: #f0f2f5;
            padding: 20px;
        }
        h2 {
            text-align: center;
            margin-bottom: 20px;
        }
        form {
            text-align: center;
            margin-bottom: 20px;
        }
        select {
            padding: 8px;
            font-size: 15px;
            border-radius: 5px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
        }
        th, td {
            padding: 12px;
            border: 1px solid #ccc;
            text-align: center;
        }
        th {
            background: #0b5ed7;
            color: white;
        }
        tr:hover {
            background-color: #f1f1f1;
        }
    </style>
</head>

<body>

<h2>Pending Appointments</h2>

<!-- DOCTOR DROPDOWN -->
<form method="get">
    <label><b>Select Doctor:</b></label>
    <select name="doctor_id" onchange="this.form.submit()" required>
        <option value="">-- Select Doctor --</option>

        <%
        String selectedDoctor = request.getParameter("doctor_id");

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection con2 = DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521:XE",
                "system", "manager"
            );

            Statement st2 = con2.createStatement();
            ResultSet rs2 = st2.executeQuery("SELECT doctor_id FROM doctor");

            while (rs2.next()) {
                String did = rs2.getString("doctor_id");
        %>
            <option value="<%= did %>" <%= did.equals(selectedDoctor) ? "selected" : "" %>>
                <%= did %>
            </option>
        <%
            }
            con2.close();
        } catch (Exception e) {
            out.println("<option>Error loading doctors</option>");
        }
        %>
    </select>
</form>

<!-- APPOINTMENT TABLE -->
<table>
    <tr>
        <th>Appointment ID</th>
        <th>Patient ID</th>
        <th>Doctor ID</th>
        <th>Symptoms</th>
        <th>Appointment Date</th>
        <th>Fee</th>
        <th>Status</th>
        <th>Booked Date</th>
    </tr>

<%
try {
    Class.forName("oracle.jdbc.driver.OracleDriver");

    Connection con = DriverManager.getConnection(
        "jdbc:oracle:thin:@localhost:1521:XE",
        "system", "manager"
    );

    String sql = "SELECT appointment_id, patient_id, doctor_id, symptoms, appointment_date, fee, status, booked_date FROM appointment WHERE status='pending'";
    PreparedStatement ps;

    if (selectedDoctor != null && !selectedDoctor.isEmpty()) {
        sql += " AND doctor_id=?";
        ps = con.prepareStatement(sql);
        ps.setString(1, selectedDoctor);
    } else {
        ps = con.prepareStatement(sql);
    }

    ResultSet rs = ps.executeQuery();
    boolean found = false;

    while (rs.next()) {
        found = true;
%>
    <tr>
        <td><%= rs.getString("appointment_id") %></td>
        <td><%= rs.getString("patient_id") %></td>
        <td><%= rs.getString("doctor_id") %></td>
        <td><%= rs.getString("symptoms") %></td>
        <td><%= rs.getDate("appointment_date") %></td>
        <td><%= rs.getDouble("fee") %></td>
        <td><%= rs.getString("status") %></td>
        <td><%= rs.getDate("booked_date") %></td>
    </tr>
<%
    }

    if (!found) {
%>
    <tr>
        <td colspan="8">No pending appointments found</td>
    </tr>
<%
    }

    con.close();
} catch (Exception e) {
%>
    <tr>
        <td colspan="8">Error: <%= e.getMessage() %></td>
    </tr>
<%
}
%>

</table>

</body>
</html>
