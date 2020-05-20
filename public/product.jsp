<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ page import="java.sql.*" %>
 <%@page import="java.text.DecimalFormat" %>
<!DOCTYPE html>
<html lang="en">

<head>
<%  DecimalFormat format = new DecimalFormat("#0"); 
	String userid = request.getParameter("userid");  
	String role = request.getParameter("role");
	String productID = request.getParameter("productid");
	String name = "";
	String briefDescription = "";
	String detailedDescription = "";
	String cPrice = "";
	String rPrice = "";
	int stockQuantity = 0;
	String productCat = "";
	String image = "";
	String AdminPage = "";
	
	String Header = "<ul><li><a href='loginpage.jsp'>Login</a></li><li><a href='register.jsp'>Register</span></a></li><li id='logoutButton'></li></ul>";
        try{
        	if(role.equals("admin")){ 
                AdminPage = "<li><a href='admin-page.jsp?userid="+userid+"&role="+role+"'>Control Panel</a></li>";
                Header = "<div class='site-top-icons'><ul><li><a href='profile.jsp?userid="+userid+"&role="+role+"'>Edit Profile</a></li><li><a href='index.jsp?' class='btn btn-sm btn-secondary'>Logout</span></a></li><li id='logoutButton'></li></ul></div>";
              } else if (role.equals("member")) {
                  Header = "<div class='site-top-icons'><ul><li><a href='profile.jsp?userid="+userid+"&role="+role+"'>Edit Profile</a></li><li><a href='index.jsp?' class='btn btn-sm btn-secondary'>Logout</span></a></li><li id='logoutButton'></li></ul></div>";
        	  }}catch(Exception e){// if no id or role is detected
        		  Header = "<div class='site-top-icons'>" //This is to make it neater
        	                 + "<ul><li><a href='cart.jsp' class='site-cart  mr-3'><span class='icon icon-shopping_cart'></span><span class='count'>2</span></a></li>"
        	                 + "<li><a href='profile.jsp?userid="+userid+"&role="+role+"'>Edit Profile</a></li>" 
        	                 + "<li><a href='index.jsp?' class='btn btn-sm btn-secondary'>Logout</span></a></li>" 
        	                 + "<li id='logoutButton'></li></ul></div>";
        	   }
        Connection conn = null;
        try{
            Class.forName("com.mysql.jdbc.Driver");
          //conn = DriverManager.getConnection(jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC);
            conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=admin&password=@dmin1!&serverTimezone=UTC&characterEncoding=latin1");
            if(conn == null){
            	out.print("Conn Error");
            	conn.close();
            }else{
            	    String query = "SELECT * FROM products WHERE product_id = "+productID;
    				
            	    Statement st = conn.createStatement();
            	    
            	    ResultSet rs = st.executeQuery(query);
            	    
            	    while(rs.next()){
          	    		name = rs.getString("name");
          	    		briefDescription = rs.getString("brief_description");
          	    		detailedDescription = rs.getString("detailed_description");
          	    		cPrice = format.format(rs.getDouble("c_price"));
          	    		rPrice = format.format(rs.getDouble("r_price"));
          	    		stockQuantity = rs.getInt("stock_quantity");
          	    		productCat = rs.getString("product_cat");
          	    		image = rs.getString("image");
            		}
            }
        }catch(Exception e){
        	out.print(e);
        }
        int discountInt, roundDiscount = 0;
    	
        double discount = ((Double.parseDouble(rPrice) - Double.parseDouble(cPrice)) / Double.parseDouble(rPrice))*100;
        discountInt = (int)Math.round(discount);
        roundDiscount = (discountInt + 4) / 5 * 5;
        //String pcOff = format.format(5*(Math.round(((Double.parseDouble(rPrice) - Double.parseDouble(cPrice)) / Double.parseDouble(rPrice)*100))/5));
        
    	%>
  <title>Digit Games &mdash; Product Details</title>
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
            <%=AdminPage %>
          </ul>
        </div>
      </nav>
    </header>

    <div class="bg-light py-3">
      <div class="container">
        <div class="row">
          <div class="col-md-12 mb-0"><a href="categories.jsp">Gaming Gear</a> <span class="mx-2 mb-0">/</span> 
          <strong class="text-black">></strong></div>
        </div>
      </div>
    </div>

    <div class="site-section">
      <div class="container">
        <div class="row">
          <div class="col-md-6">
            <img src="<%=image %>" alt="Image" class="img-fluid">
          </div>
          <div class="col-md-6">
            <h2 class="text-black"><%=name %></h2>
            <p><%=detailedDescription %></p>
            <!--  <p class="mb-4">Ex numquam veritatis debitis minima quo error quam eos dolorum quidem perferendis. Quos
              repellat dignissimos minus, eveniet nam voluptatibus molestias omnis reiciendis perspiciatis illum hic
              magni iste, velit aperiam quis.</p>-->


            <p class="r_price"><span class="text-black">Price: </span><strong class="text-primary h4"><s>$<%=rPrice %></s>
                $<%=cPrice %>   (<%=roundDiscount %>% Off)</p></strong>

	
            <form action="cart.jsp?userid=<%=userid%>&role=<%=role%>" method="POST">
              <div class="mb-5 row">
                <p class="r_price mt-1 ml-3"><span class="text-black">Quantity: </p>
                	
                  <input type="number" placeholder=1 name="quantity" style="margin-top: 4px;margin-bottom: 50px;margin-right:30px;"></input>
                  <input type="hidden" name="productid"></input>
              </div>
              <p><button type=submit class="buy-now btn btn-sm btn-primary" style="padding:20px 10px 5px 10px !important;">Add To Cart</a></p>
            </form>
          </div>
        </div>
      </div>
    </div>

    <div class="site-section block-3 site-blocks-2 bg-light">
      <div class="container">
        <div class="row justify-content-center">
          <div class="col-md-7 site-section-heading text-center pt-4">
            <h2>Similar Products</h2>
          </div>
        </div>
        <div class="row">
          <div class="col-md-12">
            <div class="nonloop-block-3 owl-carousel">
              <div class="item">
                <div class="block-4 text-center">
                  <figure class="block-4-image">
                    <img src="images/saddog.jpg" alt="Image placeholder" class="img-fluid">
                  </figure>
                  <div class="block-4-text p-4">
                    <h3><a href="#">sad dog 1</a></h3>
                    <p class="mb-0">Finding perfect t-shirt</p>
                    <p class="text-primary font-weight-bold">$50</p>
                  </div>
                </div>
              </div>
              <div class="item">
                <div class="block-4 text-center">
                  <figure class="block-4-image">
                    <img src="images/saddog.jpg" alt="Image placeholder" class="img-fluid">
                  </figure>
                  <div class="block-4-text p-4">
                    <h3><a href="#">sad dog 2</a></h3>
                    <p class="mb-0">Finding perfect products</p>
                    <p class="text-primary font-weight-bold">$50</p>
                  </div>
                </div>
              </div>
              <div class="item">
                <div class="block-4 text-center">
                  <figure class="block-4-image">
                    <img src="images/saddog.jpg" alt="Image placeholder" class="img-fluid">
                  </figure>
                  <div class="block-4-text p-4">
                    <h3><a href="#">sad dog 3</a></h3>
                    <p class="mb-0">Finding perfect products</p>
                    <p class="text-primary font-weight-bold">$50</p>
                  </div>
                </div>
              </div>
              <div class="item">
                <div class="block-4 text-center">
                  <figure class="block-4-image">
                    <img src="images/saddog.jpg" alt="Image placeholder" class="img-fluid">
                  </figure>
                  <div class="block-4-text p-4">
                    <h3><a href="#">sad dog 4</a></h3>
                    <p class="mb-0">Finding perfect products</p>
                    <p class="text-primary font-weight-bold">$50</p>
                  </div>
                </div>
              </div>
              <div class="item">
                <div class="block-4 text-center">
                  <figure class="block-4-image">
                    <img src="images/saddog.jpg" alt="Image placeholder" class="img-fluid">
                  </figure>
                  <div class="block-4-text p-4">
                    <h3><a href="#">sad dog 5</a></h3>
                    <p class="mb-0">Finding perfect products</p>
                    <p class="text-primary font-weight-bold">$50</p>
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