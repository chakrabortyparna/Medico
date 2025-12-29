<!DOCTYPE html>
<html>
<head>
<title>Appointment Payment</title>

<style>
body{
    font-family:Arial;
    background:#f0f2f5;
    display:flex;
    justify-content:center;
    align-items:center;
    height:100vh
}
.paybox{
    background:white;
    padding:25px;
    width:380px;
    border-radius:8px;
    box-shadow:0 0 10px rgba(0,0,0,0.15);
    text-align:center
}
h2{margin-bottom:15px}
.qr{
    width:200px;
    height:200px;
    background:#e9ecef;
    margin:15px auto;
    display:flex;
    align-items:center;
    justify-content:center;
    font-weight:bold
}
button{
    width:100%;
    padding:10px;
    background:#198754;
    color:white;
    border:none;
    border-radius:5px;
    font-size:15px;
    cursor:pointer
}
button:hover{background:#157347}
</style>
</head>

<body>

<div class="paybox">
<h2>Payment</h2>

<p><b>Appointment ID:</b> <%=request.getParameter("appointment_id")%></p>
<p><b>Amount:</b> <%=request.getParameter("amount")%></p>

<div class="qr"><img src='https://sp-ao.shortpixel.ai/client/to_webp,q_glossy,ret_img,w_300,h_300/https://prooftag.net/wp-content/uploads/2021/07/QR-Code.png'></div>

<form action="payment_success.html" method="post">
<input type="hidden" name="appointment_id" value="<%=request.getParameter("appointment_id")%>">
<button>Payment Done</button>
</form>

</div>
</body>
</html>
