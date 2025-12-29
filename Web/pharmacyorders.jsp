<%@ page import="java.sql.*,java.util.*" %>
<%@ page session="true" %>

<%
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    List<Map<String,Object>> orders = new ArrayList<>();

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        con = DriverManager.getConnection(
            "jdbc:oracle:thin:@localhost:1521:xe",
            "system","manager"
        );

        ps = con.prepareStatement(
            "SELECT * FROM pharmacy_order ORDER BY order_date DESC"
        );
        rs = ps.executeQuery();

        while(rs.next()){
            Map<String,Object> order = new HashMap<>();
            order.put("order_id", rs.getString("order_id"));
            order.put("patient_id", rs.getString("patient_id"));
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
<title>Pharmacy Orders</title>

<style>
body{font-family:Arial;background:#f0f2f5;padding:20px}
h2{text-align:center;color:#0b5ed7}
table{width:100%;border-collapse:collapse;margin-top:20px;background:#fff}
th,td{border:1px solid #ccc;padding:10px;text-align:center}
th{background:#0b5ed7;color:#fff}
tr:nth-child(even){background:#f9f9f9}

.status-shipped{color:blue;font-weight:bold}
.status-delivered{color:green;font-weight:bold}
.status-rejected{color:red;font-weight:bold}
.status-out\ for\ delivery{color:orange;font-weight:bold}

button{padding:6px 10px;border:none;border-radius:6px;color:#fff;cursor:pointer}
.delivered{background:#198754}
.out{background:#ffc107;color:#000}
.reject{background:#dc3545}
</style>

</head>

<body>

<h2>All Pharmacy Orders</h2>

<table>
<tr>
<th>Order ID</th>
<th>Patient ID</th>
<th>Patient Name</th>
<th>Address</th>
<th>Phone</th>
<th>Items</th>
<th>Total</th>
<th>Payment</th>
<th>Date</th>
<th>Status</th>
<th>Action</th>
</tr>

<%
if(orders.isEmpty()){
%>
<tr>
<td colspan="11">No orders found</td>
</tr>
<%
}else{
for(Map<String,Object> o : orders){
String status = (String)o.get("status");
%>

<tr>
<td><%=o.get("order_id")%></td>
<td><%=o.get("patient_id")%></td>
<td><%=o.get("patient_name")%></td>
<td><%=o.get("address")%></td>
<td><%=o.get("phone")%></td>
<td style="text-align:left"><%=o.get("items")%></td>
<td><%=o.get("total_cost")%></td>
<td><%=o.get("payment_mode")%></td>
<td><%=o.get("order_date")%></td>

<td class="status-<%=status.toLowerCase()%>">
<%=status%>
</td>

<td>
<form action="updatestatus" method="post" style="display:flex;gap:5px">
<input type="hidden" name="orderId" value="<%=o.get("order_id")%>">

<button class="delivered" name="status" value="Delivered">Delivered</button>
<button class="out" name="status" value="Out for Delivery">Out</button>
<button class="reject" name="status" value="Rejected">Reject</button>
</form>
</td>

</tr>

<%
}}
%>

</table>

</body>
</html>
