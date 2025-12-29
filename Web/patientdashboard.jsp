<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Patient Dashboard</title>
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

        /* Sidebar */
        .sidebar {
            width: 220px;
            background: #0b5ed7;
            color: white;
            padding: 20px;
        }
        .sidebar h2 {
            font-size: 18px;
            margin-bottom: 30px;
        }
        .sidebar a {
            display: block;
            padding: 10px;
            margin-bottom: 10px;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }
        .sidebar a:hover {
            background: #0946a0;
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
            cursor: pointer;
            font-weight: bold;
            background: #d0e0ff;
            border-radius: 5px 5px 0 0;
        }
        .tab.active {
            background: #0b5ed7;
            color: white;
        }

        /* Content box */
        .tab-content {
            background: white;
            padding: 30px;
            border-radius: 5px;
            min-height: 300px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            text-align: center;
        }

        .tab-content button {
            padding: 12px 25px;
            background: #198754;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            margin-top: 20px;
        }

        .tab-content button:hover {
            background: #157347;
        }
    </style>
</head>

<body>

<div class="container">

    <!-- Sidebar -->
    <div class="sidebar">
        <h2>Hello, <%= session.getAttribute("patient_name") %></h2>
        <a href="patientProfile.jsp">Patient Data</a>
        <a href="feedback.jsp">Feedback</a>
        <a href="landing.html">Logout</a>
    </div>

    <!-- Content -->
    <div class="content">
        <h3>Welcome <%= session.getAttribute("patient_name") %></h3>

        <div class="tabs">
            <div class="tab active" onclick="openTab('appointment', this)">Book Appointment</div>
            <div class="tab" onclick="openTab('prescription', this)">Prescription</div>
            <div class="tab" onclick="openTab('pharmacy', this)">Pharmacy</div>
            <div class="tab" onclick="openTab('orders', this)">Order</div>
            <div class="tab" onclick="openTab('status', this)">Appointment Status</div>
            <div class="tab" onclick="openTab('report', this)">Report</div>
            <div class="tab" onclick="openTab('payment', this)">Payment</div>
        </div>

        <div id="tabContent" class="tab-content">
            <h2>Book your appointment now</h2>
            <button onclick="goTo('bookingapp.jsp')">Book</button>
        </div>
    </div>

</div>

<script>
    function openTab(tabName, element) {
        document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
        element.classList.add('active');

        let content = document.getElementById("tabContent");

        if (tabName === 'appointment') {
            content.innerHTML = `
                <h2>Book your appointment now</h2>
                <button onclick="goTo('bookingapp.jsp')">Book</button>
            `;
        }
        else if (tabName === 'prescription') {
            content.innerHTML = `
                <h2>View your prescription</h2>
                <button onclick="goTo('viewprescription.jsp')">View</button>
            `;
        }
        else if (tabName === 'pharmacy') {
            content.innerHTML = `
                <h2>Go to pharmacy stores</h2>
                <button onclick="goTo('pharmacy.html')">Stores</button>
            `;
        }
        else if (tabName === 'orders') {
            content.innerHTML = `
                <h2>Check order data</h2>
                <button onclick="goTo('vieworder.jsp')">Data</button>
            `;
        }
        else if (tabName === 'status') {
            content.innerHTML = `
                <h2>Check your appointment status</h2>
                <button onclick="goTo('statusapp.jsp')">Check</button>
            `;
        }
        else if (tabName === 'report') {
            content.innerHTML = `
                <h2>Check your reports </h2>
                <button onclick="goTo('report.jsp')">Report</button>
            `;
        }
        else if (tabName === 'payment') {
            content.innerHTML = `
                <h2>Pay your doctor's fee </h2>
                <button onclick="goTo('paydoc.jsp')">Pay</button>
            `;
        }
    }

    function goTo(page) {
        window.location.href = page;
    }
</script>

</body>
</html>
