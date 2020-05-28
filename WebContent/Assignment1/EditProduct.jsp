<%-- 
==========================================
Author: Alastair Tan (P1936096) & Yu Dong En (P1936348)
Class: DIT/2A/02
Description: ST0510 / JAD Assignment 1
===========================================
--%>
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
  
  String productID = request.getParameter("productID");
  String name = request.getParameter("name");
  String c_price = request.getParameter("c_price");
  String r_price = request.getParameter("r_price");
  String stockQuantity = request.getParameter("stockQuantity");
  String productCat = request.getParameter("productCat");
  String briefDesc = request.getParameter("briefDesc");
  String detailedDesc = request.getParameter("detailedDesc");
  String image = request.getParameter("image");
  
  double cPriceFloat = 0;
  double rPriceFloat = 0;
  
  try {
	 	cPriceFloat = Double.parseDouble(c_price);
	 	rPriceFloat = Double.parseDouble(r_price);
	  
  } catch (NumberFormatException e) {
	  Error = "NumberFormatError";
	  response.sendRedirect("Editlisting.jsp?Err=NumberFormatError&userid="+userid+"&role="+role+"&productID="+productID);
  }
  
  //What else to add? try to add image path later maybe?
 if( name.equals("") || c_price.equals("") || r_price.equals("") || stockQuantity.equals("") || productCat.equals("")){
	 response.sendRedirect("Editlisting.jsp?Err=NullError&userid="+userid+"&role="+role+"&productID="+productID);
 }else{
	if (Error.equals("")) {
	 	if( Double.parseDouble(c_price) < 0 || Double.parseDouble(r_price) < 0 || Double.parseDouble(stockQuantity) < 0){
		 	response.sendRedirect("Editlisting.jsp?Err=NegativeError&userid="+userid+"&role="+role+"&productID="+productID);
	 	}else{
		  try{
			  	Class.forName("com.mysql.jdbc.Driver");
			  	conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
			  	// conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=admin&password=@dmin1!&serverTimezone=UTC&characterEncoding=latin1");
			  	if(conn == null){
			  		out.print("Conn Error");
			  		conn.close();
			  	}else{
	/* 		  		  String query = "UPDATE products SET name= '"+name+"', brief_description='"+briefDesc+"', detailed_description='"+detailedDesc+"', c_price='"+c_price+"', r_price='"+r_price+"', stock_quantity='"+stockQuantity+"', product_cat='"+productCat+"',image='"+image+"' WHERE product_id= '"+productID+"'"; 
			  		  Statement st = conn.createStatement();
				      int rs = st.executeUpdate(query);
				       */
				       String query = "UPDATE products SET name = ?, brief_description = ?, detailed_description = ?, c_price = ?, r_price = ?, stock_quantity = ?, product_cat = ?, image = ? WHERE product_id = ?";
				       PreparedStatement pstmt = conn.prepareStatement(query);
				       
				       pstmt.setString(1, name);
				       pstmt.setString(2, briefDesc);
				       pstmt.setString(3, detailedDesc);
				       pstmt.setFloat(4, Float.parseFloat(c_price));
				       pstmt.setFloat(5, Float.parseFloat(r_price));
				       pstmt.setInt(6, Integer.parseInt(stockQuantity));
				       pstmt.setString(7, productCat);
				       pstmt.setString(8, image);
				       pstmt.setInt(9, Integer.parseInt(productID));
				       
				       int rs = pstmt.executeUpdate();
	
				      
				      conn.close();
				      if(rs != 1){
				      out.print("Database Error");
				      }else{
				    	  response.sendRedirect("admin-page.jsp?Err=EditSuccess&userid="+userid+"&role="+role);//Add EditSuccess at admin-page
				      } // else
				      
				      
			  	    
			  	} //else
			  	
	 	}catch(Exception e){
		    out.print(e);
		}
	}
	}
 }

%>
</body>
</html>