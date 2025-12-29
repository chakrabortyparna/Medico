<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<!DOCTYPE html>
<html>
<head>
    <title>All Registered Patients</title>

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

<h2>Registered Patients</h2>

<table>
    <tr>
        <th>Patient ID</th>
        <th>Name</th>
        <th>Email</th>
        <th>Address</th>
        <th>Date of Birth</th>
        <th>Medical History</th>
        <th>Phone</th>
        <th>Gender</th>
        <th>Registered Date</th>
    </tr>

<%
try {
    Class.forName("oracle.jdbc.driver.OracleDriver");

    Connection con = DriverManager.getConnection(
        "jdbc:oracle:thin:@localhost:1521:XE",
        "system", "manager"
    );

    String sql = "SELECT patient_id, name, email, address, dob, medical_history, phone, gender, created_date FROM patient";
    PreparedStatement ps = con.prepareStatement(sql);
    ResultSet rs = ps.executeQuery();

    boolean found = false;

    while (rs.next()) {
        found = true;
%>
    <tr>
        <td><%= rs.getString("patient_id") %></td>
        <td><%= rs.getString("name") %></td>
        <td><%= rs.getString("email") %></td>
        <td><%= rs.getString("address") %></td>
        <td><%= rs.getDate("dob") %></td>
        <td><%= rs.getString("medical_history") %></td>
        <td><%= rs.getString("phone") %></td>
        <td><%= rs.getString("gender") %></td>
        <td><%= rs.getDate("created_date") %></td>
    </tr>
<%
    }

    if (!found) {
%>
    <tr>
        <td colspan="9">No patient records found</td>
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
