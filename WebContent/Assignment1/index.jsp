<%-- 
==========================================
Author: Alastair Tan (P1936096) & Yu Dong En (P1936348)
Class: DIT/2A/02
Description: ST0510 / JAD Assignment 1
===========================================
--%>
<%@page import="java.util.*"%>
<%@ page import="java.sql.*" %>
<%@page import="java.text.DecimalFormat" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html lang="en">
<%  DecimalFormat format = new DecimalFormat("#0.00"); 
	HttpSession Session = request.getSession();
	String AdminPage = "";
	String productID = "";
	String Name = "";
	String briefDescription = "";
	String detailedDescription = "";
	String cPrice = "";
	String rPrice = "";
	int stockQuantity = 0;
	int numberOfProd = 0;
	String productCat = "";
	String imageUrl = "";
	String query = "";
	String featuredProd = "";
	
	int rdmProdArr[] = new int [3];
	int discountInt = 0; 
	int roundDiscount = 0;
	double discount = 0.00;
	String discountMsg = "";
	String priceMsg = "";
	int userid = 0;  
	String role = "";
	
	String Header = "<ul><li><a href='loginpage.jsp'>Login</a></li><li><a href='register.jsp'>Register</span></a></li><li id='logoutButton'></li></ul>";
	try{
		userid = (int)Session.getAttribute("userid");  
		role = (String)Session.getAttribute("role");
	}catch(Exception e){
		
	} 
	try{
    	if(role.equals("admin")){ 
            AdminPage = "<li><a href='all-users.jsp'>User Control</a></li>"
            		+ "<li><a href='admin-page.jsp'>Product Control</a></li>"
            		+ "<li><a href='view-order.jsp'>View Order History</a></li>";
            		
            Header = "<div class='site-top-icons'>"
                    + "<ul><li><a href='cart.jsp' class='site-cart  mr-3'><span class='icon icon-shopping_cart'></span></a></li>"
                      + "<li><a href='profile.jsp'>Edit Profile</a></li>" 
                      + "<li><a href='http://localhost:12978/ST0510-JAD/invalidate?rd=index' class='btn btn-sm btn-secondary'>Logout</span></a></li>" 
                      + "<li id='logoutButton'></li></ul></div>";              
         } else if (role.equals("member")) {
        	  Header = "<div class='site-top-icons'>"
                      + "<ul><li><a href='cart.jsp' class='site-cart  mr-3'><span class='icon icon-shopping_cart'></span></a></li>"
                        + "<li><a href='profile.jsp'>Edit Profile</a></li>" 
                        + "<li><a href='http://localhost:12978/ST0510-JAD/invalidate?rd=index' class='btn btn-sm btn-secondary'>Logout</span></a></li>" 
                        + "<li id='logoutButton'></li></ul></div>";     
              AdminPage = "<li><a href='view-order.jsp'>View Order History</a></li>";
         }}catch(Exception e){// if no id or role is detected
        		  Header = "<ul><li><a href='loginpage.jsp'>Login</a></li><li><a href='register.jsp'>Register</span></a></li><li id='logoutButton'></li></ul>";
        	                 
        	  }
        Connection conn = null;
        
        try{
           Class.forName("com.mysql.jdbc.Driver");
         //conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
           conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/digitgames?characterEncoding=latin1","admin","@dmin1!");
           
         	if(conn == null){
		  		out.print("Conn Error");
		  		conn.close();
		  		
		  	} else {
		  		String query1 = "SELECT COUNT(*) FROM products";
		  		Statement st1 = conn.createStatement();
				ResultSet rs1 = st1.executeQuery(query1);
				while(rs1.next()) {
					numberOfProd = rs1.getInt("COUNT(*)");
					// System.out.println("total number:" + numberOfProd);
				} // while
				
				
		        ArrayList<Integer> rdmNoArr = new ArrayList<Integer>();
		        for (int i = 1; i <= numberOfProd; i++) {
		        	rdmNoArr.add(new Integer(i));
		        }
		        
		        Collections.shuffle(rdmNoArr);
		        for (int i = 0; i < 3; i++) {
		            rdmProdArr[i] = rdmNoArr.get(i);
		            
		        }
					

				
				for (int i = 0; i < 3; i++) {			// Loop for 3 times (3 products)
					

					query = "SELECT * FROM products WHERE product_id = " + rdmProdArr[i];
					Statement st = conn.createStatement();
					ResultSet rs = st.executeQuery(query);
					
	        		while (rs.next()) {
	        			productID = rs.getString("product_id");
	        	    	Name = rs.getString("name");
	        	    	briefDescription = rs.getString("brief_description");
	        	    	detailedDescription = rs.getString("detailed_description");
	        	    	cPrice =  format.format(rs.getDouble("c_price"));
	        	    	rPrice  =  format.format(rs.getDouble("r_price"));
          	          	discount = ((Double.parseDouble(rPrice) - Double.parseDouble(cPrice)) / Double.parseDouble(rPrice))*100;
          	        	discountInt = (int)Math.round(discount);
          	        	roundDiscount = (discountInt + 4) / 5 * 5;
          	        	
          	        	if (roundDiscount != 0) {
          	        		priceMsg = "<s>$ " + rPrice + "</s> $" + cPrice;
          	        		discountMsg = " (" + roundDiscount + "% Off)";
          	        	} else if (roundDiscount == 0){
          	        		priceMsg = "$" + rPrice;
          	        		discountMsg = "";
          	        	}
          	        	
	        	    	stockQuantity = rs.getInt("stock_quantity");
	        	    	productCat = rs.getString("product_cat");
	        	    	imageUrl = rs.getString("image");
	        	    	
	        	    	featuredProd += "<div class='item col-lg-4'>"
								+ "<div class='block-4 text-center'>"
								+ "<figure class='block-4-image'>"
								+ "<a href='product.jsp?productid="+productID+"'><img src=\"" + imageUrl + "\" alt=\"Image placeholder\" class=\"img-fluid\"></a>"
								+ "</figure>"
								+ "<div class=\"block-4-text p-4\">"
								+ "<h3 id=\"listingTitle\">"
								+ "<a href='product.jsp?productid="+productID+"'>" + Name + "</a>"
								+ "</h3>"
								+ "<p class=\"mt-3 mb-0\">" + briefDescription + "</p>"
								+ "<p class=\"text-primary font-weight-bold mt-4\">Price: </text>" + priceMsg + discountMsg + "</p>"
								+ "</div>"
								+ "</div>"
								+ "</div>";
		        	} // while
				} // for
			} // else
				conn.close();	
        } catch (Exception e) {
        	
        }

        
      %>
