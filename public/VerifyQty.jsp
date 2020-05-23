<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<%
HttpSession Session = request.getSession();
String quantity = request.getParameter("quantity");
String userid = request.getParameter("userid");  
String role = request.getParameter("role");
String productID = (String)Session.getAttribute("productID");
Connection conn = null;
int dbquantity = 0;
try{
	Class.forName("com.mysql.jdbc.Driver");
	//conn = DriverManager.getConnection(jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC);
	conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=admin&password=@dmin1!&serverTimezone=UTC&characterEncoding=latin1");
}catch(Exception e){
	   out.print(e);
}
if(conn == null){
  	out.print("Conn Error");
  	conn.close();
}else{
	String query = "SELECT * FROM products WHERE product_id ="+productID;
	Statement st = conn.createStatement();
	ResultSet rs = st.executeQuery(query);
	while(rs.next()){
		dbquantity = rs.getInt("stock_quantity");
	} 
		if( quantity.equals("") || Integer.parseInt(quantity) <= 0){
				response.sendRedirect("product.jsp?userid="+userid+"&role="+role+"&productid="+productID+"&Err=Invalid");
				conn.close();
		}else if(dbquantity < Integer.parseInt(quantity)){
				response.sendRedirect("product.jsp?userid="+userid+"&role="+role+"&productid="+productID+"&Err=OverStk");
				conn.close();
		}else{
			response.sendRedirect("cart.jsp?userid="+userid+"&role="+role+"&quantity="+quantity);
			conn.close();
		}
}
%>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>

</body>
</html>