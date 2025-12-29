<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Write Prescription</title>

    <style>
        body {
            font-family: Arial;
            background: #f0f2f5;
            margin: 0;
            padding: 10px;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .box {
            width: 100%;
            max-width: 720px;
            background: white;
            padding: 18px 22px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.15);
        }

        h2 {
            text-align: center;
            margin-bottom: 12px;
            font-size: 22px;
        }

        .grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px 14px;
        }

        label {
            font-weight: bold;
            font-size: 14px;
        }

        input, textarea {
            width: 100%;
            padding: 7px 8px;
            margin-top: 3px;
            border-radius: 4px;
            border: 1px solid #ccc;
            font-size: 14px;
        }

        textarea {
            resize: none;
            height: 60px;
        }

        .full {
            grid-column: span 2;
        }

        .btn-group {
            display: flex;
            gap: 12px;
            margin-top: 14px;
        }

        .save-btn {
            flex: 1;
            padding: 10px;
            background: #198754;
            color: white;
            border: none;
            font-size: 15px;
            border-radius: 5px;
            cursor: pointer;
        }

        .back-btn {
            flex: 1;
            padding: 10px;
            background: #6c757d;
            color: white;
            border: none;
            font-size: 15px;
            border-radius: 5px;
            cursor: pointer;
        }
    </style>
</head>

<body>

<%
    String appointmentId = request.getParameter("appointment_id");
    String patientId = request.getParameter("patient_id");

    String doctorId = (String) session.getAttribute("doctorId");
    String doctorName = (String) session.getAttribute("doctorName");

    String patientName = "";
    int age = 0;
    String symptoms = "";

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        Connection con = DriverManager.getConnection(
            "jdbc:oracle:thin:@localhost:1521:XE",
            "system", "manager"
        );

        // Fetch patient name & age
        String psql =
            "SELECT name, TRUNC(MONTHS_BETWEEN(SYSDATE, dob)/12) AS age " +
            "FROM patient WHERE patient_id=?";
        PreparedStatement ps1 = con.prepareStatement(psql);
        ps1.setString(1, patientId);
        ResultSet rs1 = ps1.executeQuery();
        if (rs1.next()) {
            patientName = rs1.getString("name");
            age = rs1.getInt("age");
        }

        // Fetch symptoms
        String asql =
            "SELECT symptoms FROM appointment WHERE appointment_id=?";
        PreparedStatement ps2 = con.prepareStatement(asql);
        ps2.setString(1, appointmentId);
        ResultSet rs2 = ps2.executeQuery();
        if (rs2.next()) {
            symptoms = rs2.getString("symptoms");
        }

        con.close();
    } catch (Exception e) {
        out.println("<h4 style='color:red'>Error: " + e + "</h4>");
    }
%>

<div class="box">
    <h2>Write Prescription</h2>

    <form action="saveprescription" method="post">

        <div class="grid">

            <label>Appointment ID</label>
            <input type="text" name="appointment_id" value="<%= appointmentId %>" readonly>

            <label>Doctor ID</label>
            <input type="text" name="doctor_id" value="<%= doctorId %>" readonly>

            <label>Doctor Name</label>
            <input type="text" name='full_name' value="<%= doctorName %>" readonly>

            <label>Patient ID</label>
            <input type="text" name="patient_id" value="<%= patientId %>" readonly>

            <label>Patient Name</label>
            <input type="text" name='name' value="<%= patientName %>" readonly>

            <label>Age</label>
            <input type="text" name='age' value="<%= age %>" readonly>

            <label>Symptoms</label>
            <input type="text" name='symptoms' value="<%= symptoms %>" readonly>

            <label class="full">Diagnosis</label>
            <textarea name="diagnosis" class="full" required></textarea>

            <label class="full">Medicines</label>
            <textarea name="medicines" class="full" required
                placeholder="Medicine name - dosage - duration"></textarea>

            <label class="full">Additional Notes</label>
            <textarea name="notes" class="full"></textarea>

        </div>

        <div class="btn-group">
            <button type="submit" class="save-btn">Save Prescription</button>
            <button type="button" class="back-btn" onclick="history.back()">Back</button>
        </div>

    </form>
</div>

</body>
</html>