<head>

  <title>Digit Games &mdash; Home</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

  <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Mukta:300,400,700">
  <link rel="stylesheet" href="fonts/icomoon/style.css">
  <link rel="stylesheet" href="css/bootstrap.min.css">
  <link rel="stylesheet" href="css/magnific-popup.css">
  <link rel="stylesheet" href="css/jquery-ui.css">
  <link rel="stylesheet" href="css/owl.carousel.min.css">
  <link rel="stylesheet" href="css/owl.theme.default.min.css">

  <link rel="stylesheet" href="css/myoverride.css">

  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>


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
                <a href='index.jsp? ' class="js-logo-clone">Digit Games</a>
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

          <!-- Navigation Bar -->
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

    <div class="site-blocks-cover" style="background-image: url(images/razer_background3.jpg);" data-aos="fade">
      <div class="container">
        <div class="row align-items-start align-items-md-center justify-content-end">
          <div class="col-md-5 text-center text-md-left pt-5 pt-md-0">
            <h1 class="mb-2 text-light">Up to 70% Off!</h1>
            <div class="intro-text text-center text-md-left">
              <p class="mb-4 text-secondary">Terms and Conditions apply. While stock lasts. </p>
              <p>
                <a href="categories.jsp" class="btn btn-sm btn-dark">Shop Now</a>
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="site-section site-section-sm site-blocks-1">
      <div class="container">
        <div class="row">
          <div class="col-md-6 col-lg-4 d-lg-flex mb-4 mb-lg-0 pl-4" data-aos="fade-up" data-aos-delay="">
            <div class="icon mr-4 align-self-start">
              <span class="icon-truck"></span>
            </div>
            <div class="text">
              <h2 class="text-uppercase">Free Shipping</h2>
              <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus at iaculis quam. Integer accumsan
                tincidunt fringilla.</p>
            </div>
          </div>
          <div class="col-md-6 col-lg-4 d-lg-flex mb-4 mb-lg-0 pl-4" data-aos="fade-up" data-aos-delay="100">
            <div class="icon mr-4 align-self-start">
              <span class="icon-refresh2"></span>
            </div>
            <div class="text">
              <h2 class="text-uppercase">Free Returns</h2>
              <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus at iaculis quam. Integer accumsan
                tincidunt fringilla.</p>
            </div>
          </div>
          <div class="col-md-6 col-lg-4 d-lg-flex mb-4 mb-lg-0 pl-4" data-aos="fade-up" data-aos-delay="200">
            <div class="icon mr-4 align-self-start">
              <span class="icon-help"></span>
            </div>
            <div class="text">
              <h2 class="text-uppercase">Customer Support</h2>
              <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus at iaculis quam. Integer accumsan
                tincidunt fringilla.</p>
            </div>
          </div>
        </div>
      </div>
    </div>


    <div class="site-section block-3 site-blocks-2 bg-light">
      <div class="container">
        <div class="row justify-content-center">
          <div class="col-md-10 site-section-heading text-center pt-4">

            <h2>Featured Products</h2>

            <div id="showListings" class="row">
            
            <%=featuredProd %>

              <!-- CAN BE LOOPED -->
              


            </div>

          </div>
        </div>

        <div class="row">
          <div class="col-md-12">
            <div class="row" id="row">
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