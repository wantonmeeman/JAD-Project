<%@ page import="java.sql.*" %>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<%
  String userid = request.getParameter("userid");  
  String role = request.getParameter("role");
  Connection conn = null; 
  String Error = "";
  String name = request.getParameter("name");
  String c_price = request.getParameter("c_price");
  String r_price = request.getParameter("r_price");
  String stockQuantity = request.getParameter("stockQuantity");
  String productCat = request.getParameter("productCat");
  String briefDesc = request.getParameter("briefDesc");
  String detailedDesc = request.getParameter("detailedDesc");
  //What else to add? try to add image path later maybe?
 if( name.equals("") || c_price.equals("") || r_price.equals("") || stockQuantity.equals("") || productCat.equals("")){
	 response.sendRedirect("addlisting.jsp?Err=NullError&userid="+userid+"&role="+role);
 }else{
 	if( Double.parseDouble(c_price) < 0 || Double.parseDouble(r_price) < 0 || Double.parseDouble(stockQuantity) < 0){
	 	response.sendRedirect("addlisting.jsp?Err=NegativeError&userid="+userid+"&role="+role);
 	}else{
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
		  		  String query = "INSERT INTO products(name, brief_description, detailed_description, c_price, r_price, stock_quantity, product_cat) VALUES('"+name+"','"+briefDesc+"','"+detailedDesc+"','"+c_price+"','"+r_price+"','"+stockQuantity+"','"+productCat+"')"; //Check if old password is equal to new password.
		  		  Statement st = conn.createStatement();
			      int rs = st.executeUpdate(query);
			      conn.close();
			      if(rs != 1){
			      out.print("Database Error"); 
			      }else{
			    	  response.sendRedirect("admin-page.jsp?Err=AddSuccess&userid="+userid+"&role="+role);
			      }
			      
			      
		  	    
		  	}
 	}
 }

%>
</body>
</html>