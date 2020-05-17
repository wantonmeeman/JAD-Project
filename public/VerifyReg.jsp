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
  String pass1 = request.getParameter("pass"); 
  String pass2 = request.getParameter("pass2");
 
  if(!pass1.equals(pass2)){
	  Error += "PasswordNotEqual-";
  }else{
	  if(4 > Username.length() && Username.length() > 20){
		  Error += "UsernameSizeInvalid-";
	  }
	  if(4 > pass1.length() && pass1.length() > 20){
		  Error += "PasswordSizeInvalid-";
	  }
  }
  
  if(Error.length() > 0){
	  response.sendRedirect("register.jsp?Err="+Error);
  }else{
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
	  	      String query = "INSERT INTO users(username,password,email,role) VALUES('"+Username+"','"+pass1+"','"+Email+"','member')";
	  	      Statement st = conn.createStatement();
	  	      int rs = st.executeUpdate(query);
	  	       if(rs != 1){
	  	       out.print("Error");
	  	   	   }
		      
	  	      String Selectquery = "SELECT user_id FROM users WHERE username = '"+Username+"' ORDER BY user_id DESC LIMIT 1";
	  	      Statement Selectst = conn.createStatement();
		      ResultSet Selectrs = Selectst.executeQuery(Selectquery);
		      while (Selectrs.next()){
		    	  int userid = Selectrs.getInt("user_id");
		    	  response.sendRedirect("index.jsp?role=member&userid="+userid);
		      }
	  	 	  conn.close();
	  	 
	  	 	  
	  	}
  }

%>
</body>
</html>