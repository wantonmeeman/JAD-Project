<%@page import="java.sql.*"%>
<%@page import="java.text.DecimalFormat" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html lang="en">
<%  String userid = request.getParameter("userid");  
	String role = request.getParameter("role");
	String Header = "<ul><li><a href='loginpage.jsp'>Login</a></li><li><a href='register.jsp'>Register</span></a></li><li id='logoutButton'></li></ul>";
        try{
        	if(role.equals("admin")){ 
        		Header = "<div class='site-top-icons'><ul><li><a href='profile.jsp?userid="+userid+"&role="+role+"'>Edit Profile</a></li><li><a href='index.jsp?' class='btn btn-sm btn-secondary'>Logout</span></a></li><li id='logoutButton'></li></ul></div>";
	  	}}catch(Exception e){// if no id or role is detected
    	 Header = "<ul><li><a href='loginpage.jsp'>Login</a></li><li><a href='register.jsp'>Register</span></a></li><li id='logoutButton'></li></ul>";
    	}
        
        
        
	// Connection conn = null; 
	String Error = "";
	DecimalFormat format = new DecimalFormat("#0.00"); 
	String productID = request.getParameter("id");
	String name = request.getParameter("name");
	String c_price = "";
	String r_price = "";
	int stockQuantity = 0;
	String productCat = request.getParameter("productCat");
	String briefDesc = request.getParameter("briefDesc");
	String detailedDesc = request.getParameter("detailedDesc");
	
	
	try {

		Class.forName("com.mysql.jdbc.Driver");
		String connURL = "jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC";
		Connection conn = DriverManager.getConnection(connURL);
		Statement stmt = conn.createStatement();
		
		String sqlStr = "SELECT * FROM digitgames WHERE id = " + productID;
		ResultSet rs = stmt.executeQuery(sqlStr);

		rs.next();
    	name = rs.getString("name");
    	briefDesc = rs.getString("brief_description");
    	detailedDesc = rs.getString("detailed_description");
    	c_price = format.format(rs.getDouble("c_price"));
    	r_price = format.format(rs.getDouble("r_price"));
    	stockQuantity = rs.getInt("stock_quantity");
    	productCat = rs.getString("product_cat");

		// Step 7: Close connection
		conn.close();

	} catch (Exception e) {
		out.println("Error :" + e);
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
                <a href="index.jsp" class="js-logo-clone">Digit Games</a>
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
            <li><a href="index.jsp?userid=<%=userid%>&role=<%=role%>">Home</a></li>
            <li><a href="about.jsp?userid=<%=userid%>&role=<%=role%>">About</a></li>
            <li><a href="categories.jsp?userid=<%=userid%>&role=<%=role%>">Shop</a></li>
            <li><a href="all-listings.jsp?userid=<%=userid%>&role=<%=role%>">Catalogue</a></li>
            <li><a href="contact.jsp?userid=<%=userid%>&role=<%=role%>">Contact</a></li>
          </ul>
        </div>
      </nav>
    </header>

    <div class="bg-light py-3">
      <div class="container">
        <div class="row">
          <div class="col-md-12 mb-0"><a href="index.jsp">Home</a> <span class="mx-2 mb-0">/</span> <strong
              class="text-black">Upload Product</strong></div>
        </div>
      </div>
    </div>

    <div class="site-section">
      <div class="container">
        <div class="row">

          <div class="col-md-12">
            <h2 class="h3 mb-3 text-black">Upload Product (Admin)</h2>
          </div>

          <div class="col-md-12">

            <form action="#" method="post">

              <div class="p-3 p-lg-5 border row justify-content-center">

                <div class="col-md-10">

                  <div class="form-group row">

                    <div class="col-md-6">
                      <label for="title" class="text-black">Title <span class="text-danger">*</span></label>
                      <input type="text" class="form-control" id="title" name="title" placeholder="Title of Product">
                    </div>

                  </div>


                  <div class="form-group row">

                    <div class="col-md-6">
                      <label for="c_price" class="text-black">Current Price <span class="text-danger">*</span></label>
                      <input type="number" class="form-control" id="c_price" name="c_price"
                        placeholder="Current Price ($)">
                    </div>

                  </div>

                  <div class="form-group row">

                    <div class="col-md-6">
                      <label for="r_price" class="text-black">Retail Price <span class="text-danger">*</span></label>
                      <input type="number" class="form-control" id="r_price" name="r_price"
                        placeholder="Retail Price ($)">
                    </div>

                  </div>

                  <div class="form-group row">

                    <div class="col-md-6">
                      <label for="stockQty" class="text-black">Stock Quantity <span class="text-danger">*</span></label>
                      <input type="number" class="form-control" id="stockQty" name="stockQty" placeholder="Quantity">
                    </div>

                  </div>

                  <div class="form-group row">

                    <div class="col-md-6">
                      <label for="productCat" class="text-black">Product Category <span
                          class="text-danger">*</span></label>
                      <input type="text" class="form-control" id="productCat" name="productCat" placeholder="Category">
                    </div>

                  </div>

                  <div class="form-group row">

                    <div class="col-md-8">
                      <label for="briefDesc" class="text-black">Brief Description: </label>
                      <textarea name="briefDesc" id="briefDesc" cols="30" rows="5" class="form-control"
                        placeholder="Brief Description of Product"></textarea>
                    </div>

                  </div>

                  <div class="form-group row">

                    <div class="col-md-8">
                      <label for="fullDesc" class="text-black">Full Description: </label>
                      <textarea name="fullDesc" id="fullDesc" cols="30" rows="10" class="form-control"
                        placeholder="Detailed Description of Product"></textarea>
                    </div>

                  </div>

                </div>

                <div class="form-group col-md-12 mb-5 d-flex flex-row-reverse">

                  <div class="col-lg-3 p-3">
                    <input id="uploadProd" type="submit" class="btn btn-primary btn-lg btn-block"
                      value="Upload Product">
                  </div>

                </div>
              </div>

            </form>
          </div>

          <!-- <div class="col-md-5 ml-auto">
            <div class="p-4 border mb-3">
              <span class="d-block text-primary h6 text-uppercase">New York</span>
              <p class="mb-0">203 Fake St. Mountain View, San Francisco, California, USA</p>
            </div>
            <div class="p-4 border mb-3">
              <span class="d-block text-primary h6 text-uppercase">London</span>
              <p class="mb-0">203 Fake St. Mountain View, San Francisco, California, USA</p>
            </div>
            <div class="p-4 border mb-3">
              <span class="d-block text-primary h6 text-uppercase">Canada</span>
              <p class="mb-0">203 Fake St. Mountain View, San Francisco, California, USA</p>
            </div>

          </div> -->
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