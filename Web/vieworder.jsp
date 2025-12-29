<%@ page import="java.sql.*,java.util.*" %>
<%@ page session="true" %>

<%
    String patientId = (String) session.getAttribute("patient_id");
    if(patientId == null){
        response.sendRedirect("patient-login.jsp");
        return;
    }

    String selectedOrderId = request.getParameter("order_id");

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    List<Map<String,Object>> orders = new ArrayList<>();
    List<String> orderIds = new ArrayList<>();

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        con = DriverManager.getConnection(
            "jdbc:oracle:thin:@localhost:1521:xe","system","manager"
        );

        // Fetch order IDs for dropdown
        ps = con.prepareStatement(
            "SELECT order_id FROM pharmacy_order WHERE patient_id=? ORDER BY order_date DESC"
        );
        ps.setString(1, patientId);
        rs = ps.executeQuery();
        while(rs.next()){
            orderIds.add(rs.getString("order_id"));
        }
        rs.close();
        ps.close();

        // Fetch orders (filtered or all)
        if(selectedOrderId != null && !selectedOrderId.equals("")){
            ps = con.prepareStatement(
                "SELECT * FROM pharmacy_order WHERE patient_id=? AND order_id=?"
            );
            ps.setString(1, patientId);
            ps.setString(2, selectedOrderId);
        } else {
            ps = con.prepareStatement(
                "SELECT * FROM pharmacy_order WHERE patient_id=? ORDER BY order_date DESC"
            );
            ps.setString(1, patientId);
        }

        rs = ps.executeQuery();

        while(rs.next()){
            Map<String,Object> order = new HashMap<>();
            order.put("order_id", rs.getString("order_id"));
            order.put("patient_name", rs.getString("patient_name"));
            order.put("address", rs.getString("address"));
            order.put("phone", rs.getString("phone"));
            order.put("items", rs.getString("items"));
            order.put("total_cost", rs.getDouble("total_cost"));
            order.put("payment_mode", rs.getString("payment_mode"));
            order.put("order_date", rs.getDate("order_date"));
            order.put("status", rs.getString("status"));
            orders.add(order);
        }

    } catch(Exception e){
        e.printStackTrace();
    } finally {
        try{ if(rs!=null) rs.close(); }catch(Exception e){}
        try{ if(ps!=null) ps.close(); }catch(Exception e){}
        try{ if(con!=null) con.close(); }catch(Exception e){}
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Orders</title>

<style>
body{font-family:Arial;background:#f0f2f5;padding:20px}
h2{text-align:center;color:#0b5ed7}
table{width:100%;border-collapse:collapse;margin-top:20px}
th,td{border:1px solid #ccc;padding:10px;text-align:left}
th{background:#0b5ed7;color:white}
tr:nth-child(even){background:#f9f9f9}

.status-shipped{color:blue;font-weight:bold}
.status-delivered{color:green;font-weight:bold}
.status-pending{color:orange;font-weight:bold}

.filter-box{
    text-align:center;
    margin-top:15px;
}
select,button{
    padding:8px 12px;
    font-size:14px;
}
</style>
</head>

<body>

<h2>My Pharmacy Orders</h2>

<!-- CENTER DROPDOWN -->
<div class="filter-box">
<form method="get">
    <b>Select Order ID:</b>
    <select name="order_id">
        <option value="">-- All Orders --</option>
        <% for(String oid : orderIds){ %>
        <option value="<%=oid%>" <%= oid.equals(selectedOrderId)?"selected":"" %>>
            <%=oid%>
        </option>
        <% } %>
    </select>
    <button type="submit">View</button>
</form>
</div>

<table>
<tr>
    <th>Order ID</th>
    <th>Patient Name</th>
    <th>Address</th>
    <th>Phone</th>
    <th>Items</th>
    <th>Total Cost</th>
    <th>Payment Mode</th>
    <th>Order Date</th>
    <th>Status</th>
</tr>

<%
if(orders.isEmpty()){
%>
<tr>
    <td colspan="9" style="text-align:center;">No orders found.</td>
</tr>
<%
}else{
    for(Map<String,Object> order : orders){
%>
<tr>
    <td><%=order.get("order_id")%></td>
    <td><%=order.get("patient_name")%></td>
    <td><%=order.get("address")%></td>
    <td><%=order.get("phone")%></td>
    <td><%=order.get("items")%></td>
    <td><%=order.get("total_cost")%></td>
    <td><%=order.get("payment_mode")%></td>
    <td><%=order.get("order_date")%></td>
    <td class="status-<%=((String)order.get("status")).toLowerCase()%>">
        <%=order.get("status")%>
    </td>
</tr>
<%
    }
}
%>

</table>

</body>
</html>
