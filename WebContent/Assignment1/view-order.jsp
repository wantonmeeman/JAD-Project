<%-- 
==========================================
Author: Alastair Tan (P1936096) & Yu Dong En (P1936348)
Class: DIT/2A/02
Description: ST0510 / JAD Assignment 1
===========================================
--%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="myclasses.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.ArrayList"%>
<%@page import="java.text.DecimalFormat"%>
<!DOCTYPE html>
<html lang="en">

<head>

<%
	DecimalFormat format = new DecimalFormat("#0.00");
HttpSession Session = request.getSession();
String productCat = request.getParameter("cat");
String sort = request.getParameter("sort");
String search = request.getParameter("search");
String productID = "";
String Name = "";
String briefDescription = "";
String detailedDescription = "";
String cPrice = "";
String rPrice = "";
int stockQuantity = 0;
String image = "";
String cells = "";
String AdminPage = "";
String query = "";
String Searchquery = "";
String CatSearchquery = "";
String categories = "";

int discountInt = 0;
int roundDiscount = 0;
double discount = 0.00;
String discountMsg = "";
String priceMsg = "";
int userid = 0;
String role = "";

String orders = "";
String orderAddress = "";
String orderCountry = "";
String orderProduct = "";
int orderProductID = 0;
String orderCompany = "";
String orderQuantity = "";
double orderTotal = 0;
String orderNotes = "";
String orderZipcode = "";
String orderCardNumber = "";
String orderImage = "";
String orderDate = "";
String Pagination = "";
int PageNumber = 0;

try {
	userid = (int) Session.getAttribute("userid");
	role = (String) Session.getAttribute("role");
} catch (Exception e) {
	response.sendRedirect("404.jsp");
}

int total_Orders = (int) Session.getAttribute("OrdersT");
ArrayList<order> Orders = (ArrayList<order>) Session.getAttribute("Orders");

String orderSort = request.getParameter("orderSort");

String Path = request.getContextPath() + "/";

for (int i = 0; i < total_Orders; i++) {

	if ((i % 5) == 0) {
		PageNumber += 1;
		Pagination += "<a href='" + Path + "viewOrders?page=" + PageNumber + "&orderSort=" + orderSort
		+ "'><button class = 'btn btn-secondary'>" + PageNumber + "</button></a>";
	} else {

	}

}
String DeliveryDate = "";
for (int i = 0; Orders.size() > i; i++) {
	DeliveryDate = "";
	if (Orders.get(i).getOrderDelDate() == null) {
		DeliveryDate = "NA";
	} else {
		DeliveryDate = Orders.get(i).getOrderDelDate();
	}
	orders += "<tr>" + "<td><img width='200' height='200' src='" +request.getContextPath()+"/images/" + Orders.get(i).getOrderImage() + "'></img></td>"
	+ "<td class='col-md-12'>" + Orders.get(i).getOrderProduct() + "</td>" + "<td>"
	+ Orders.get(i).getOrderDate() + "</td>" + "<td>"
	+ Orders.get(i).getOrderCardNumber().replaceFirst(".{12}", "**************") + "</td>" + "<td>"
	+ Orders.get(i).getOrderAddress() + "</td>" + "<td>" + Orders.get(i).getOrderZipCode() + "</td>" + "<td>"
	+ Orders.get(i).getOrderCompany() + "</td>" + "<td>" + Orders.get(i).getOrderQuantity() + "</td>" + "<td>$"
	+ format.format(Orders.get(i).getOrderTotal()) + "</td>" + "<td class='col-md-12' span='1'>"
	+ Orders.get(i).getOrderNotes() + "</td>" + "<td>" + Orders.get(i).getOrderStatus() + "</td>" + "<td>"
	+ DeliveryDate + "</td>" + "<div class='ml-4 col-md-2'>" + "</div></div></td></tr>";
}
%>
<title>Digit Games &mdash; All Products</title>
<meta charset="utf-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">

<link rel="stylesheet"
	href="https://fonts.googleapis.com/css?family=Mukta:300,400,700">
<link rel="stylesheet" href="fonts/icomoon/style.css">

<link rel="stylesheet" href="css/bootstrap.min.css">
<link rel="stylesheet" href="css/magnific-popup.css">
<link rel="stylesheet" href="css/jquery-ui.css">
<link rel="stylesheet" href="css/owl.carousel.min.css">
<link rel="stylesheet" href="css/owl.theme.default.min.css">

