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
<%@ page import="java.util.ArrayList" %>
<%@page import="java.text.DecimalFormat" %>
<%@ page import ="myclasses.*" %>
<!DOCTYPE html>
<html lang="en">

<head>
<%  
	String products = "";
	HttpSession Session = request.getSession();
	DecimalFormat format = new DecimalFormat("#0.00"); 
	String name = "";
	double r_price = 0.0;
	String AdminPage = "";
	String dtotal = "";
	String GST = "";
	double total = 0.00;
	String role = "";
	int userid = 0;
	
	String fname = "";
	String lname = "";
	String pnumber = "";
	String email = "";
	String address = "";
	String country = "";
	String zipcode = "";
	String company = "";
	String cardnumber = "";
	String CCV = "";
	String expirydate = "";
	
	ArrayList<cartObject> cart = (ArrayList<cartObject>)Session.getAttribute("cart");
	
	String Header = "<ul><li><a href='loginpage.jsp'>Login</a></li><li><a href='register.jsp'>Register</span></a></li><li id='logoutButton'></li></ul>";
	try{
		userid = (int)Session.getAttribute("userid");  
		role = (String)Session.getAttribute("role");
	}catch(Exception e){
		response.sendRedirect("404.jsp");
	}
    Connection conn = null;
    try{
		  	Class.forName("com.mysql.jdbc.Driver");
		  	//conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
		  	conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=admin&password=@dmin1!&serverTimezone=UTC&characterEncoding=latin1");
    }catch(Exception e){
    	
	    out.print(e);
	    
  	}
    if(conn == null){
  		out.print("Conn Error");
  		conn.close();
  	}else{
  		try{
  			String query = "SELECT * FROM users WHERE user_id = "+userid;
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(query);
			
			while(rs.next()){
				address = rs.getString("address");
				country = rs.getString("country");
				zipcode = rs.getString("zipcode");
				company = rs.getString("company");
				cardnumber = rs.getString("cardnumber");
				CCV = rs.getString("CCV");
				expirydate = rs.getString("expirydate");
			}
			for(int x = 0;cart.size()>x;x++){
				name = cart.get(x).getProductName();
				r_price = cart.get(x).getProductPrice();
				total += r_price*cart.get(x).getProductQuantity();
				GST = format.format(total*.07);
				dtotal = format.format(total*1.07);
				products += "<tr><td>"+name+" <strong class='mx-2'>x</strong>"+cart.get(x).getProductQuantity()+"</td><td>$"+format.format(r_price*cart.get(x).getProductQuantity())+"</td></tr>";
			}
			
  		}catch(Exception e){
  			
  		}
		conn.close();
	}
        
        	  
        	  %>
  <title>Digit Games &mdash;Checkout</title>
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
              <form action="" class="site-block-top-search">
                <span class="icon icon-search2"></span>
                <input type="text" class="form-control border-0" placeholder="Search">
              </form>
            </div>

            <div class="col-12 mb-3 mb-md-0 col-md-4 order-1 order-md-2 text-center">
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
      <nav class="site-navigation text-right text-md-center" role="navigation">
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
          <div class="col-md-12 mb-0"><a href="index.jsp">Home</a> <span class="mx-2 mb-0">/</span> <a
              href="cart.jsp">Cart</a> <span class="mx-2 mb-0">/</span> <strong class="text-black">Checkout</strong>
          </div>
        </div>
      </div>
    </div>

    <div class="site-section">
      <div class="container">
        <div class="row">
          <div class="col-md-6 mb-5 mb-md-0">
            <h2 class="h3 mb-3 text-black">Billing Details</h2>
            <div class="p-3 p-lg-5 border">
              
              <form method="POST" id="details" action="http://localhost:12978/ST0510-JAD/checkout">
              
              <div class="form-group row">
              <div class="col-md-12">
                  <label for="c_companyname" class="text-black">Card Number </label>
                  <input type="text" class="form-control" id="c_companyname" name="cardnumber" value="<%=cardnumber%>">
                </div>
               <div class="col-md-5">
                  <label for="c_companyname" class="text-black">CCV </label>
                  <input type="text" class="form-control" id="c_companyname" name="CCV" value="<%=CCV%>" length=4><!-- Some CVVs are 4 digits -->
                </div>
                <div class="col-md-2">
                </div>
                <div class="col-md-5">
                  <label for="c_companyname" class="text-black">Expiry Date</label>
                  <input type="text" class="form-control" id="c_companyname" name="expirydate" value="<%=expirydate%>" pattern="(?:0[1-9]|1[0-2])/[0-9]{2}" placeholder="MM/YY">
                </div>
                <div class="col-md-12">
                  <label for="c_companyname" class="text-black">Company Name </label>
                  <input type="text" class="form-control" id="c_companyname" name="company" value="<%=company%>">
                </div>
              </div>

              <div class="form-group row">
                <div class="col-md-12">
                  <label for="c_address" class="text-black">Address <span class="text-danger">*</span></label>
                  <input type="text" class="form-control" id="c_address" name="address" placeholder="Street address" value="<%=address%>">
                </div>
              </div>

              <div class="form-group row">
                <div class="col-md-6">
                  <label for="c_state_country" class="text-black">State / Country <span
                      class="text-danger">*</span></label>
                  <input type="text" class="form-control" id="c_state_country" name="country" value="<%=country%>">
                </div>
                <div class="col-md-6">
                  <label for="c_postal_zip" class="text-black">Postal / Zip <span class="text-danger">*</span></label>
                  <input type="text" class="form-control" id="c_postal_zip" name="zipcode" value="<%=zipcode%>" length=6>
                </div>
              </div>



              <div class="form-group">
                <label for="c_order_notes" class="text-black">Order Notes</label>
                <textarea name="notes" id="c_order_notes" cols="30" rows="5" class="form-control"
                  placeholder="Write your notes here..." form="details"></textarea>
              </div>
              <input type="hidden" name="total" value="<%=dtotal%>"></input>
              </form>

            </div>
          </div>
          <div class="col-md-6">

            <div class="row mb-5">
              <div class="col-md-12">
                <h2 class="h3 mb-3 text-black">Coupon Code</h2>
                <div class="p-3 p-lg-5 border">

                  <label for="c_code" class="text-black mb-3">Enter your coupon code if you have one</label>
                  <div class="input-group w-75">
                    <input type="text" class="form-control" id="c_code" placeholder="Coupon Code"
                      aria-label="Coupon Code" aria-describedby="button-addon2">
                    <div class="input-group-append">
                      <button class="btn btn-primary btn-sm" type="button" id="button-addon2">Apply</button>
                    </div>
                  </div>

                </div>
              </div>
            </div>

            <div class="row mb-5">
              <div class="col-md-12">
                <h2 class="h3 mb-3 text-black">Your Order</h2>
                <div class="p-3 p-lg-5 border">
                  <table class="table site-block-order-table mb-5">
                    <thead>
                      <th>Product</th>
                      <th>Total</th>
                    </thead>
                    <tbody>
                      <%=products %>
                      <tr>
                        <td class="text-black ">GST</td>
                        <td class="text-black ">$<%=GST%></td>
                      </tr>
                      <tr>
                        <td class="text-black font-weight-bold"><strong>Order Total(With GST)</strong></td>
                        <td class="text-black font-weight-bold"><strong>$<%=dtotal %></strong></td>
                      </tr>
                    </tbody>
                  </table>

                 

                 

                  
                  </div>

                  <div class="form-group">
                    <button type="submit" form="details" class="btn btn-primary btn-lg py-3 btn-block">Place Order</button>
                  </div>

                </div>
              </div>
            </div>

          </div>
        </div>
        <!-- </form> -->
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