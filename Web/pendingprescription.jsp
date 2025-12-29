<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Pending Prescriptions</title>
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
        button {
            padding: 8px 14px;
            background: #198754;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        button:hover {
            background: #157347;
        }
    </style>
</head>
<body>

<h2>Pending Prescriptions</h2>

<table>
    <tr>
        <th>Appointment ID</th>
        <th>Patient ID</th>
        <th>Symptoms</th>
        <th>Appointment Date</th>
        <th>Action</th>
    </tr>

<%
String doctorId = (String) session.getAttribute("doctorId");

try {
    Class.forName("oracle.jdbc.driver.OracleDriver");
    Connection con = DriverManager.getConnection(
        "jdbc:oracle:thin:@localhost:1521:XE",
        "system", "manager");

    String sql = "SELECT appointment_id, patient_id, symptoms, appointment_date " +
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
        <td>
            <form action="writeprescription.jsp" method="get">
                <input type="hidden" name="appointment_id"
                       value="<%= rs.getString("appointment_id") %>">
                <input type="hidden" name="patient_id"
                       value="<%= rs.getString("patient_id") %>">
                <button type="submit">Write</button>
            </form>
        </td>
    </tr>
<%
    }

    if (!found) {
%>
    <tr>
        <td colspan="5">No approved appointments available</td>
    </tr>
<%
    }

    con.close();
} catch (Exception e) {
%>
    <tr>
        <td colspan="5">Error: <%= e %></td>
    </tr>
<%
}
%>

</table>

</body>
</html>
