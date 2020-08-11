<%-- 
==========================================
Author: Alastair Tan (P1936096) & Yu Dong En (P1936348)
Class: DIT/2A/02
Description: ST0510 / JAD Assignment 1
===========================================
--%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="myclasses.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.ArrayList"%>
<%@page import="java.text.DecimalFormat"%>
<!DOCTYPE html>
<html lang="en">

<head>
<%
	DecimalFormat format = new DecimalFormat("#0.00");
HttpSession Session = request.getSession();

String filterSuffix = "";
String orderSort = request.getParameter("orderSort");
String sortSuffix = "";
String filterCategory = request.getParameter("filterCategory");
String filterValue = request.getParameter("filterValue") == null ? "" : request.getParameter("filterValue");
String timeSort = request.getParameter("timeSort");
String timeSuffix = "";

String AdminPage = "";
String dbUserID = "";

String options = "";
String orders = "";

String userTotals = "";

String dbRoleID = "";//Tie this to the thing
String roleName = "";

String rows = "";
String roleTable = "";
String Error = request.getParameter("Err");
int userid = 0;
String role = "";

try {
	userid = (int) Session.getAttribute("userid");
	role = (String) Session.getAttribute("role");
} catch (Exception e) {
	response.sendRedirect("404.jsp");
}

ArrayList<user> Tab1 = (ArrayList<user>) Session.getAttribute("Tab1");
ArrayList<role> Tab2 = (ArrayList<role>) Session.getAttribute("Tab2");
ArrayList<order> Tab3 = (ArrayList<order>) Session.getAttribute("Tab3");
ArrayList<user> Tab4 = (ArrayList<user>) Session.getAttribute("Tab4");
String Path = request.getContextPath() + "/";
%>
<title>Digit Games &mdash; User Control</title>
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

<script>
	if (<%=Error %> == "NullError") {
		alert('Please fill in all required fields!')
	}
	
	if (<%=Error %> == "DelSuccess") {
		alert('Successfully deleted.')
	}
	
	if (<%=Error %> == "AddSuccess") {
		alert('Successfully added.')
	}
	
	if (<%=Error %> == "EditSuccess") {
		alert('Changes saved.')
	}

	$(document).ready(function() {
		var modal = document.getElementById("myModal");
		var span = document.getElementById("close");

		$('body').on('click', '.deleteUser', function(event) {
			console.log("pressed");
			modal.style.display = "block";

			// When the user clicks on <span> (x), close the modal
			span.onclick = function() {
				document.getElementById("myModal").style.display = "none";
			}
		})

	});

	$(document).ready(function() {
		var modal = document.getElementById("addRoleModal");
		var span = document.getElementById("close2");

		$('body').on('click', '.addRole', function(event) {
			console.log("pressed");
			modal.style.display = "block";

			// When the user clicks on <span> (x), close the modal
			span.onclick = function() {
				document.getElementById("addRoleModal").style.display = "none";
			}
		})

	});

	$(document).ready(function() {
		var modal = document.getElementById("delRoleModal");
		var span = document.getElementById("close3");

		$('body').on('click', '.deleteRole', function(event) {
			console.log("pressed");
			modal.style.display = "block";

			// When the user clicks on <span> (x), close the modal
			span.onclick = function() {
				document.getElementById("delRoleModal").style.display = "none";
			}
		})

	});
</script>
</head>

