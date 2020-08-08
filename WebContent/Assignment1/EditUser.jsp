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
<%  
	HttpSession Session = request.getSession();
	int userid = 0; 
	String role = "";
	String roles = "";
	String dbrole = "";
	String selected = "";
	String AdminPage = "";
	String Header = "<ul><li><a href='loginpage.jsp'>Login</a></li><li><a href='register.jsp'>Register</span></a></li><li id='logoutButton'></li></ul>";
	String Error = request.getParameter("Err");
	String username = "";
	String password = "";
	String email = "";
	String firstname = "";
	String lastname = "";
	String phonenumber = "";
	String address = "";
	String company = "";
	String cardnumber = "";
	String CCV = "";
	String expirydate = "";
	try{
		userid = (int)Session.getAttribute("userid");  
		role = (String)Session.getAttribute("role");
	}catch(Exception e){
		response.sendRedirect("404.jsp");
	} 
	try{
    	//if(Error.equals("NullError")){
    	//	out.print("<script>alert('Please fill in all required fields!')</script>");
    	//}
    	if(Error.equals("NumberFormatError")){
			out.print("<script>alert('Prices are not in numbers format!')</script>");
    	}
		if(Error.equals("NegativeError")){
			out.print("<script>alert('Do not enter negative numbers!')</script>");
    	}
		if(Error.equals("AddSuccess")){
			out.print("<script>alert('Changes saved.')</script>");
    	}
		
    }catch(Exception e){
    		
    }    
	try{
		if(role.equals("admin")){ 
            AdminPage = "<li><a href='http://localhost:12978/ST0510-JAD/allUsersDetails'>User Control</a></li>"
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
		  	conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=admin&password=@dmin1!&serverTimezone=UTC&characterEncoding=latin1");
		  	}catch(Exception e){
			    out.print(e);
		  	}
		  	if(conn == null){
		  		out.print("Conn Error");
		  		conn.close();
		  	}else{
		  		  String query = "SELECT * FROM users WHERE user_id ="+userid;
		  		  Statement st = conn.createStatement();
			      ResultSet rs = st.executeQuery(query);
			      while(rs.next()){
			    		username = rs.getString("username");
			    		password = rs.getString("password");
			    		dbrole = rs.getString("role");
			    		email = rs.getString("email");
			    		firstname = rs.getString("firstname");
			    		lastname = rs.getString("lastname");
			    		phonenumber = rs.getString("phonenumber");
			    		address = rs.getString("address");
			    		company = rs.getString("company");
			    		cardnumber = rs.getString("cardnumber");
			    		CCV = rs.getString("CCV");
			    		expirydate = rs.getString("expirydate");
			      }
			      query = "SELECT * FROM roles";
			      st = conn.createStatement();
			      rs = st.executeQuery(query);
			      while(rs.next()){
			    	if(dbrole.equals(rs.getString("role_name"))){
			    		selected = "selected";
			    	}else{
			    		selected = "";
			    	}
			      	roles += "<option value='"+rs.getString("role_name")+"'"+selected+">"+rs.getString("role_name")+"</option>";
			      }
			      
		  	}
    	%>
<head>
  <title>Digit Games &mdash; Upload Product</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

  <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Mukta:300,400,700">
  <link rel="stylesheet" href="fonts/icomoon/style.css">

  <link rel="stylesheet" href="css/bootstrap.min.css">
  <link rel="stylesheet" href="css/magnific-popup.css">
  <link rel="stylesheet" href="css/jquery-ui.css">
  <link rel="stylesheet" href="css/owl.carousel.min.css">
  <link rel="stylesheet" href="css/owl.theme.default.min.css">

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
              class="text-black">Edit User</strong></div>
        </div>
      </div>
    </div>

    <div class="site-section">
      <div class="container">
        <div class="row">

          <div class="col-md-12">
            <h2 class="h3 mb-3 text-black">Edit User(Admin)</h2>
          </div>

          <div class="col-md-12">

            <form action="http://localhost:12978/ST0510-JAD/editUserAdmin" method="post">

              <div class="p-3 p-lg-5 border row justify-content-center">

                <div class="col-md-10">

                  <div class="form-group row">
                    <div class="col-md-6">
                      <label for="title" class="text-black">Username <span class="text-danger">*</span></label>
                      <input type="text" class="form-control" name="username" value="<%=username%>" >
                    </div>

                  </div>


                  <div class="form-group row">

                    <div class="col-md-6">
                      <label for="c_price" class="text-black">Password <span class="text-danger">*</span></label>
                      <input type="text" class="form-control" value="<%=password%>" name="password">
                    </div>

                  </div>

                  <div class="form-group row">

                    <div class="col-md-6">
                      <label for="r_price" class="text-black">Email <span class="text-danger">*</span></label>
                      <input type="text" class="form-control" name="email" value="<%=email %>">
                    </div>

                  </div>
                  
                  <div class="form-group row">

                    <div class="col-md-6">
                      <label for="productCat" class="text-black">User Role<span
                          class="text-danger">*</span></label>
                       <br>
                      <select name="userrole">
                      		<%=roles%>
                      	</select>
                    </div>

                  </div>

                  <div class="form-group row">

                    <div class="col-md-6">
                      <label for="stockQty" class="text-black">First Name<span class="text-danger">*</span></label>
                      <input type="text" class="form-control" name="firstname" value="<%=firstname%>">
                    </div>

                  </div>

                  <div class="form-group row">

                    <div class="col-md-8">
                      <label for="briefDesc" class="text-black">Last Name</label>
                      <input type="text" name="lastname" class="form-control" value="<%=lastname %>"></input>
                    </div>

                  </div>

                  <div class="form-group row">

                    <div class="col-md-8">
                      <label for="fullDesc" class="text-black">Phone Number</label>
                      <input type="text" name="phonenumber" class="form-control" value="<%=phonenumber%>"></input>
                    </div>

                  </div>
                  
                  <div class="form-group row">

                    <div class="col-md-6">
                      <label for="ImagePath" class="text-black">Address</label>
                      <input type="text" name="address" class="form-control" value="<%=address%>"></input>
                    </div>

                  </div>
                   <div class="form-group row">

                    <div class="col-md-6">
                      <label for="ImagePath" class="text-black">Company</label>
                      <input type="text" name="company" id="image" class="form-control" value="<%=company%>"></input>
                    </div>

                  </div>
                   <div class="form-group row">

                    <div class="col-md-6">
                      <label for="ImagePath" class="text-black">Card Number</label>
                      <input type="text" name="cardnumber" class="form-control" value="<%=cardnumber%>"></input>
                    </div>

                  </div>
                  <div class="form-group row">

                    <div class="col-md-6">
                      <label for="ImagePath" class="text-black">CCV</label>
                      <input type="text" name="CCV" class="form-control" value="<%=CCV%>" length=4></input>
                    </div>

                  </div>
                  <div class="form-group row">

                    <div class="col-md-6">
                      <label for="ImagePath" class="text-black">Expiry Date</label>
                      <input type="text" name="expirydate" class="form-control" value="<%=expirydate%>" pattern="(?:0[1-9]|1[0-2])/[0-9]{2}" ></textarea>
                    </div>

                  </div>

                </div>

                <div class="form-group col-md-12 mb-5 d-flex flex-row-reverse">

                  <div class="col-lg-4 p-12">
                    <input id="uploadProd" type="submit" class="btn btn-primary btn-lg btn-block"value="Edit User">
                  </div>

                </div>
              </div>

            </form>
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