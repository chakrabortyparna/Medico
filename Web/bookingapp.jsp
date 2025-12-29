<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
<title>Book Appointment</title>

<style>
body {
    margin:0;
    font-family: Arial;
    background:#f0f2f5;
}
.container {
    display: flex;
    min-height: 100vh;
}

/* LEFT SIDEBAR */
.left {
    width: 220px;
    background: #0b5ed7;
    color: white;
    padding: 20px;
}
.left h3 {
    margin-bottom: 30px;
}
.left a {
    display: block;
    padding: 10px;
    background: #0946a0;
    color: white;
    text-decoration: none;
    border-radius: 5px;
}

/* RIGHT CONTENT */
.right {
    flex: 1;
    padding: 30px;
}

.form-box {
    background: white;
    padding: 25px;
    border-radius: 8px;
    box-shadow: 0 0 10px rgba(0,0,0,0.2);
}

/* GRID FORM */
.form-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 15px;
}

label {
    font-weight: bold;
}

input, select, textarea {
    width: 100%;
    padding: 10px;
    border-radius: 5px;
    border: 1px solid #ccc;
}

textarea {
    resize: vertical;
}

.full {
    grid-column: span 2;
}

button {
    margin-top: 20px;
    padding: 12px;
    background: #198754;
    color: white;
    border: none;
    width: 100%;
    font-size: 16px;
    border-radius: 5px;
    cursor: pointer;
}
</style>

<script>
function generateAppointmentId() {
    document.getElementById("appointment_id").value =
        "APT" + Math.floor(100000 + Math.random() * 900000);
}

function fillDoctorDetails() {
    let value = document.getElementById("doctor").value;
    if (value === "") return;

    let d = value.split("|");
    document.getElementById("doctor_id").value = d[0];
    document.getElementById("fee").value = d[2];
}

window.onload = generateAppointmentId;
</script>
</head>

<body>

<div class="container">

<!-- LEFT SIDEBAR -->
<div class="left">
    <h3>Hello,<br><%= session.getAttribute("patient_name") %></h3>
    <a href="landing.html">Logout</a>
</div>

<!-- RIGHT CONTENT -->
<div class="right">
<div class="form-box">
<h2>Book Your Appointment Now</h2>

<form action="appointment" method="post">

<div class="form-grid">

<label>Appointment ID</label>
<input type="text" name="appointment_id" id="appointment_id" readonly>

<label>Patient ID</label>
<input type="text" name="patient_id"
 value="<%= session.getAttribute("patient_id") %>" readonly>

<label>Patient Name</label>
<input type="text"
 value="<%= session.getAttribute("patient_name") %>" readonly>

<label>Doctor Name</label>
<select id="doctor" name="doctor_name" onchange="fillDoctorDetails()" required>
<option value="">Select Doctor</option>

<%
try {
    Class.forName("oracle.jdbc.driver.OracleDriver");
    Connection con = DriverManager.getConnection(
        "jdbc:oracle:thin:@localhost:1521:XE","system","manager");

    Statement st = con.createStatement();
    ResultSet rs = st.executeQuery(
        "SELECT doctor_id, full_name, fee_per_patient FROM doctor");

    while(rs.next()){
%>
<option value="<%= rs.getString("doctor_id") %>|<%= rs.getString("full_name") %>|<%= rs.getString("fee_per_patient") %>">
    <%= rs.getString("full_name") %>
</option>
<%
    }
    con.close();
} catch(Exception e){
    out.println("<option>Error loading doctors</option>");
}
%>

</select>

<label>Doctor ID</label>
<input type="text" id="doctor_id" name="doctor_id" readonly>

<label>Consultation Fee</label>
<input type="text" id="fee" name="fee" readonly>

<label class="full">Symptoms</label>
<textarea name="symptoms" class="full" required></textarea>

<label>Appointment Date</label>
<input type="date" name="appointment_date" id="appointment_date" required>

</div>

<button type="submit">Confirm Appointment</button>

</form>
</div>
</div>

</div>
<script>
window.onload = function () {
    generateAppointmentId();

    // Set today's date as minimum selectable date
    let today = new Date().toISOString().split("T")[0];
    document.getElementById("appointment_date").setAttribute("min", today);
};
</script>
</body>
</html>
