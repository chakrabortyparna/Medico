<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
String doctorId = request.getParameter("doctor_id");
String amount = request.getParameter("amount");

if (doctorId == null || amount == null) {
    response.sendRedirect("doctordashboard.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Doctor Commission Payment</title>

<style>
body{
    font-family:Arial;
    background:#f0f2f5;
    min-height:100vh;
    display:flex;
    align-items:center;
    justify-content:center;
}
.box{
    width:100%;
    max-width:420px;
    background:white;
    padding:25px;
    border-radius:8px;
    box-shadow:0 0 10px rgba(0,0,0,0.15);
}
h2{
    text-align:center;
    margin-bottom:20px;
}
p{
    font-size:16px;
    margin:10px 0;
}
button{
    width:100%;
    padding:10px;
    margin-top:10px;
    font-size:15px;
    border:none;
    border-radius:5px;
    cursor:pointer;
}
.pay{
    background:#0b5ed7;
    color:white;
}
.pay:hover{
    background:#094db1;
}
.back{
    background:#6c757d;
    color:white;
}
.back:hover{
    background:#5a6268;
}
</style>
</head>

<body>

<div class="box">
<h2>Commission Payment</h2>

<p><b>Doctor ID:</b> <%=doctorId%></p>
<p><b>Amount to Pay:</b> ₹ <%=amount%></p>

<!-- PAY BUTTON -->
<form action="payment_success.html" method="post">
    <input type="hidden" name="doctor_id" value="<%=doctorId%>">
    <input type="hidden" name="amount" value="<%=amount%>">
    <button class="pay">Pay Now</button>
</form>

<!-- BACK BUTTON -->
<button class="back" onclick="window.history.back()">Back</button>

</div>

</body>
</html>
