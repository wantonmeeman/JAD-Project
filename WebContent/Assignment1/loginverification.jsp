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
<html lang="en">


<head>
	<title>Login Page</title>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">

	<link rel="icon" type="image/png" href="images/icons/favicon.ico" />
	<link rel="stylesheet" type="text/css" href="vendor/bootstrap/css/bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="fonts/font-awesome-4.7.0/css/font-awesome.min.css">
	<link rel="stylesheet" type="text/css" href="fonts/iconic/css/material-design-iconic-font.min.css">
	<link rel="stylesheet" type="text/css" href="vendor/animate/animate.css">
	<link rel="stylesheet" type="text/css" href="vendor/css-hamburgers/hamburgers.min.css">
	<link rel="stylesheet" type="text/css" href="vendor/animsition/css/animsition.min.css">
	<link rel="stylesheet" type="text/css" href="vendor/select2/select2.min.css">
	<link rel="stylesheet" type="text/css" href="vendor/daterangepicker/daterangepicker.css">
	<link rel="stylesheet" type="text/css" href="css/util.css">
	<link rel="stylesheet" type="text/css" href="css/main.css">

	<!-- From Chapter 9 -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

</head>
<% 
int user_id = -1;
String role = null;
String input_username = request.getParameter("username");  
String input_password = request.getParameter("pass");
Connection conn = null; 

try{
	Class.forName("com.mysql.jdbc.Driver");
	//conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
	 conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/digitgames?characterEncoding=latin1","admin","@dmin1!");
	if(conn == null){
		out.print("Conn Error");
		conn.close();
	}else{
	      String query = "SELECT * FROM users WHERE username = '"+input_username+"' and password = '"+input_password+"'";
		 
	      // create the java statement
	      Statement st = conn.createStatement();
	      // execute the query, and get a java resultset
	      ResultSet rs = st.executeQuery(query);//executeUpdate if Insert statement or modifying database
	      while(rs.next()){
	      	user_id = rs.getInt("user_id");
	      	role = rs.getString("role");
	      }
	      conn.close();
	      	if(user_id == -1){
				response.sendRedirect("loginpage.jsp?Login=Err");
	      	}
	      HttpSession Session = request.getSession();
	      Session.setAttribute("userid",user_id);
	      Session.setAttribute("role",role);
	      response.sendRedirect("index.jsp");
	   }
	}catch(Exception e){
		out.print(e);
    }

%>


</html>