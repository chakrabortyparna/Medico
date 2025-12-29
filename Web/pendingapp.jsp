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
        .action-btn {
            padding: 6px 12px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            color: white;
        }
        .approve {
            background: #28a745;
        }
        .reject {
            background: #dc3545;
        }
    </style>
</head>

<body>

<h2>Pending Appointments</h2>

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
        <th>Action</th>
    </tr>

<%
try {
    Class.forName("oracle.jdbc.driver.OracleDriver");

    Connection con = DriverManager.getConnection(
        "jdbc:oracle:thin:@localhost:1521:XE",
        "system", "manager"
    );

    /* If doctor login is implemented, you can filter by doctor_id
       String doctorId = (String) session.getAttribute("doctor_id");
       String sql = "SELECT * FROM appointment WHERE status='pending' AND doctor_id=?";
    */

    String sql = "SELECT appointment_id, patient_id, doctor_id, symptoms, appointment_date, fee, status, booked_date FROM appointment WHERE status='pending'";
    PreparedStatement ps = con.prepareStatement(sql);
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
        <td>
            <form action="approveappointment" method="post" style="display:inline;">
                <input type="hidden" name="appointment_id" value="<%= rs.getString("appointment_id") %>">
                <input type="hidden" name="status" value="APPROVED">
                <button class="action-btn approve">Approve</button>
            </form>

            <form action="approveappointment" method="post" style="display:inline;">
                <input type="hidden" name="appointment_id" value="<%= rs.getString("appointment_id") %>">
                <input type="hidden" name="status" value="REJECTED">
                <button class="action-btn reject">Reject</button>
            </form>
        </td>
    </tr>
<%
    }

    if (!found) {
%>
    <tr>
        <td colspan="9">No pending appointments found</td>
    </tr>
<%
    }

    con.close();
} catch (Exception e) {
%>
    <tr>
        <td colspan="9">Error: <%= e.getMessage() %></td>
    </tr>
<%
}
%>

</table>

</body>
</html>
