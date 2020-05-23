<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
 <%@page import="java.text.DecimalFormat" %>
<!DOCTYPE html>
<html lang="en">

<head>
<%  DecimalFormat format = new DecimalFormat("#0.00"); 
	String sort = request.getParameter("sort");
	String userid = request.getParameter("userid");  //TODO, SORT USING MYSQL QUERIES, DONT USE JAVA
	String role = request.getParameter("role");
	String cat = request.getParameter("cat");
	String productID = "";
	String Name = "";
	String briefDescription = "";
	String detailedDescription = "";
	String cPrice = "";
	String rPrice = "";
	int stockQuantity = 0;
	String productCat = "";
	String image = "";
	String cells = "";
	String AdminPage = "";
	String CatSearchquery = "";
	String search = request.getParameter("search");
	
	int discountInt = 0; 
	int roundDiscount = 0;
	double discount = 0.00;
	String discountMsg = "";
	String priceMsg = "";
	
	String Header = "<ul><li><a href='loginpage.jsp'>Login</a></li><li><a href='register.jsp'>Register</span></a></li><li id='logoutButton'></li></ul>";
        try{
        	if(role.equals("admin")){ 
                AdminPage = "<li><a href='admin-page.jsp?userid="+userid+"&role="+role+"'>Control Panel</a></li>";
                Header = "<div class='site-top-icons'><ul><li><a href='profile.jsp?userid="+userid+"&role="+role+"'>Edit Profile</a></li><li><a href='index.jsp?' class='btn btn-sm btn-secondary'>Logout</span></a></li><li id='logoutButton'></li></ul></div>";
              } else if (role.equals("member")) {
                  Header = "<div class='site-top-icons'><ul><li><a href='profile.jsp?userid="+userid+"&role="+role+"'>Edit Profile</a></li><li><a href='index.jsp?' class='btn btn-sm btn-secondary'>Logout</span></a></li><li id='logoutButton'></li></ul></div>";
        	  }
        }catch(Exception e){// if no id or role is detected
        	 Header = "<div class='site-top-icons'>" //This is to make it neater
                     + "<ul><li><a href='cart.jsp' class='site-cart  mr-3'><span class='icon icon-shopping_cart'></span><span class='count'>2</span></a></li>"
                     + "<li><a href='profile.jsp?userid="+userid+"&role="+role+"'>Edit Profile</a></li>" 
                     + "<li><a href='index.jsp?' class='btn btn-sm btn-secondary'>Logout</span></a></li>" 
                     + "<li id='logoutButton'></li></ul></div>";    	
        }	
     Connection conn = null;
     try{
        Class.forName("com.mysql.jdbc.Driver");
      	conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
        // conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/digitgames?characterEncoding=latin1","admin","@dmin1!");
        if(conn == null){
        	out.print("Conn Error");
        	conn.close();
        }else{
        	if(!(search == null || search.equals("") || search.equals(" "))){
           		CatSearchquery = "AND name LIKE '%"+search+"%'";
           	}
        	String query = "";
        	if(sort == null){
        		query = "SELECT * FROM products WHERE product_cat = ?"+CatSearchquery;
        	}else if(sort.equals("AZ")){
        		query = "SELECT * FROM products WHERE product_cat = ? ORDER BY name"+CatSearchquery;
        	}else if(sort.equals("ZA")){
        		query = "SELECT * FROM products WHERE product_cat = ? ORDER BY name DESC"+CatSearchquery;
        	}else if(sort.equals("PLH")){
        		query = "SELECT * FROM products WHERE product_cat = ? ORDER BY c_price"+CatSearchquery;
        	}else if(sort.equals("PHL")){
        		query = "SELECT * FROM products WHERE product_cat = ? ORDER BY c_price DESC"+CatSearchquery;
        	}
        	   
				
        	    PreparedStatement st = conn.prepareStatement(query); 
        	    st.setString(1,cat);
				ResultSet rs =  st.executeQuery();
				
        		while(rs.next()){				//rs.next() returns true if there is a row below the current one, and moves to it when called.
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
        	    	image = rs.getString("image");
        	    	cells += "<div id='searchresults' class='col-sm-6 col-lg-4 mb-4' data-aos='fade-up'><div class='block-4 text-center border'><figure class='block-4-image'><a href='product.jsp?userid="+userid+"&role="+role+"&productid="+productID+"'><img src="+image+" alt='Image placeholder'class='img-fluid'></a></figure><div class='block-4-text p-4'><h3><a href='product.jsp?userid="+userid+"&role="+role+"&productid="+productID+"'>"+Name+"</a></h3><p class='mb-0'>"+briefDescription+"</p>"
        	    		+ "<p class='text-primary font-weight-bold'>" + priceMsg + discountMsg + "</p><a href='product.jsp?userid="+userid+"&role="+role+"&productid="+productID+"' id='productDetail' class='makeOffer'>Read more...</button></div></div></div>";
        }
		}}catch(Exception e){
			out.print(e);
     	};
    
    	%>
  <title>Digit Games &mdash; All Products</title>
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

  <link rel="stylesheet" href="css/aos.css">

  <link rel="stylesheet" href="css/style.css">

  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>

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
                <a href="index.jsp?userid=<%=userid%>&role=<%=role%>" class="js-logo-clone">Digit Games</a>
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
            <%=AdminPage %>
          </ul>
        </div>
      </nav>
    </header>

    <div class="bg-light py-3">
      <div class="container">
        <div class="row">
          <div class="col-md-12 mb-0"><a href="categories.jsp?userid=<%=userid%>&role=<%=role%>">Categories</a> <span class="mx-2 mb-0">/</span> <strong
              class="text-black"><%=productCat %></strong></div>
        </div>
      </div>
    </div>

    <div class="site-section">
      <div class="container">

        <div class="row mb-5">
          <div class="col-md-12 order-2">

            <div class="row">
              <div class="col-md-12 mb-5">
                <div class="float-md-left mb-4">
                  <h2 id="searchHeader" class="text-black h5">All <%=productCat%><h2>
                </div>
                <div class="d-flex">
                  <div class="dropdown mr-1 ml-md-auto">
                    <button type="button" class="btn btn-secondary btn-sm dropdown-toggle" id="dropdownMenuOffset"
                      data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                      Categories
                    </button>
                    <div class="dropdown-menu" aria-labelledby="dropdownMenuOffset">
                      <a class="dropdown-item" href="cat-listings.jsp?userid=<%=userid%>&role=<%=role%>&cat=Games">Games</a>
                      <a class="dropdown-item" href="cat-listings.jsp?userid=<%=userid%>&role=<%=role%>&cat=Gaming Gear">Gaming Gear</a>
                      <a class="dropdown-item" href="cat-listings.jsp?userid=<%=userid%>&role=<%=role%>&cat=Apparel">Apparel</a>
                    </div>
                  </div>
                  <div class="btn-group">
                    <button type="button" class="btn btn-secondary btn-sm dropdown-toggle" id="dropdownMenuReference"
                      data-toggle="dropdown">Reference</button>
                    <div class="dropdown-menu" aria-labelledby="dropdownMenuReference">
                      <a class="dropdown-item" href="cat-listings.jsp?userid=<%=userid%>&role=<%=role%>&cat=<%=cat%>&sort=Relevance">Relevance</a>
                      <a class="dropdown-item" href="cat-listings.jsp?userid=<%=userid%>&role=<%=role%>&cat=<%=cat%>&sort=AZ">Name, A to Z</a>
                      <a class="dropdown-item" href="cat-listings.jsp?userid=<%=userid%>&role=<%=role%>&cat=<%=cat%>&sort=ZA">Name, Z to A</a>
                      <div class="dropdown-divider"></div>
                      <a class="dropdown-item" href="cat-listings.jsp?userid=<%=userid%>&role=<%=role%>&cat=<%=cat%>&sort=PLH">Price, low to high</a>
                      <a class="dropdown-item" href="cat-listings.jsp?userid=<%=userid%>&role=<%=role%>&cat=<%=cat%>&sort=PHL">Price, high to low</a>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <div class="row">
              <div class="col-md-6">
                <form action="cat-listings.jsp" class="">
                  <span class="icon icon-search2"></span>
                  <input type="hidden" name="userid" value="<%=userid%>">
                  <input type="hidden" name="role" value="<%=role%>">
                  <input type="hidden" name="cat" value="<%=productCat%>">
                  <input type="text" class="col-md-8 border-1" id="keyword" placeholder="Search" name="search">
                  <button type="submit" onclick="" id="searchbutton">Search</button>
                </form>
              </div>
            </div>

            <div id="allListings" class="  row mb-5">

              <!-- 1 SAMPLE PRODUCT (CHANGE TO LOOP) -->
              <%=cells%>


            </div>

          </div>

        </div>

        <div class="row">
          <div class="col-md-12">
            <div class="site-section site-blocks-2">



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