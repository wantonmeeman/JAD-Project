<%-- 
==========================================
Author: Alastair Tan (P1936096) & Yu Dong En (P1936348)
Class: DIT/2A/02
Description: ST0510 / JAD Assignment 1
===========================================
--%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@page import="java.text.DecimalFormat"%>
<!DOCTYPE html>
<html lang="en">

<head>
<%

HttpSession Session = request.getSession();
String Err = request.getParameter("Err");
String name = "";
String r_price = "";
String image = "";
String rows = "";
String disabled = "";
DecimalFormat format = new DecimalFormat("#0.00");
String quantity = request.getParameter("quantity");
String productID = String.valueOf(Session.getAttribute("productID"));
double total = 0;
int userid = 0;  
String role = "";
int[] productArr = {};
int[] quantityArr = {};
//Connecting to Database
Connection conn = null;
try{
	userid = (int)Session.getAttribute("userid");  
	role = (String)Session.getAttribute("role");
}catch(Exception e){
	response.sendRedirect("404.jsp");
}
try{
	switch(Err) {
		case "Invalid":
			out.print("<script>alert('Invalid Input')</script>");
		break;
		case "OverStk":
			out.print("<script>alert('Amount specified is more than stock value')</script>");
		break;
	}
}catch(Exception e){
	
}
try{
if (quantity != null) {
	//Creating new cart or adding to cart 
	
	if (Session.getAttribute("productArr") == null || ((int[])Session.getAttribute("productArr"))[0] == 0) { //Creating new cart
		productArr = new int[50];
		quantityArr = new int[50];
		productArr[0] = Integer.parseInt(productID);
		quantityArr[0] = Integer.parseInt(quantity);
		Session.setAttribute("productArr", productArr);
		Session.setAttribute("quantityArr", quantityArr);
	} else {//Adding to cart
		productArr = (int[]) Session.getAttribute("productArr");
		quantityArr = (int[]) Session.getAttribute("quantityArr");
		for (int x = 0; ((int[]) Session.getAttribute("productArr")).length > x; x++) {
			//out.print("product: "+productArr[x]+",");
			//out.print("quantity: "+quantityArr[x]);
			if (((int[]) Session.getAttribute("productArr"))[x] == Integer.parseInt(productID)) {
					quantityArr[x] += Integer.parseInt(quantity);//Adds it to the first instance
					x = 51;
			}else if (((int[]) Session.getAttribute("productArr"))[x] == 0) {
					productArr[x] = Integer.parseInt(productID);
					quantityArr[x] = Integer.parseInt(quantity);
					x = 51;//stops the for loop
			}
		}
		Session.setAttribute("productArr", productArr);
		Session.setAttribute("quantityArr", quantityArr);
	}
}
}catch(Exception e){
	
}
//Connecting to Database
conn = null;
quantityArr = ((int[]) Session.getAttribute("quantityArr"));
productArr = ((int[]) Session.getAttribute("productArr"));
try {
	Class.forName("com.mysql.jdbc.Driver");
	//conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
	conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=admin&password=@dmin1!&serverTimezone=UTC&characterEncoding=latin1");
} catch (Exception e) {

}

try {
	if (conn == null) {
		out.print("Conn Error");
		conn.close();
	} else {
		for (int x = 0; productArr.length > x; x++) {
	if (((int[]) Session.getAttribute("productArr"))[x] != 0) {
		String query = "SELECT * FROM products WHERE product_id =" + productArr[x];
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(query);
		while (rs.next()) {
			name = rs.getString("name");
			r_price = format.format(rs.getDouble("r_price"));
			image = rs.getString("image");
		} //This below makes tables
		rows += "<tr><td class='product-thumbnail'><img src='" + image
				+ "' alt='Image' class='img-fluid'></td><td class='product-name'><h2 class='h5 text-black'>"
				+ name + "</h2></td><td>$" + r_price
				+ "</td><td><div class='input-group mb-3' style='max-width: 120px;'><form action='http://localhost:12978/ST0510-JAD/changeQuantity?productID="+productArr[x]+"' method='POST'><input type='number' name='quantity' value="
				+ quantityArr[x] + "></input></div></td><td>$"
				+ format.format(((double) quantityArr[x]) * Double.parseDouble(r_price)) + "</td>"
				+"<th class='product-total'><a href='http://localhost:12978/ST0510-JAD/deleteFromCart?product="+productArr[x]+"'>Delete</a><input type='submit' class='btn btn-primary btn-sm btn-block' value='Update Quantity'></input></form></th></tr>";
		total += quantityArr[x] * Double.parseDouble(r_price);//For prices
	}
		}
		conn.close();
	}
} catch (Exception e) {

}
String AdminPage = "";
String Header = "<ul><li><a href='loginpage.jsp'>Login</a></li><li><a href='register.jsp'>Register</span></a></li><li id='logoutButton'></li></ul>";
try{
	userid = (int)Session.getAttribute("userid");  
    role = (String)Session.getAttribute("role");
}catch(Exception e){

}

