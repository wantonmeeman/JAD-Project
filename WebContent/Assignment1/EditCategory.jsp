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
  
  String categoryID = request.getParameter("categoryID");
  String catName = request.getParameter("catName");
  String catImageURL = request.getParameter("catImageURL");
  
  //What else to add? try to add image path later maybe?
 if( catName.equals("") || catImageURL.equals("")){
	 response.sendRedirect("edit-category.jsp?Err=NullError&userid="+userid+"&role="+role+"&categoryID="+categoryID);
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
		  		  String query = "UPDATE categories SET category_name= '"+catName+"', image='"+catImageURL+"' WHERE category_id = '"+categoryID+"'"; 
		  		  Statement st = conn.createStatement();
			      int rs = st.executeUpdate(query);
			      conn.close();
			      if(rs != 1){
			      out.print("Database Error");
			      }else{
			    	  response.sendRedirect("admin-page.jsp?Err=EditSuccess&userid="+userid+"&role="+role); //Add EditSuccess at admin-page
			      }
			      
			      
		  	    
		  	}
 	
 }

%>
</body>
</html>