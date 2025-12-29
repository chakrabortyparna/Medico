<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Doctor Dashboard</title>
    <style>
        body {
            margin:0; font-family: Arial; background:#f0f2f5;
        }
        .container {
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar */
        .sidebar {
            width: 220px;
            background: #0b5ed7;
            color: white;
            padding: 20px;
        }
        .sidebar h2 {
            font-size: 18px;
            margin-bottom: 25px;
        }
        .sidebar a {
            display: block;
            padding: 10px;
            margin-bottom: 10px;
            background:#0946a0;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }
        .sidebar a:hover {
            background: #06357a;
        }

        /* Content */
        .content {
            flex: 1;
            padding: 20px;
        }

        /* Tabs */
        .tabs {
            display: flex;
            border-bottom: 2px solid #0b5ed7;
            margin-bottom: 20px;
        }
        .tab {
            padding: 10px 20px;
            margin-right: 5px;
            border-radius: 5px 5px 0 0;
            cursor: pointer;
            font-weight: bold;
            background: #d0e0ff;
        }
        .tab.active {
            background: #0b5ed7;
            color: white;
        }

        /* Tab content */
        .tab-content {
            background: white;
            padding: 30px;
            border-radius: 5px;
            min-height: 300px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            text-align:center;
        }

        .tab-content button {
            margin-top: 20px;
            padding: 12px 25px;
            background: #198754;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }
   _topic {

        }
    </style>
</head>
<body>

<div class="container">

    <!-- LEFT SIDEBAR -->
    <div class="sidebar">
        <h2>Hello,<br>Dr. <%= session.getAttribute("doctorName") %></h2>
        <a href="doctorProfile.jsp">Doctor Details</a>
        <a href="patientData.jsp">Patient Data</a>
        <a href="feedback.jsp">Feedback</a>
        <a href="landing.html">Logout</a>
    </div>

    <!-- RIGHT CONTENT -->
    <div class="content">
        <h3>Welcome Dr. <%= session.getAttribute("doctorName") %></h3>

        <!-- Tabs -->
        <div class="tabs">
            <div class="tab active" onclick="openTab('pending', this)">Pending Appointments</div>
            <div class="tab" onclick="openTab('approved', this)">Approved Appointments</div>
            <div class="tab" onclick="openTab('prescription', this)">Prescription</div>
            <div class="tab" onclick="openTab('reports', this)">Reports</div>
            <div class="tab" onclick="openTab('commission', this)">Commission</div>
        </div>

        <!-- Tab Content -->
        <div id="tabContent" class="tab-content">
            <h3>View your pending appointments</h3>
            <button onclick="location.href='pendingapp.jsp'">View</button>
        </div>
    </div>
</div>

<script>
function openTab(tabName, el) {

    document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
    el.classList.add('active');

    let content = document.getElementById("tabContent");

    switch(tabName) {

        case 'pending':
            content.innerHTML = `
                <h3>View your pending appointments</h3>
                <button onclick="location.href='pendingapp.jsp'">View</button>
            `;
            break;

        case 'approved':
            content.innerHTML = `
                <h3>View all approved appointments</h3>
                <button onclick="location.href='approveappointments.jsp'">View</button>
            `;
            break;

        case 'prescription':
            content.innerHTML = `
                <h3>Write prescription</h3>
                <button onclick="location.href='pendingprescription.jsp'">Write</button>
            `;
            break;

        case 'reports':
            content.innerHTML = `
                <h3>View patients reports</h3>
                <button onclick="location.href='patientReports.jsp'">View</button>
            `;
            break;

        case 'commission':
            content.innerHTML = `
                <h3>Contact with admin</h3>
                <button onclick="location.href='paycommision.jsp'">Pay</button>
            `;
            break;
    }
}
</script>

</body>
</html>
