<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>View Prescriptions</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f0f2f5;
            padding: 20px;
        }

        h2 {
            text-align: center;
            margin-bottom: 10px;
        }

        /* CENTER DROPDOWN */
        .filter-box{
            text-align:center;
            margin:20px 0;
        }

        select{
            padding:8px 14px;
            font-size:14px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            box-shadow: 0 0 12px rgba(0,0,0,0.15);
        }

        th, td {
            border: 1px solid #ccc;
            padding: 10px;
            font-size: 14px;
            text-align: left;
        }

        th {
            background: #0b5ed7;
            color: white;
        }

        tr:nth-child(even) {
            background: #f9f9f9;
        }

        .no-data {
            text-align: center;
            color: red;
            font-size: 16px;
            margin-top: 20px;
        }

        .btn-bar {
            margin-top: 20px;
            display: flex;
            justify-content: space-between;
        }

        .btn {
            padding: 10px 18px;
            background: #0b5ed7;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-size: 14px;
        }

        .btn.back {
            background: #6c757d;
        }
    </style>
</head>

<body>

<h2>My Prescriptions</h2>

<%
String patientId = (String) session.getAttribute("patient_id");
String selectedAppointment = request.getParameter("appointment_id");

if (patientId == null) {
%>
    <p class="no-data">
        Session expired. Please <a href="patient-login.html">login again</a>.
    </p>
<%
} else {
%>

<!-- ? CENTERED APPOINTMENT DROPDOWN -->
<div class="filter-box">
<form method="get">
    <b>Select Appointment ID :</b>
    <select name="appointment_id" onchange="this.form.submit()">
        <option value="">-- Select Appointment --</option>

<%
    try{
        Class.forName("oracle.jdbc.driver.OracleDriver");
        Connection con1 = DriverManager.getConnection(
            "jdbc:oracle:thin:@localhost:1521:XE",
            "system","manager"
        );

        PreparedStatement psApp = con1.prepareStatement(
            "SELECT DISTINCT appointment_id FROM prescription WHERE patient_id=?"
        );
        psApp.setString(1, patientId);
        ResultSet rsApp = psApp.executeQuery();

        while(rsApp.next()){
            String aid = rsApp.getString("appointment_id");
%>
        <option value="<%=aid%>" <%=aid.equals(selectedAppointment)?"selected":""%>>
            <%=aid%>
        </option>
<%
        }
        con1.close();
    }catch(Exception e){}
%>
    </select>
</form>
</div>

<%
    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        Connection con = DriverManager.getConnection(
            "jdbc:oracle:thin:@localhost:1521:XE",
            "system", "manager"
        );

        String sql =
            "SELECT prescription_id, appointment_id, doctor_id, full_name, " +
            "patient_id, name, symptoms, diagnosis, medicines, notes, " +
            "TO_CHAR(prescribed_date,'DD-MON-YYYY') AS pdate " +
            "FROM prescription WHERE patient_id=?";

        if(selectedAppointment != null && !selectedAppointment.equals("")){
            sql += " AND appointment_id=?";
        }

        sql += " ORDER BY prescribed_date DESC";

        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, patientId);

        if(selectedAppointment != null && !selectedAppointment.equals("")){
            ps.setString(2, selectedAppointment);
        }

        ResultSet rs = ps.executeQuery();

        if (!rs.isBeforeFirst()) {
%>
            <p class="no-data">No prescriptions available.</p>
<%
        } else {
%>

<table>
<tr>
    <th>Prescription ID</th>
    <th>Appointment ID</th>
    <th>Doctor ID</th>
    <th>Doctor Name</th>
    <th>Patient ID</th>
    <th>Patient Name</th>
    <th>Symptoms</th>
    <th>Diagnosis</th>
    <th>Medicines</th>
    <th>Notes</th>
    <th>Date</th>
</tr>

<%
        while(rs.next()){
%>
<tr>
    <td><%=rs.getString("prescription_id")%></td>
    <td><%=rs.getString("appointment_id")%></td>
    <td><%=rs.getString("doctor_id")%></td>
    <td><%=rs.getString("full_name")%></td>
    <td><%=rs.getString("patient_id")%></td>
    <td><%=rs.getString("name")%></td>
    <td><%=rs.getString("symptoms")%></td>
    <td><%=rs.getString("diagnosis")%></td>
    <td><%=rs.getString("medicines")%></td>
    <td><%=rs.getString("notes")%></td>
    <td><%=rs.getString("pdate")%></td>
</tr>
<%
        }
%>
</table>

<div class="btn-bar">
    <a href="patientdashboard.jsp" class="btn back">Back</a>
    <a href="pharmacy.html" class="btn">Go to Pharmacy</a>
</div>

<%
        }
        con.close();
    } catch (Exception e) {
%>
        <p class="no-data">Error: <%= e.getMessage() %></p>
<%
    }
}
%>

</body>
</html>