<body>

	<!-- The Modal (Delete User) -->
	<div id="myModal" class="modal">

		<!-- Modal content -->
		<div class="modal-content">
			<span id="close" class="close">&times;</span>
			<div class="form-group row">

				<div class="col-md-5">
					<form>
						<h3 mb-5 class="text-dark">Are you sure you want to delete
							this user?</h3>

						<a href="DeleteUser.jsp?dbUserID=<%=dbUserID%>"
							class="btn btn-sm btn-danger">Delete User</a>
					</form>
				</div>

			</div>
		</div>

	</div>


	<!-- The Modal (Add Role) -->
	<div id="addRoleModal" class="modal">

		<!-- Modal content -->
		<div class="modal-content">
			<span id="close2" class="close">&times;</span>
			<div class="form-group row">

				<div class="col-md-5">
					<form action="AddRole.jsp" method="post">
						<h3 mb-5 class="text-dark">Add Role</h3>

						<div class="col-md-12 mt-4">
							<label for="dbRole" class="text-black">New Role Name:</label> <input
								type="text" class="form-control" id="dbRole" name="dbRole"
								placeholder="Role Name">
						</div>

						<div class="col-lg-3 p-3 mt-4">
							<input id="uploadProd" type="submit" class="btn btn-sm btn-info"
								value="Add Role">
						</div>

					</form>
				</div>

			</div>
		</div>

	</div>



	<!-- The Modal (Delete Role) -->
	<div id="delRoleModal" class="modal">

		<!-- Modal content -->
		<div class="modal-content">
			<span id="close3" class="close">&times;</span>
			<div class="form-group row">

				<div class="col-md-5">
					<form>
						<h3 mb-5 class="text-dark">Are you sure you want to delete
							this role?</h3>

						<a href="DeleteRole.jsp?dbRoleID=<%=dbRoleID%>"
							class="btn btn-sm btn-danger">Delete Role</a>
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
								<a href="index.jsp" class="js-logo-clone">Digit Games</a>
							</div>
						</div>

						<div class="col-6 col-md-4 order-3 order-md-3 text-right">
							<div class="site-top-icons">
								<%
									if (role.equals("admin") || role.equals("member")) {
								%>
								<ul>
									<li><a href='cart.jsp' class='site-cart  mr-3'><span
											class='icon icon-shopping_cart'></span></a></li>
									<li><a href='profile.jsp'>Edit Profile</a></li>
									<li><a href='${pageContext.request.contextPath}/invalidate?rd=index'
										class='btn btn-sm btn-secondary'>Logout</span></a></li>
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
						<li><a href="index.jsp">Home</a></li>
						<li><a href="about.jsp">About</a></li>
						<li><a href="categories.jsp">Shop</a></li>
						<li><a href="all-listings.jsp">Catalogue</a></li>
						<li><a href="contact.jsp">Contact</a></li>
						<%
							if (role.equals("admin")) {
						%>
						<li><a href='${pageContext.request.contextPath}/allUsersDetails'>User Control</a></li>
						<li><a href='admin-page.jsp'>Product Control</a></li>
						<li><a href='view-order.jsp'>View Order History</a></li>
						<%
							} else if (role.equals("member")) {
						%>
						<li><a href='view-order.jsp'>View Order History</a></li>
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
							class="text-black">Administrator Page (Users)</strong>
					</div>
				</div>
			</div>
		</div>

		<div class="site-section">
			<div class="container-fluid">

				<div class="col-md-12">
					<h2 class="h3 mb-5 text-black">Admin Control Page (All Users)
					</h2>
				</div>

				<div class="col-md-12 mb-5 d-flex flex-row-reverse">
					<div class="p-2">
						<a href="#" class="addRole btn btn-sm btn-dark">Add New Role</a>
					</div>
					<div class="p-2">
						<a href="${pageContext.request.contextPath}/Assignment1/adduser.jsp" class="addRole btn btn-sm btn-secondary">Add New
							User</a>
					</div>

				</div>

				<!-- TABS -->
				<div class="users-tab">
					<button class="users-tablinks btn btn-secondary"
						onclick="openCity(event, 'allUsersTab')" id="defaultOpen">All
						Users</button>
					<button class="users-tablinks btn btn-secondary"
						onclick="openCity(event, 'allRolesTab')">Roles</button>
					<button class="users-tablinks btn btn-secondary"
						onclick="openCity(event, 'Orders')">Orders</button>
					<button class="users-tablinks btn btn-secondary"
						onclick="openCity(event, 'userTotal')">User Total</button>
				</div>

				<div id="allUsersTab" class="users-tabcontent">
					<div class="mt-4 ml-4">
						<h3>
							<text class="text-dark font-weight-bold">Users List</text>
						</h3>
						<form action="${pageContext.request.contextPath}/allUsersDetails" method='post'>
							<input type='text' name='userSearch'></input> <input
								type='submit' placeholder="Search For User"></input>
						</form>
						<div class="mt-4">
							<table class="table table-hover">
								<thead>
									<tr>
										<th scope="col">#</th>
										<th scope="col">Username</th>
										<th scope="col">First Name</th>
										<th scope="col">Last Name</th>
										<th scope="col">Email</th>
										<th scope="col">Role</th>
										<th scope="col">Phone Number</th>
										<th scope="col">Card Number</th>
										<th scope="col">Actions</th>
									</tr>
								</thead>
								<tbody>
									<% 
									if (Tab1 != null && Tab1.size() > 0) {
										for (user user : Tab1) { 
									%>
									<tr>
										<th scope='row'> <%=user.getUserid() %></th>
										<td><%=user.getUsername() %></td>
										<td><%=user.getFirstname() %></td>
										<td><%=user.getLastname() %></td>
										<td><%=user.getEmail() %></td>
										<td><%=user.getRole() %></td>
										<td><%=user.getPhonenumber() %></td>
										<td><% if (user.getCardnumber() != null) { %> <%=user.getCardnumber().replaceFirst(".{12}", "**************") %> <% } else { %> null <% } %></td>
										<td>
											<div class='row'>
												<div class='col-md-8'>
													<div class='ml-2 col-md-1'>
														<a href='EditUser.jsp'><span class='icon icon-pencil'></span></a>
													</div>
													<div class='ml-2 col-md-1'>
														<a href='#' class='deleteUser'><span class='icon icon-trash'></span></a>
													</div>
												</div>
											</div>
										</td>
									</tr>
									<%
										}
									} else {
									%>
									<tr>
										<td colspan="10">No users found.</td>
									</tr>
									<% 
									} 
									%>
								</tbody>
							</table>
						</div>
					</div>
				</div>

				<div id="allRolesTab" class="users-tabcontent">
					<div class="mt-4 ml-4">
						<h3>
							<text class="text-dark font-weight-bold">Roles List</text>
						</h3>
						<div class="mt-4">
							<table class="table table-hover">
								<thead>
									<tr>
										<th scope="col">#</th>
										<th scope="col">Role Names</th>
										<th scope="col">Actions</th>
									</tr>
								</thead>
								<tbody>
									<%
									if (Tab2 != null && Tab2.size() > 0) {
										for (role userRole : Tab2) {
									%>
									<tr>
										<th scope='row'><%=userRole.getRoleid() %></th>
										<td><%=userRole.getRolename() %></td>
										<td>
											<div class='row'>
												<div class='col-md-3'>
													<a href='edit-role.jsp?dbRoleID=<%=userRole.getRoleid() %>'><span class='icon icon-pencil'></span></a>
												</div>
												<div class='col-md-2'>
													<a href='#' class='deleteRole'><span class='icon icon-trash'></span></a>
												</div>
											</div>
										</td>
									</tr>
									<%
										}
									} else {
									%>
									<tr>
										<td colspan="3">No roles found.</td>
									</tr>
									<%
									}
									%>
								</tbody>
							</table>
						</div>
					</div>
				</div>

				<div id="Orders" class="users-tabcontent">
					<div class="mt-4 ml-4">
						<h3>
							<text class="text-dark font-weight-bold">Orders List</text>
						</h3>
						<div class="btn-group">
							<button type="button"
								class="btn btn-secondary btn-sm dropdown-toggle"
								id="dropdownMenuReference" data-toggle="dropdown">Sorting</button>
							<div class="dropdown-menu"
								aria-labelledby="dropdownMenuReference">
								<a class="dropdown-item"
									href="${pageContext.request.contextPath}/allUsersDetails?orderSort=DTime&timeSort=<%=timeSort%>">Time</a>
								<a class="dropdown-item"
									href="${pageContext.request.contextPath}/allUsersDetails?orderSort=ATime&timeSort=<%=timeSort%>">Time,
									Descending</a>
								<div class="dropdown-divider"></div>
								<a class="dropdown-item"
									href="${pageContext.request.contextPath}/allUsersDetails?orderSort=DTotal&timeSort=<%=timeSort%>">Total</a>
								<a class="dropdown-item"
									href="${pageContext.request.contextPath}/allUsersDetails?orderSort=ATotal&timeSort=<%=timeSort%>">Total,
									Descending</a>
								<div class="dropdown-divider"></div>
								<a class="dropdown-item"
									href="${pageContext.request.contextPath}/allUsersDetails?orderSort=DQuantity&timeSort=<%=timeSort%>">Quantity</a>
								<a class="dropdown-item"
									href="${pageContext.request.contextPath}/allUsersDetails?orderSort=AQuantity&timeSort=<%=timeSort%>">Quantity,
									Descending</a>
							</div>
						</div>
						<div class="m-3 btn-group">
							<button type="button"
								class="btn btn-secondary btn-sm dropdown-toggle"
								id="dropdownMenuReference" data-toggle="dropdown">Filter
								By Date</button>
							<div class="dropdown-menu"
								aria-labelledby="dropdownMenuReference">
								<a class="dropdown-item"
									href="${pageContext.request.contextPath}/allUsersDetails?orderSort=<%=orderSort%>&timeSort=Today">Today</a>
								<div class="dropdown-divider"></div>
								<a class="dropdown-item"
									href="${pageContext.request.contextPath}/allUsersDetails?orderSort=<%=orderSort%>&timeSort=Week">This
									Week</a>
								<div class="dropdown-divider"></div>
								<a class="dropdown-item"
									href="${pageContext.request.contextPath}/allUsersDetails?orderSort=<%=orderSort%>&timeSort=Month">This
									Month</a>
								<div class="dropdown-divider"></div>
								<a class="dropdown-item"
									href="${pageContext.request.contextPath}/allUsersDetails?orderSort=<%=orderSort%>&">None</a>
							</div>
						</div>
						<form
							action="${pageContext.request.contextPath}/allUsersDetails?orderSort=<%=orderSort%>&timeSort=<%=timeSort%>"
							method='post'>
							<label>Search by:</label> <select name="filterCategory">
								<option value='name' <%if (filterCategory != null) { if (filterCategory.equals("name")) { %> selected <% } } else {%> selected <%}%>>Product</option>
								<option value='username' <%if (filterCategory != null) { if (filterCategory.equals("username")) { %> selected <% } } %>>Username</option>
								<option value='email' <%if (filterCategory != null) { if (filterCategory.equals("email")) { %> selected <% } } %>>Email</option>
								<option value='phonenumber' <%if (filterCategory != null) { if (filterCategory.equals("phonenumber")) { %> selected <% } } %>>Phone Number</option>
								<option value='cardnumber' <%if (filterCategory != null) { if (filterCategory.equals("cardnumber")) { %> selected <% } } %>>Card Number</option>
								<option value='ccv' <%if (filterCategory != null) { if (filterCategory.equals("ccv")) { %> selected <% } } %>>CCV</option>
								<option value='expirydate' <%if (filterCategory != null) { if (filterCategory.equals("expirydate")) { %> selected <% } } %>>Expiry Date</option>
								<option value='address' <%if (filterCategory != null) { if (filterCategory.equals("address")) { %> selected <% } } %>>Address</option>
								<option value='zipcode' <%if (filterCategory != null) { if (filterCategory.equals("zipcode")) { %> selected <% } } %>>Zip Code</option>
								<option value='company' <%if (filterCategory != null) { if (filterCategory.equals("company")) { %> selected <% } } %>>Company</option>
								<option value='quantity' <%if (filterCategory != null) { if (filterCategory.equals("quantity")) { %> selected <% } } %>>Quantity</option>
								<option value='total' <%if (filterCategory != null) { if (filterCategory.equals("total")) { %> selected <% } } %>>Total</option>
								<option value='notes' <%if (filterCategory != null) { if (filterCategory.equals("notes")) { %> selected <% } } %>>Notes</option>
							</select> <br> <input type='text' name='filterValue'
								value="<%=filterValue%>" placeholder="Keyword"></input> <input
								type='submit' value="Search">
						</form>
						<div class="mt-4">
							<table class="table table-hover">
								<thead>
									<tr>
										<th scope="col">Product</th>
										<th scope="col">Username</th>
										<th scope="col">Email</th>
										<th scope="col">Phone Number</th>
										<th scope="col">Card Number</th>
										<th scope="col">CCV</th>
										<th scope="col">Expiry Date</th>
										<th scope="col">Address</th>
										<th scope="col">Zip Code</th>
										<th scope="col">Company</th>
										<th scope="col">Quantity</th>
										<th scope="col">Total</th>
										<th scope="col">Time</th>
										<th scope="col">Notes</th>
									</tr>
								</thead>
								<tbody>
									<%
									if (Tab3 != null && Tab3.size() > 0) {
										for (order order : Tab3) {
									%>
									<tr>
										<td><%=order.getOrderProduct() %></td>
										<td><%=order.getOrderUsername() %></td>
										<td><%=order.getOrderEmail() %></td>
										<td><%=order.getOrderPhoneNumber() %></td>
										<td><%=order.getOrderCardNumber().replaceFirst(".{12}", "**************") %></td>
										<td><%=order.getOrderCCV() %></td>
										<td><%=order.getOrderExpiryDate() %></td>
										<td><%=order.getOrderAddress() %></td>
										<td><%=order.getOrderZipCode() %></td>
										<td><%=order.getOrderCompany() %></td>
										<td><%=order.getOrderQuantity() %></td>
										<td><%=format.format(order.getOrderTotal()) %></td>
										<td><%=order.getOrderDate() %></td>
										<td><%=order.getOrderNotes() %></td>
									</tr>
									<%
										}
									} else {
									%>
									<tr>
										<td colspan="14">No orders found.</td>
									</tr>
									<%
									}
									%>
								</tbody>
							</table>
						</div>
					</div>
				</div>

				<div id="userTotal" class="users-tabcontent">
					<div class="mt-4 ml-4">
						<h3>
							<text class="text-dark font-weight-bold">Users Max
							Purchase</text>
						</h3>
						<form action="${pageContext.request.contextPath}/allUsersDetails" method='post'>
							<input type='text' name='userSearch4'></input> <input
								type='submit' placeholder="Search For User"></input>
						</form>
						<div class="mt-4">
							<table class="table table-hover">
								<thead>
									<tr>

										<th scope="col">Username</th>
										<th scope="col">Email</th>
										<th scope="col">Phone Number</th>
										<th scope="col">Total</th>

									</tr>
								</thead>
								<tbody>
									<%
									if (Tab4 != null && Tab4.size() > 0) {
										for (user user : Tab4) {
									%>
									<tr>
										<td><%=user.getUsername() %></td>
										<td><%=user.getEmail() %></td>
										<td><%=user.getPhonenumber() %></td>
										<td>$<%=format.format(user.getTotal()) %></td>
									</tr>
									<%
										}
									} else {
									%>
									<tr>
										<td colspan="4">No Orders found.</td>
									</tr>
									<%
									}
									%>
								</tbody>
							</table>
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

	<script>
		function openCity(evt, cityName) {
			var i, tabcontent, tablinks;
			tabcontent = document.getElementsByClassName("users-tabcontent");
			for (i = 0; i < tabcontent.length; i++) {
				tabcontent[i].style.display = "none";
			}
			tablinks = document.getElementsByClassName("users-tablinks");
			for (i = 0; i < tablinks.length; i++) {
				tablinks[i].className = tablinks[i].className.replace(
						" active", "");
			}
			document.getElementById(cityName).style.display = "block";
			evt.currentTarget.className += " active";
		}

		// Get the element with id="defaultOpen" and click on it
		document.getElementById("defaultOpen").click();
	</script>

</body>

</html>