try {
	if(role.equals("admin")){ 
        AdminPage = "<li><a href='all-users.jsp'>User Control</a></li>"
        		+ "<li><a href='admin-page.jsp'>Product Control</a></li>"
        		+ "<li><a href='view-order.jsp'>View Order History</a></li>";
        		
        Header = "<div class='site-top-icons'>"
                + "<ul><li><a href='cart.jsp' class='site-cart  mr-3'><span class='icon icon-shopping_cart'></span></a></li>"
                  + "<li><a href='profile.jsp'>Edit Profile</a></li>" 
                  + "<li><a href='index.jsp?' class='btn btn-sm btn-secondary'>Logout</span></a></li>" 
                  + "<li id='logoutButton'></li></ul></div>";              
     } else if (role.equals("member")) {
    	  Header = "<div class='site-top-icons'>"
                  + "<ul><li><a href='cart.jsp' class='site-cart  mr-3'><span class='icon icon-shopping_cart'></span></a></li>"
                    + "<li><a href='profile.jsp'>Edit Profile</a></li>" 
                    + "<li><a href='index.jsp?' class='btn btn-sm btn-secondary'>Logout</span></a></li>" 
                    + "<li id='logoutButton'></li></ul></div>";     
          AdminPage = "<li><a href='view-order.jsp'>View Order History</a></li>";
     }
} catch (Exception e) {// if no id or role is detected
	Header = "<ul><li><a href='loginpage.jsp'>Login</a></li><li><a href='register.jsp'>Register</span></a></li><li id='logoutButton'></li></ul>";
}
if(productArr == null || total == 0 ){
	disabled = "disabled";
}
String strTotal = format.format(total);
String strTotalGST = format.format(total*1.07);
Session.removeAttribute("productID");
%>
<title>Digit Games &mdash; Shopping Cart</title>
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


<link rel="stylesheet" href="css/aos.css">

<link rel="stylesheet" href="css/style.css">

</head>

<body>

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


								<%=Header%>

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
						<%=AdminPage%>
					</ul>
				</div>
			</nav>
		</header>
		<div class="bg-light py-3">
			<div class="container">
				<div class="row">
					<div class="col-md-12 mb-0">
						<a href="index.jsp">Home</a> <span class="mx-2 mb-0">/</span> <strong
							class="text-black">Cart</strong>
					</div>
				</div>
			</div>
		</div>
		<div class="site-section">
			<div class="container">
				<div class="row mb-5">
					<!--  <form class="col-md-12" action='index.jsp' method="post">-->
						<div class="site-blocks-table col-md-12">
							<table class="table table-bordered">
								<thead>
									<tr>
										<th class="product-thumbnail">Image</th>
										<th class="product-name">Product</th>
										<th class="product-price">Price</th>
										<th class="product-quantity">Quantity</th>
										<th class="product-total">Total</th>
										<th class="product-total">Action</th>
									</tr>
								</thead>
								<tbody>
									<%=rows%>
								</tbody>
							</table>
						</div>
					<!--</form>-->
				</div>

				<div class="row">
					<div class="col-md-6">
						<div class="row mb-5">
							<div class="col-md-6 mb-3 mb-md-0">
								<a href='http://localhost:12978/ST0510-JAD/invalidate?rd=cart'><button
										class="btn btn-primary btn-sm btn-block">Clear Cart</button></a>
							</div>
							<div class="col-md-6">
								<a href='all-listings.jsp? '><button
										class="btn btn-outline-primary btn-sm btn-block">Continue
										Shopping</button></a>
							</div>
						</div>
						<div class="row">
							<div class="col-md-12">
								<label class="text-black h4" for="coupon">Coupon</label>
								<p>Enter your coupon code if you have one.</p>
							</div>
							<div class="col-md-8 mb-3 mb-md-0">
								<input type="text" class="form-control py-3" id="coupon"
									placeholder="Coupon Code">
							</div>
							<div class="col-md-4">
								<button class="btn btn-primary btn-sm">Apply Coupon</button>
							</div>
						</div>
					</div>
					<div class="col-md-6 pl-5">
						<div class="row justify-content-end">
							<div class="col-md-7">
								<div class="row">
									<div class="col-md-12 text-right border-bottom mb-5">
										<h3 class="text-black h4 text-uppercase">Cart Totals</h3>
									</div>
								</div>
								<div class="row mb-3">
									<div class="col-md-6">
										<span class="text-black">Total</span>
									</div>
									<div class="col-md-6 text-right">
										<strong class="text-black">$<%=strTotal%></strong>
									</div>
								</div>
								<div class="row mb-2">
									<div class="col-md-6">
										<span class="text-black">Total(With GST)</span>
									</div>
									<div class="col-md-6 text-right">
										<strong class="text-black">$<%=strTotalGST%></strong>
									</div>
								</div>
								<div class="row">
									<div class="col-md-12">
										<button class="btn btn-primary btn-lg py-3 btn-block"
											onclick="window.location='checkout.jsp? '" <%=disabled%>>Proceed
											To Checkout</button>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
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