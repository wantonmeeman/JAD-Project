<%-- 
==========================================
Author: Alastair Tan (P1936096) & Yu Dong En (P1936348)
Class: DIT/2A/02
Description: ST0510 / JAD Assignment 1
===========================================
--%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<%
HttpSession Session = request.getSession();
int userid = 0;  
String role = "";
String quantity = request.getParameter("quantity");
String productID = (String)Session.getAttribute("productID");
Connection conn = null;
int dbquantity = 0;
try{
	userid = (int)Session.getAttribute("userid");  
	role = (String)Session.getAttribute("role");
}catch(Exception e){
	response.sendRedirect("404.jsp");
}
try{
	Class.forName("com.mysql.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
	// conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=admin&password=@dmin1!&serverTimezone=UTC&characterEncoding=latin1");
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
	conn.close();
		if( quantity.equals("") || Integer.parseInt(quantity) <= 0){
				response.sendRedirect("product.jsp?productid="+productID+"&Err=Invalid");
		}else if(dbquantity < Integer.parseInt(quantity)){
				response.sendRedirect("product.jsp?productid="+productID+"&Err=OverStk");
		}else{
			response.sendRedirect("cart.jsp?quantity="+quantity);
		}
}
%>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>

</body>
</html>