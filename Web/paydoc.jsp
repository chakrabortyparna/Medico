<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<title>Check Appointment Status</title>

<style>
body{
    font-family:Arial;
    background:#f0f2f5;
    min-height:100vh;
    display:flex;
    align-items:center;
    justify-content:center
}
.box{
    width:100%;
    max-width:520px;
    background:white;
    padding:22px;
    border-radius:8px;
    box-shadow:0 0 10px rgba(0,0,0,0.15)
}
h2{text-align:center;margin-bottom:18px}
label{font-weight:bold;font-size:14px}
input{
    width:100%;
    padding:8px;
    margin:6px 0 12px;
    border-radius:4px;
    border:1px solid #ccc
}
button{
    width:100%;
    padding:10px;
    background:#0b5ed7;
    color:white;
    border:none;
    border-radius:5px;
    font-size:15px;
    cursor:pointer;
    margin-top:6px
}
button:hover{background:#094db1}
.back{
    background:#6c757d
}
.back:hover{background:#5a6268}
.result{
    margin-top:16px;
    background:#f8f9fa;
    padding:14px;
    border-radius:6px
}
.error{
    color:red;
    text-align:center;
    margin-top:12px
}
.pending{color:orange;font-weight:bold}
.approved{color:green;font-weight:bold}
.rejected{color:red;font-weight:bold}
</style>

</head>

<body>

<div class="box">
<h2>Check Appointment Status</h2>

<form method="post">
    <label>Appointment ID</label>
    <input type="text" name="appointment_id" required>

    <label>Patient ID</label>
    <input type="text" name="patient_id" required>

    <button type="submit">Check Status</button>
</form>

<%
if("POST".equalsIgnoreCase(request.getMethod())){

    String appointmentId = request.getParameter("appointment_id");
    String patientId = request.getParameter("patient_id");

    try{
        Class.forName("oracle.jdbc.driver.OracleDriver");
        Connection con = DriverManager.getConnection(
            "jdbc:oracle:thin:@localhost:1521:XE",
            "system","manager"
        );

        String sql =
            "SELECT doctor_id, appointment_date, symptoms, status, fee " +
            "FROM appointment WHERE appointment_id=? AND patient_id=?";

        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, appointmentId);
        ps.setString(2, patientId);

        ResultSet rs = ps.executeQuery();

        if(rs.next()){
            String status = rs.getString("status");
%>

<div class="result">
<p><b>Appointment ID:</b> <%=appointmentId%></p>
<p><b>Patient ID:</b> <%=patientId%></p>
<p><b>Doctor ID:</b> <%=rs.getString("doctor_id")%></p>
<p><b>Date:</b> <%=rs.getDate("appointment_date")%></p>
<p><b>Symptoms:</b> <%=rs.getString("symptoms")%></p>

<p>
<b>Status:</b>
<span class="<%=status.toLowerCase()%>">
<%=status%>
</span>
</p>

<p><b>Fee:</b> <%=rs.getDouble("fee")%></p>

<%
    // SHOW PAY BUTTON ONLY IF STATUS = PENDING
    if("PENDING".equalsIgnoreCase(status)){
%>

<form action="payment.jsp" method="post">
    <input type="hidden" name="appointment_id" value="<%=appointmentId%>">
    <input type="hidden" name="patient_id" value="<%=patientId%>">
    <input type="hidden" name="amount" value="<%=rs.getDouble("fee")%>">
    <button>Pay Now</button>
</form>

<%
    }
%>

<button class="back" onclick="window.history.back()">Back</button>
</div>

<%
        }else{
%>
<div class="error">No appointment found</div>
<%
        }
        con.close();
    }catch(Exception e){
%>
<div class="error"><%=e.getMessage()%></div>
<%
    }
}
%>

</div>
</body>
</html>
