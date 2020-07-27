<%-- 
==========================================
Author: Alastair Tan (P1936096) & Yu Dong En (P1936348)
Class: DIT/2A/02
Description: ST0510 / JAD Assignment 1
===========================================
--%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
 <%@page import="java.text.DecimalFormat" %>
<!DOCTYPE html>
<html lang="en">

<head>
<%  
HttpSession Session = request.getSession();
int userid = (int)Session.getAttribute("userid");  
String role = (String)Session.getAttribute("role");
String redirect = request.getParameter("rd");
Session.invalidate();


if(redirect.equals("index")){
	response.sendRedirect("index.jsp");
}else if(redirect.equals("cart")){
	response.sendRedirect("cart.jsp");
}
%>

</body>

</html>