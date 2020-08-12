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
int dbUserID = Integer.parseInt(request.getParameter("dbUserID"));
Connection conn = null;
String query = "";

String Path = "http://localhost:8080"+request.getContextPath()+"/";

	try{
		userid = (int)Session.getAttribute("userid");  
		role = (String)Session.getAttribute("role");
	}catch(Exception e){
		response.sendRedirect("404.jsp");
	} 
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
		  		  query = "DELETE FROM orders WHERE fk_userid = ?";
		  		  PreparedStatement ppst = conn.prepareStatement(query);
		  		  ppst.setInt(1,dbUserID);
		  		  int rs = ppst.executeUpdate();
		  		  query = "DELETE FROM users WHERE user_id = ?";
		  		  ppst = conn.prepareStatement(query);
		  		  ppst.setInt(1,dbUserID);
		  		  rs = ppst.executeUpdate();
		  		 
		  		  
			    	if(rs != 1){
			    		 out.print(ppst.toString());
						out.print("Database Error");
						conn.close();
			      	}else{
			      		conn.close();
			    	  response.sendRedirect(Path + "allUsersDetails?Err=DelSuccess");//Add EditSuccess at admin-page
			      	}
			    	
		  	    
		  	}

%>
</body>
</html>