<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
 <%@page import="java.text.DecimalFormat" %>
<!DOCTYPE html>
<html lang="en">

<head>
<%  
String role = request.getParameter("role");
String userid = request.getParameter("userid");
HttpSession Session = request.getSession();
Session.invalidate();
response.sendRedirect("index.jsp?userid="+userid+"&role="+role);
%>

</body>

</html>