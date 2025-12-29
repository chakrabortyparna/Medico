<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
<title>Doctor Commission</title>

<style>
body{
    font-family:Arial;
    background:#f0f2f5;
    padding:20px
}
h2{
    text-align:center;
    color:#0b5ed7
}
table{
    width:100%;
    border-collapse:collapse;
    background:#fff;
    margin-top:20px
}
th,td{
    border:1px solid #ccc;
    padding:10px;
    text-align:center
}
th{
    background:#0b5ed7;
    color:#fff
}
tr:nth-child(even){
    background:#f9f9f9
}
.pay-btn{
    background:#198754;
    color:#fff;
    border:none;
    padding:6px 14px;
    border-radius:6px;
    cursor:pointer
}
</style>

</head>
<body>

<h2>Doctor Commission Details</h2>

<table>
<tr>
<th>Doctor ID</th>
<th>Doctor Name</th>
<th>Approved Patients</th>
<th>Fee / Patient</th>
<th>Total Earnings</th>
<th>Admin Commission %</th>
<th>Commission Amount</th>
<th>Action</th>
</tr>

<%
Connection con=null;
PreparedStatement psDoctor=null;
PreparedStatement psCount=null;
ResultSet rsDoctor=null;
ResultSet rsCount=null;

double adminCommission = 20;   // 10% Admin Commission

try{
    Class.forName("oracle.jdbc.driver.OracleDriver");
    con=DriverManager.getConnection(
        "jdbc:oracle:thin:@localhost:1521:XE",
        "system","manager"
    );

    psDoctor=con.prepareStatement(
        "SELECT doctor_id, full_name, fee_per_patient FROM doctor"
    );
    rsDoctor=psDoctor.executeQuery();

    boolean found=false;

    while(rsDoctor.next()){
        found=true;

        String doctorId=rsDoctor.getString("doctor_id");
        String doctorName=rsDoctor.getString("full_name");
        double fee=rsDoctor.getDouble("fee_per_patient");

        psCount=con.prepareStatement(
            "SELECT COUNT(*) FROM appointment WHERE doctor_id=? AND status='APPROVED'"
        );
        psCount.setString(1,doctorId);
        rsCount=psCount.executeQuery();

        int approved=0;
        if(rsCount.next()){
            approved=rsCount.getInt(1);
        }

        double totalEarning=approved*fee;
        double commissionAmount=(totalEarning*adminCommission)/100;
%>

<tr>
<td><%=doctorId%></td>
<td><%=doctorName%></td>
<td><%=approved%></td>
<td> <%=fee%></td>
<td><%=totalEarning%></td>
<td><%=adminCommission%>%</td>
<td><b> <%=commissionAmount%></b></td>

<td>
<form action="pay.jsp" method="post">
    <input type="hidden" name="doctor_id" value="<%=doctorId%>">
    <input type="hidden" name="doctor_name" value="<%=doctorName%>">
    <input type="hidden" name="amount" value="<%=commissionAmount%>">
    <button class="pay-btn">Pay</button>
</form>
</td>
</tr>

<%
        rsCount.close();
        psCount.close();
    }

    if(!found){
%>
<tr>
<td colspan="8">No doctors found</td>
</tr>
<%
    }

}catch(Exception e){
%>
<tr>
<td colspan="8">Error: <%=e.getMessage()%></td>
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
