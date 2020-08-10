<%-- 
==========================================
Author: Alastair Tan (P1936096) & Yu Dong En (P1936348)
Class: DIT/2A/02
Description: ST0510 / JAD Assignment 1
===========================================
--%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ page import="java.sql.*" %>
<%@page import="java.text.DecimalFormat" %>
<!DOCTYPE html>
<html lang="en">

<head>
<%  java.util.Date dt = new java.util.Date();
	java.text.SimpleDateFormat sdf = 
    new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String currentTime = sdf.format(dt);
	String products = "";
	HttpSession Session = request.getSession();
	String name = "";
	String r_price = "";
	String AdminPage = "";
	double total = 0.00;
	String Header = "<ul><li><a href='loginpage.jsp'>Login</a></li><li><a href='register.jsp'>Register</span></a></li><li id='logoutButton'></li></ul>";
	String role = "";
	int userid = 0;
	String company = request.getParameter("company");
	String address = request.getParameter("address");
	String country = request.getParameter("country");
	String zipcode = request.getParameter("zipcode");
	String cardnumber = request.getParameter("cardnumber");
	String CCV = request.getParameter("CCV");
	String expirydate = request.getParameter("expirydate");
	String notes = request.getParameter("notes");
	double ptotal = 0;
	
	String path = request.getContextPath() + "/";
	
	try{
		userid = (int)Session.getAttribute("userid");  
		role = (String)Session.getAttribute("role");
	}catch(Exception e){
		response.sendRedirect("404.jsp");
	}   
			try{
	        	if(role.equals("admin")){ 
	                AdminPage = "<li><a href='" + path + "allUsersDetails'>User Control</a></li>"
	                		+ "<li><a href='admin-page.jsp'>Product Control</a></li>"
	                		+ "<li><a href='view-order.jsp'>View Order History</a></li>";
	                		
	                Header = "<div class='site-top-icons'>"
	                        + "<ul><li><a href='cart.jsp' class='site-cart  mr-3'><span class='icon icon-shopping_cart'></span></a></li>"
	                          + "<li><a href='profile.jsp'>Edit Profile</a></li>" 
	                          + "<li><a href='" + path + "invalidate?rd=index' class='btn btn-sm btn-secondary'>Logout</span></a></li>" 
	                          + "<li id='logoutButton'></li></ul></div>";              
	             } else if (role.equals("member")) {
	            	  Header = "<div class='site-top-icons'>"
	                          + "<ul><li><a href='cart.jsp' class='site-cart  mr-3'><span class='icon icon-shopping_cart'></span></a></li>"
	                            + "<li><a href='profile.jsp'>Edit Profile</a></li>" 
	                            + "<li><a href='" + path + "invalidate?rd=index' class='btn btn-sm btn-secondary'>Logout</span></a></li>" 
	                            + "<li id='logoutButton'></li></ul></div>";     
	                  AdminPage = "<li><a href='view-order.jsp'>View Order History</a></li>";
	             }}catch(Exception e){// if no id or role is detected
        		  Header = "<ul><li><a href='loginpage.jsp'>Login</a></li><li><a href='register.jsp'>Register</span></a></li><li id='logoutButton'></li></ul>";
        	  }
    Connection conn = null;
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
  		String query = "";
  		for(int x = 0;((int[])Session.getAttribute("productArr")).length>x;x++){
  			query = "SELECT r_price FROM products WHERE product_id ="+((int[])Session.getAttribute("productArr"))[x];
  			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(query);
			while(rs.next()){
			    ptotal = rs.getDouble("r_price");
			}
  			if(((int[])Session.getAttribute("productArr"))[x] != 0){
		  		query = "UPDATE products SET stock_quantity = (products.stock_quantity-"+((int[])Session.getAttribute("quantityArr"))[x]+") WHERE product_id ="+((int[])Session.getAttribute("productArr"))[x];
		  		st = conn.createStatement();
				int rsint = st.executeUpdate(query);
				query = "INSERT INTO orders(address,country,zipcode,company,fk_userid,total,fk_productid,quantity,notes,cardnumber,CCV,expirydate,date) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)";
				PreparedStatement ppst = conn.prepareStatement(query);
				ppst.setString(1,address);
				ppst.setString(2,country);
				ppst.setString(3,zipcode);
				ppst.setString(4,company);
				ppst.setInt(5,userid);
				ppst.setDouble(6, ptotal * ((int[])Session.getAttribute("quantityArr"))[x]);
				ppst.setInt(7,((int[])Session.getAttribute("productArr"))[x]);
				ppst.setInt(8,((int[])Session.getAttribute("quantityArr"))[x]);
				ppst.setString(9,notes);
				ppst.setString(10,cardnumber);
				ppst.setString(11,CCV);
				ppst.setString(12,expirydate);
				ppst.setString(13,currentTime);
	  		  	rsint = ppst.executeUpdate();
			}
		}
  		conn.close();
  	}
        %>
  <title>Digit Games&mdash;</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

  <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Mukta:300,400,700">
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

            <div class="col-6 col-md-4 order-2 order-md-1 site-search-icon text-left">
              
            </div>

            <div class="col-12 mb-3 mb-md-0 col-md-4 order-1 order-md-2 text-center">
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
      <nav class="site-navigation text-right text-md-center" role="navigation">
        <div class="container">
          <ul class="site-menu js-clone-nav d-none d-md-block">
            <li><a href="index.jsp? ">Home</a></li>
            <li><a href="about.jsp? ">About</a></li>
            <li><a href="categories.jsp? ">Shop</a></li>
            <li><a href="all-listings.jsp? ">Catalogue</a></li>
            <li><a href="contact.jsp? ">Contact</a></li>
            <%=AdminPage %>
          </ul>
        </div>
      </nav>
    </header>

    <div class="bg-light py-3">
      <div class="container">
        <div class="row">
          <div class="col-md-12 mb-0"><a href="index.jsp">Home</a> <span class="mx-2 mb-0">/</span> <strong
              class="text-black">Contact</strong></div>
        </div>
      </div>
    </div>

    <div class="site-section">
      <div class="container">
        <div class="row">
          <div class="col-md-12 text-center">
            <span class="icon-check_circle display-3 text-success"></span>
            <h2 class="display-3 text-black">Thank you!</h2>
            <p class="lead mb-5">Your order has been successfully completed.</p>
            <p><a href='<%=path %>invalidate?rd=cart' class="btn btn-sm btn-primary">Back to Cart</a></p>
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
                <li><a href="#" class="link">How do I change my account password?</a></li>
                <li><a href="#">How do I save my billing method?</a></li>
                <li><a href="#">Where can I checkout my cart?</a></li>
                <li><a href="#"><u><small>Any other questions? Check out our FAQs page here &rarr;</small></u></a></li>
              </ul>
            </div>
          </div>
          <div class="col-md-6 col-lg-3">
            <div class="block-5 mb-5">
              <h3 class="footer-heading mb-4">Contact Info</h3>
              <ul class="list-unstyled">
                <li class="address">123 Raffles Place, Singapore</li>
                <li class="phone"><a href="tel://23923929210">+65 9123 4567</a></li>
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
              <script>document.write(new Date().getFullYear());</script> All rights reserved | This template is made
              with <i class="icon-heart" aria-hidden="true"></i> by <a href="https://colorlib.com" target="_blank"
                class="text-primary">Colorlib</a>
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