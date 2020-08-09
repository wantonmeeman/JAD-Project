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
  
String dbRoleID = request.getParameter("dbRoleID");
String roleName = request.getParameter("roleName");
  
  //What else to add? try to add image path later maybe?
try{
	userid = (int)Session.getAttribute("userid");  
	role = (String)Session.getAttribute("role");
}catch(Exception e){
	response.sendRedirect("404.jsp");
} 
 if( roleName.equals("")){
	 response.sendRedirect("edit-role.jsp?Err=NullError&dbRoleID="+dbRoleID);
 }else{

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
		  		  String query = "UPDATE roles SET role_name = '"+roleName+"' WHERE role_id = '"+dbRoleID+"'"; 
		  		  Statement st = conn.createStatement();
			      int rs = st.executeUpdate(query);
			      conn.close();
			      
			      if(rs != 1){
			      out.print("Database Error");
			      }else{
			    	  response.sendRedirect("http://localhost:12978/ST0510-JAD/allUsersDetails?Err=EditSuccess"); //Add EditSuccess at admin-page
			      }
			      
			      
		  	    
		  	}
 	
 }

%>
</body>
</html>