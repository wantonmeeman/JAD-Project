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
  Connection conn = null; 
  String Error = "";
  HttpSession Session = request.getSession();
  int userid = 0 ; 
  String role = "";
  String Username = request.getParameter("username"); 
  String Email = request.getParameter("email");
  String firstName = request.getParameter("firstname");
  String lastName = request.getParameter("lastname");
  String phoneNumber = request.getParameter("phonenumber");
  String oldPassword = request.getParameter("oldPw");
  String newPassword1 = request.getParameter("newPw");
  String newPassword2 = request.getParameter("reenterPw");
  try{
		userid = (int)Session.getAttribute("userid");  
		role = (String)Session.getAttribute("role");
	}catch(Exception e){
		response.sendRedirect("404.jsp");
	}
  if (oldPassword == null){//EDIT PROFILE
	  if(4 > Username.length() || Username.length() > 20){
		  Error += "UsernameSizeInvalid-";
	  }
		if(Error.length() == 0){
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
			  		  String query = "UPDATE users SET email = '"+Email+"',  firstname = '"+firstName+"', lastname = '"+lastName+"', phonenumber = '"+phoneNumber+"' WHERE user_id = "+userid; //Check if old password is equal to new password.Do we need to change Username?
			  		  out.print(query);
			  	      Statement st = conn.createStatement();
				      int rs = st.executeUpdate(query);
				     if(rs == 1){
				      response.sendRedirect("profile.jsp?Err=ProfileSuccess");
				      conn.close();
				     }else{
				      out.print("Conn Error");
			 		conn.close();
				      }
				}

		}else{
			response.sendRedirect("profile.jsp?Err="+Error+"&userid="+userid+"&role="+role);
		}
  }else{//CHANGE PASSWORD
	  

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
		  		  String query = "SELECT password FROM users WHERE user_id ="+userid; //Check if old password is equal to new password.
		  		  Statement st = conn.createStatement();
			      ResultSet rs = st.executeQuery(query);
			      while (rs.next()){
			    	  String Password = rs.getString("password");
			    	  if(oldPassword.equals(Password)){
			    		  if(newPassword1.equals(newPassword2)){
			    			  if(4 < newPassword1.length() && newPassword1.length() < 20){
			    			  String InsertQuery = "UPDATE users SET password = '"+newPassword1+"' WHERE user_id = "+userid;
			    	  	      Statement Insertst = conn.createStatement();
			    	  	      int Insertrs = Insertst.executeUpdate(InsertQuery);
			    	  	       if(Insertrs != 1){
			    	  	       out.print("Error");
			    	  	   	   	}else{
			    	  	   	   	response.sendRedirect("profile.jsp?Err=PasswordSuccess&userid="+userid+"&role="+role);
			    	  	   	   }
			    			  }else{
			    			   response.sendRedirect("profile.jsp?Err=PasswordSizeInvalid&userid="+userid+"&role="+role);  
			    			  }
			    		  }else{
			    			  response.sendRedirect("profile.jsp?Err=PasswordNotEqual&userid="+userid+"&role="+role);
			    		  }
			    	  }else{
			    		  response.sendRedirect("profile.jsp?Err=PasswordNotValid&userid="+userid+"&role="+role);
			    	  }
			      }
		  	 	  conn.close();
			      
		  	    
		  	}
  }

%>
</body>
</html>