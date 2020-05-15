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
try{
	Class.forName("com.mysql.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/stuff?characterEncoding=latin1","admin","@dmin1!");
	if(conn == null){
		out.print("Conn Error");
		conn.close();
	}else{
		out.print("Database has been connected to!");

	      // if you only need a few columns, specify them by name instead of using "*"
	      String query = "INSERT INTO `users`(user_id,created_at,username,password,PFPID) VALUES (14,'2019-11-24 15:47:16','testing',1234,'1580969254542.jpg') ";

	      // create the java statement
	      Statement st = conn.createStatement();
	      
	      // execute the query, and get a java resultset
	      //ResultSet rs = st.executeQuery(query);//executeUpdate if Insert statement or modifying database
	      int rs = st.executeUpdate(query);
	      out.print("<br>Number of rows affected: "+rs);
	      //ResultSetMetaData rsmd =// rs.getMetaData()   //meta data
	      //out.print(rsmd);
	      
	      //int ColCount = rsmd.getColumnCount();
	      //out.print("<br>");
	      //for(int x = 1;x<ColCount;x++){
	      //	String name = rsmd.getColumnName(x);
	      // iterate through the java resultset
	      //	out.print(name+" ");
	     //}
	     // out.print("<br>");
	     // while (rs.next())
	      //	{
	       // 	int id = rs.getInt("user_id");
	       // 	String firstName = rs.getString("username");
	       // 	String Pw = rs.getString("Password");
	       //		out.print(id+"|"+firstName+"|"+Pw+"<br>");
		  //	}
	//}
	
}
}catch(Exception e){
	out.print(e);
	out.print("<br>Error! Connection has been dropped");
}
%>
</body>
</html>