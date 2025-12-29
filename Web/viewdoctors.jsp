<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<!DOCTYPE html>
<html>
<head>
    <title>All Registered Doctors</title>

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
        tr:hover {
            background-color: #f1f1f1;
        }
    </style>
</head>

<body>

<h2>Registered Doctors</h2>

<table>
    <tr>
        <th>Doctor ID</th>
        <th>Full Name</th>
        <th>Email</th>
        <th>Phone</th>
        <th>License Number</th>
        <th>Specialization</th>
        <th>Qualification</th>
        <th>Clinic Name</th>
        <th>Fee Per Patient</th>
        <th>Weekly Schedule</th>
    </tr>

<%
try {
    Class.forName("oracle.jdbc.driver.OracleDriver");

    Connection con = DriverManager.getConnection(
        "jdbc:oracle:thin:@localhost:1521:XE",
        "system", "manager"
    );

    String sql = "SELECT doctor_id, full_name, email, phone, license_number, specialization, qualification, clinic_name, fee_per_patient, weekly_schedule FROM doctor";
    PreparedStatement ps = con.prepareStatement(sql);
    ResultSet rs = ps.executeQuery();

    boolean found = false;

    while (rs.next()) {
        found = true;
%>
    <tr>
        <td><%= rs.getString("doctor_id") %></td>
        <td><%= rs.getString("full_name") %></td>
        <td><%= rs.getString("email") %></td>
        <td><%= rs.getString("phone") %></td>
        <td><%= rs.getString("license_number") %></td>
        <td><%= rs.getString("specialization") %></td>
        <td><%= rs.getString("qualification") %></td>
        <td><%= rs.getString("clinic_name") %></td>
        <td><%= rs.getDouble("fee_per_patient") %></td>
        <td><%= rs.getString("weekly_schedule") %></td>
    </tr>
<%
    }

    if (!found) {
%>
    <tr>
        <td colspan="10">No doctor records found</td>
    </tr>
<%
    }

    con.close();
} catch (Exception e) {
%>
    <tr>
        <td colspan="10">Error: <%= e.getMessage() %></td>
    </tr>
<%
}
%>

</table>

</body>
</html>