<link rel="stylesheet" href="css/myoverride.css">


<link rel="stylesheet" href="css/aos.css">

<link rel="stylesheet" href="css/style.css">

<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>


</head>

<body>
	<!-- The Modal -->
	<div id="myModal" class="modal">

		<!-- Modal content -->
		<div class="modal-content">
			<span id="close" class="close">&times;</span>
			<div class="form-group row">

				<div class="col-md-5">
					<form>
						<label for="offer" class="text-black">Make Offer: </label> <input
							type="number" class="form-control" id="offer" name="offer"
							placeholder="(SGD$)">
						<button type="button" id="submitOffer">Offer</button>
					</form>
				</div>
			</div>
		</div>

	</div>


	<div class="site-wrap">
		<header class="site-navbar" role="banner">
			<div class="site-navbar-top">
				<div class="container">
					<div class="row align-items-center">

						<div
							class="col-6 col-md-4 order-2 order-md-1 site-search-icon text-left">

						</div>

						<div
							class="col-12 mb-3 mb-md-0 col-md-4 order-1 order-md-2 text-center">
							<div class="site-logo">
								<a href="index.jsp? " class="js-logo-clone">Digit Games</a>
							</div>
						</div>

						<div class="col-6 col-md-4 order-3 order-md-3 text-right">
							<div class="site-top-icons">


								<%
									if (role.equals("admin") || role.equals("member")) {
								%>
								<ul>
									<li><a href='${pageContext.request.contextPath}/CartServlet' class='site-cart  mr-3'><span
											class='icon icon-shopping_cart'></span></a></li>
									<li><a href='profile.jsp'>Edit Profile</a></li>
									<li><a href='${pageContext.request.contextPath}/invalidate?rd=index' class='btn btn-sm btn-secondary'>Logout</span></a></li>
									<li id='logoutButton'></li>
								</ul>
								<%
									} else {
								%>
								<ul>
									<li><a href='loginpage.jsp'>Login</a></li>
									<li><a href='register.jsp'>Register</span></a></li>
									<li id='logoutButton'></li>
								</ul>
								<%
									}
								%>

							</div>
						</div>

					</div>
				</div>
			</div>
			<nav class="site-navigation text-right text-md-center"
				role="navigation">
				<div class="container">
					<ul class="site-menu js-clone-nav d-none d-md-block">
						<li><a href="index.jsp? ">Home</a></li>
						<li><a href="about.jsp? ">About</a></li>
						<li><a href="categories.jsp? ">Shop</a></li>
						<li><a href="all-listings.jsp? ">Catalogue</a></li>
						<li><a href="contact.jsp? ">Contact</a></li>
						<%
							if (role.equals("admin")) {
						%>
						<li><a
							href='${pageContext.request.contextPath}/allUsersDetails'>User
								Control</a></li>
						<li><a
							href='${pageContext.request.contextPath}/allProductsDetails'>Product
								Control</a></li>
						<li><a href='${pageContext.request.contextPath}/viewOrders'>View
								Order History</a></li>
						<%
							} else if (role.equals("member")) {
						%>
						<li><a href='${pageContext.request.contextPath}/viewOrders'>View
								Order History</a></li>
						<%
							}
						%>
					</ul>
				</div>
			</nav>
		</header>
		<div class="bg-light py-3">
			<div class="container">
				<div class="row">
					<div class="col-md-12 mb-0">
						<a href="index.jsp">Home</a> <span class="mx-2 mb-0">/</span> <strong
							class="text-black">View Order History</strong>
					</div>
				</div>
			</div>
		</div>

		<div class="site-section">
			<div class="container-fluid myOrders">

				<div class="col-md-12">
					<h2 class="h3 mb-5 text-black">My Orders</h2>
				</div>

				<div class="col-md-12">
					<div class="btn-group">
						<button type="button"
							class="btn btn-secondary btn-sm dropdown-toggle"
							id="dropdownMenuReference" data-toggle="dropdown">Sorting</button>
						<div class="dropdown-menu" aria-labelledby="dropdownMenuReference">
							<a class="dropdown-item"
								href="${pageContext.request.contextPath}/viewOrders?orderSort=Adate">Date,
								Ascending</a> <a class="dropdown-item"
								href="${pageContext.request.contextPath}/viewOrders?orderSort=Ddate">Date,
								Descending</a>
							<div class="dropdown-divider"></div>
							<a class="dropdown-item"
								href="${pageContext.request.contextPath}/viewOrders?orderSort=Atotal">Total,
								Ascending</a> <a class="dropdown-item"
								href="${pageContext.request.contextPath}/viewOrders?orderSort=Dtotal">Total,
								Descending</a>
							<div class="dropdown-divider"></div>
							<a class="dropdown-item"
								href="${pageContext.request.contextPath}/viewOrders?orderSort=Dstatus">Status</a>
						</div>
					</div>
					<table class="table table-hover">
						<thead>
							<tr>
								<th scope="col">Product</th>
								<th scope="col">Title</th>
								<th scope="col">Order Date</th>
								<th scope="col">Card Number</th>
								<th scope="col">Address</th>
								<th scope="col">Zipcode</th>
								<th scope="col">Company</th>
								<th scope="col">Quantity</th>
								<th scope="col">Total</th>
								<th scope="col">Notes</th>
								<th scope="col">Status</th>
								<th scope="col">Delivery Date</th>
							</tr>
						</thead>
						<tbody>
							<%=orders%>
						</tbody>
					</table>
				</div>
				<%=Pagination%>
			</div>
		</div>

		<!-- FOOTER -->
		<footer class="site-footer border-top">
			<div class="container">
				<div class="row">

					<div class="col-lg-4 mb-5 mb-lg-0">
						<div class="col-md-12">
							<h3 class="footer-heading mb-4">Navigations</h3>
						</div>
						<div class="col-md-6 col-lg-6">
							<ul class="list-unstyled">
								<li><a href="#">About Us</a></li>
								<li><a href="#">Privacy Policy</a></li>
								<li><a href="#">Contact Us</a></li>
								<li><a href="#">Store builder</a></li>
							</ul>
						</div>
					</div>

					<div class="col-md-6 col-lg-5 mb-4 mb-lg-0">
						<div class="col-md-12">
							<h3 class="footer-heading mb-4">FAQs</h3>
						</div>
						<div class="col-md-6 col-lg-12">
							<ul class="list-unstyled">
								<li><a href="#" class="link">How do I change my account
										password?</a></li>
								<li><a href="#">How do I save my billing method?</a></li>
								<li><a href="#">Where can I checkout my cart?</a></li>
								<li><a href="#"><u><small>Any other
												questions? Check out our FAQs page here &rarr;</small></u></a></li>
							</ul>
						</div>
					</div>
					<div class="col-md-6 col-lg-3">
						<div class="block-5 mb-5">
							<h3 class="footer-heading mb-4">Contact Info</h3>
							<ul class="list-unstyled">
								<li class="address">123 Raffles Place, Singapore</li>
								<li class="phone"><a href="tel://23923929210">+65 9123
										4567</a></li>
								<li class="email">digit-games@dgmail.com</li>
							</ul>
						</div>
					</div>
				</div>


				<div class="row pt-5 mt-5 text-center">
					<div class="col-md-12">
						<p>
							<!-- Link back to Colorlib can't be removed. Template is licensed under CC BY 3.0. -->
							Copyright &copy;
							<script data-cfasync="false"
								src="/cdn-cgi/scripts/5c5dd728/cloudflare-static/email-decode.min.js"></script>
							<script>
								document.write(new Date().getFullYear());
							</script>
							All rights reserved | This template is made with <i
								class="icon-heart" aria-hidden="true"></i> by <a
								href="https://colorlib.com" target="_blank" class="text-primary">Colorlib</a>
							<!-- Link back to Colorlib can't be removed. Template is licensed under CC BY 3.0. -->
						</p>
					</div>

				</div>
			</div>
		</footer>
	</div>

	<script src="js/jquery-3.3.1.min.js"></script>
	<script src="js/jquery-ui.js"></script>
	<script src="js/popper.min.js"></script>
	<script src="js/bootstrap.min.js"></script>
	<script src="js/owl.carousel.min.js"></script>
	<script src="js/jquery.magnific-popup.min.js"></script>
	<script src="js/aos.js"></script>

	<script src="js/main.js"></script>

</body>

</html>