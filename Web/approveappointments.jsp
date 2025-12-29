<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Approved Appointments</title>
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
    </style>
</head>
<body>

<h2>Approved Appointments</h2>

<table>
    <tr>
        <th>Appointment ID</th>
        <th>Patient ID</th>
        <th>Symptoms</th>
        <th>Appointment Date</th>
    </tr>

<%
    String doctorId = (String) session.getAttribute("doctorId");

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        Connection con = DriverManager.getConnection(
            "jdbc:oracle:thin:@localhost:1521:XE",
            "system", "manager"
        );

        String sql =
            "SELECT appointment_id, patient_id, symptoms, appointment_date " +
            "FROM appointment WHERE doctor_id=? AND status='APPROVED'";

        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, doctorId);
        ResultSet rs = ps.executeQuery();

        boolean found = false;

        while (rs.next()) {
            found = true;
%>
    <tr>
        <td><%= rs.getString("appointment_id") %></td>
        <td><%= rs.getString("patient_id") %></td>
        <td><%= rs.getString("symptoms") %></td>
        <td><%= rs.getDate("appointment_date") %></td>
    </tr>
<%
        }

        if (!found) {
%>
    <tr>
        <td colspan="4">No approved appointments available</td>
    </tr>
<%
        }

        con.close();
    } catch (Exception e) {
%>
    <tr>
        <td colspan="4">Error: <%= e.getMessage() %></td>
    </tr>
<%
    }
%>

</table>

</body>
</html>
