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

  String Error = "";
  String Username = request.getParameter("username"); 
  String Email = request.getParameter("email");
  String role = request.getParameter("role");
  String oldPassword = request.getParameter("oldPw");
  String newPassword1 = request.getParameter("newPw");
  String newPassword2 = request.getParameter("reenterPw");
  String userid = request.getParameter("userid");
  if(oldPassword == null){//EDIT PROFILE
	  if(4 > Username.length() || Username.length() > 20){
		  Error += "UsernameSizeInvalid-";
	  }
	  
	  //add email verification and maybe duplication verification
	if(Error.length() == 0){
		response.sendRedirect("profile.jsp?Err=ProfileSuccess&userid="+userid+"&role="+role);
	}else{
		response.sendRedirect("profile.jsp?Err="+Error+"&userid="+userid+"&role="+role);
	}
  }else{//CHANGE PASSWORD
	  
	  Connection conn = null; 
	  
	  try{
		  	Class.forName("com.mysql.jdbc.Driver");
		  	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/digitgames?characterEncoding=latin1","admin","@dmin1!");
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