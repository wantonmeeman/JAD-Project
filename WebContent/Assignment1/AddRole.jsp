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
  HttpSession Session = request.getSession();
  int userid = (int)Session.getAttribute("userid");  
  String role = (String)Session.getAttribute("role");
  Connection conn = null; 
  String Error = "";
  String dbRole = request.getParameter("dbRole");
  try{
		userid = (int)Session.getAttribute("userid");  
		role = (String)Session.getAttribute("role");
	}catch(Exception e){
		response.sendRedirect("404.jsp");
	}
  	
  //What else to add? try to add image path later maybe?
 if( dbRole.equals("")){
	 response.sendRedirect("http://localhost:12978/ST0510-JAD/allUsersDetails?Err=NullError");
	 
 } else {

	  try{
		  	Class.forName("com.mysql.jdbc.Driver");
		  	//conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
		  	conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=admin&password=@dmin1!&serverTimezone=UTC&characterEncoding=latin1");
	  
	  }catch(Exception e){    
		  out.print(e);
		  
      }
		  	if(conn == null){
		  		out.print("Conn Error");
		  		conn.close();
		  	}else{
		  		  String query = "INSERT INTO roles(role_name) VALUES('"+dbRole+"')"; //Check if old password is equal to new password.
		  		  Statement st = conn.createStatement();
			      int rs = st.executeUpdate(query);
			      conn.close();
			      
			      if(rs != 1){
			      	out.print("Database Error"); 
			      	
			      } else {
			    	 response.sendRedirect("http://localhost:12978/ST0510-JAD/allUsersDetails?Err=AddSuccess");
			    	 
			      }
			      conn.close();
		  	}
 	
 }

%>
</body>
</html>