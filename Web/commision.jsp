<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<!DOCTYPE html>
<html>
<head>
<title>Doctor Commission</title>

<style>
body{font-family:Arial;background:#f0f2f5;padding:20px}
h2{text-align:center;color:#0b5ed7}
table{width:100%;border-collapse:collapse;background:#fff;margin-top:20px}
th,td{border:1px solid #ccc;padding:10px;text-align:center}
th{background:#0b5ed7;color:#fff}
tr:nth-child(even){background:#f9f9f9}

/* CENTER DROPDOWN */
.filter-box{
    text-align:center;
    margin:20px 0;
}
select{
    padding:8px 14px;
    font-size:14px;
}
</style>

</head>
<body>

<h2>Doctor Commission Calculation</h2>

<!-- ? CENTERED DOCTOR DROPDOWN -->
<div class="filter-box">
<form method="get">
    <b>Select Doctor :</b>
    <select name="doctor_id" onchange="this.form.submit()">
        <option value="">-- Select Doctor --</option>

<%
Connection con1 = null;
PreparedStatement psList = null;
ResultSet rsList = null;

try{
    Class.forName("oracle.jdbc.driver.OracleDriver");
    con1 = DriverManager.getConnection(
        "jdbc:oracle:thin:@localhost:1521:xe",
        "system","manager"
    );

    psList = con1.prepareStatement("SELECT doctor_id FROM doctor");
    rsList = psList.executeQuery();

    while(rsList.next()){
        String did = rsList.getString("doctor_id");
%>
        <option value="<%=did%>" <%=did.equals(request.getParameter("doctor_id"))?"selected":""%>>
            <%=did%>
        </option>
<%
    }
}catch(Exception e){}
finally{
    try{if(rsList!=null)rsList.close();}catch(Exception e){}
    try{if(psList!=null)psList.close();}catch(Exception e){}
    try{if(con1!=null)con1.close();}catch(Exception e){}
}
%>
    </select>
</form>
</div>

<table>
<tr>
<th>Doctor ID</th>
<th>Doctor Name</th>
<th>Approved Patients</th>
<th>Fee / Patient</th>
<th>Total Earnings</th>
<th>Commission %</th>
<th>Commission Amount</th>
</tr>

<%
Connection con = null;
PreparedStatement psDoctor = null;
PreparedStatement psCount = null;
ResultSet rsDoctor = null;
ResultSet rsCount = null;

double commissionPercent = 20;
String selectedDoctor = request.getParameter("doctor_id");

try{
    Class.forName("oracle.jdbc.driver.OracleDriver");
    con = DriverManager.getConnection(
        "jdbc:oracle:thin:@localhost:1521:xe",
        "system","manager"
    );

    if(selectedDoctor != null && !selectedDoctor.equals("")){
        psDoctor = con.prepareStatement(
            "SELECT doctor_id, full_name, fee_per_patient FROM doctor WHERE doctor_id=?"
        );
        psDoctor.setString(1, selectedDoctor);
    } else {
        psDoctor = con.prepareStatement(
            "SELECT doctor_id, full_name, fee_per_patient FROM doctor"
        );
    }

    rsDoctor = psDoctor.executeQuery();
    boolean found = false;

    while(rsDoctor.next()){
        found = true;

        String doctorId = rsDoctor.getString("doctor_id");
        String doctorName = rsDoctor.getString("full_name");
        double fee = rsDoctor.getDouble("fee_per_patient");

        psCount = con.prepareStatement(
            "SELECT COUNT(*) FROM appointment WHERE doctor_id=? AND status='APPROVED'"
        );
        psCount.setString(1, doctorId);
        rsCount = psCount.executeQuery();

        int approvedPatients = 0;
        if(rsCount.next()){
            approvedPatients = rsCount.getInt(1);
        }

        double totalEarning = approvedPatients * fee;
        double commissionAmount = (totalEarning * commissionPercent) / 100;
%>

<tr>
<td><%=doctorId%></td>
<td><%=doctorName%></td>
<td><%=approvedPatients%></td>
<td><%=fee%></td>
<td><%=totalEarning%></td>
<td><%=commissionPercent%>%</td>
<td><b><%=commissionAmount%></b></td>
</tr>

<%
        rsCount.close();
        psCount.close();
    }

    if(!found){
%>
<tr>
<td colspan="7">No data found</td>
</tr>
<%
    }

}catch(Exception e){
%>
<tr>
<td colspan="7">Error: <%=e.getMessage()%></td>
</tr>
<%
}finally{
try{if(rsDoctor!=null)rsDoctor.close();}catch(Exception e){}
try{if(psDoctor!=null)psDoctor.close();}catch(Exception e){}
try{if(con!=null)con.close();}catch(Exception e){}
}
%>

</table>

</body>
</html>
