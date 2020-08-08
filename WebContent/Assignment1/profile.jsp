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
<!DOCTYPE html>
<html lang="en">

<head>

  <title>Digit Games &mdash; Contact Us</title>
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
  <link rel="stylesheet" href="css/myoverride.css">


</head>
<% 
	
	try{
		
		String Error = request.getParameter("Err");
		String[] ErrorArray = Error.split("-",0);
		for(int i = 0;ErrorArray.length>i;i++){
			if(ErrorArray[i].equals("PasswordSizeInvalid")){
				out.print("<script>alert('Password either too long or too short!')</script>");
			}
			if(ErrorArray[i].equals("UsernameSizeInvalid")){
				out.print("<script>alert('Username either too long or too short!')</script>");
			}
			if(ErrorArray[i].equals("Success")){
				out.print("<script>alert('User Details were successfully changed!')</script>");
			}
			if(ErrorArray[i].equals("DatabaseError")){
				out.print("<script>alert('There is a Database Error!')</script>");
			}
			if(ErrorArray[i].equals("PasswordNotEqual")){
				out.print("<script>alert('Passwords do not match!')</script>");
			}
			if(ErrorArray[i].equals("PasswordNotValid")){
				out.print("<script>alert('Invalid Password!')</script>");
			}
			if(ErrorArray[i].equals("PasswordSuccess")){
				out.print("<script>alert('Password was successfully changed!')</script>");
			}
			if(ErrorArray[i].equals("ProfileSuccess")){
				out.print("<script>alert('Profile Details were successfully changed!')</script>");
			}
		}
	}catch(Exception e){
		
	}
	
	HttpSession Session = request.getSession();
	String email = "";
	String username = "";
	String AdminPage = "";
	String phonenumber = "";
	String lastname = "";
	String firstname = "";
	int userid = 0;
	String role = "";
	String address = "";
	String country = "";
	String zipcode = "";
	String company = "";
	String CCV = "";
	String cardnumber = "";
	String expirydate = "";
	String orders = "";
	String orderAddress = "";
	String orderCountry = "";
	String orderProduct = "";
	int orderProductID = 0;
	String orderCompany = "";
	String orderQuantity = "";
	String orderTotal = "";
	String orderNotes = "";
	String orderZipcode = "";
	String orderCardNumber = "";
	String orderImage = "";
	String Header = "<ul><li><a href='loginpage.jsp'>Login</a></li><li><a href='register.jsp'>Register</span></a></li><li id='logoutButton'></li></ul>";
	try{
		userid = (int)Session.getAttribute("userid");  
		role = (String)Session.getAttribute("role");
	}catch(Exception e){
		response.sendRedirect("404.jsp");
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
		conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
		// conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/digitgames?characterEncoding=latin1","admin","@dmin1!");
	}catch(Exception e){
	    out.print(e);
	}
	
		if(conn == null){
			out.print("Conn Error");
			conn.close();
		}else{
			String query = "SELECT * FROM users WHERE user_id = "+userid;
		    Statement st = conn.createStatement();
		    ResultSet rs = st.executeQuery(query);
		    while (rs.next()) {
		    	address = rs.getString("address");
		    	country = rs.getString("country");
		    	zipcode = rs.getString("zipcode");
		    	company = rs.getString("company");
		    	email = rs.getString("email");
		    	username = rs.getString("username");
		    	firstname = rs.getString("firstname");
		    	lastname = rs.getString("lastname");
		    	phonenumber = rs.getString("phonenumber");
		        cardnumber = rs.getString("cardnumber");
		    	CCV = rs.getString("CCV");
		    	expirydate = rs.getString("expirydate");
		    }
		}
		    
		 	conn.close();
		

%>

<body>
<style>
input::-webkit-outer-spin-button,
input::-webkit-inner-spin-button {
  -webkit-appearance: none;
  margin: 0;
}
</style>
  <div class="site-wrap">
    <header class="site-navbar" role="banner">
      <div class="site-navbar-top">
        <div class="container" >
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
              class="text-black">My Profile</strong></div>
        </div>
      </div>
    </div>


    <div class="site-section">
      <div class="container">
        <div class="row">
          <div class="col-md-12">
            <h2 class="h3 mb-3 text-black">My Personal Information</h2>
          </div>

          <div class="tab">
            <button class="tablinks" onclick="openCity(event, 'myProfileTab')" id="defaultOpen">My Profile</button>
            <button class="tablinks" onclick="openCity(event, 'editProfileTab')">Edit Profile</button>
            <button class="tablinks" onclick="openCity(event, 'addressTab')">My Delivery Details</button>
            <button class="tablinks" onclick="openCity(event, 'chgPwTab')">Change Password</button>
          </div>

          <div id="myProfileTab" class="tabcontent">
            <div class="profile-border col-lg-12" id="home" class="container tab-pane active"><br>

              <div class="profile-contents" id="profile-contents">

                <div class="profile-header">
                  <h1 class="display4"><text class="text-dark font-weight-bold">Welcome, <%=username %>!</text></h1>
                </div>

                <div class="profilepic-wrapper row mt-2 ml-4">
                  <div class="profilepic ml-4">
                    <img src="images/saddog.jpg" class="rounded-circle" alt="Profile Picture" width="70" height="70">
                  </div>

                  <div class="profilepic-text mt-2 ml-4">
                    <div><text class="text-dark font-weight-bold"><%=username %></text></div>
                    <div><text class="text-dark font-weight-normal"><%=firstname + " " + lastname %></text></div>
                  </div>
                </div>

                <div class="profile-info ml-3 mt-3">
                  <div><text class="text-dark font-weight-normal">Email: <%=email%></text></div>

                  <div><text class="text-dark font-weight-normal">Phone Number: <%=phonenumber %></text></div>

                  <div><text class="text-dark font-weight-normal">Membership Status: </text><text class="text-dark font-weight-bold"><%=role %></text></div>


                  <div class="col-md-12 mb-5 d-flex flex-row">
                    <div class="p-2 mt-4">
                      <button class="tablinks btn btn-sm btn-secondary" onclick="openCity(event, 'editProfileTab')">Edit
                        Profile</button>
                        
                    </div>
                   
                  </div>

                </div>
					
              </div>
            </div>
          </div>

          <div id="editProfileTab" class="tabcontent">
            <div class="col-md-12">

              <form action="VerifyChange.jsp" method="post" class="test">

                <div class="p-3 p-lg-5 border">

                  <div class="editpic-wrapper mb-4">
                    <div class="editpic">
                      <img src="images/saddog.jpg" class="rounded-circle" alt="Profile Picture" width="100"
                        height="100">
                    </div>
                    <div class="editpic-link">
                      <a href="#">Upload Picture</a>
                    </div>
                  </div>

                  <div class="form-group row">
                    <div class="col-md-6">
                      <label for="username" class="text-black">Username <span class="text-danger">*</span></label>
                      <input type="text" class="form-control" id="username" name="username" value="<%=username %>"
                        readonly>
                    </div>
                  </div>
                  <div class="form-group row">
                    <div class="col-md-6">
                      <label for="firstName" class="text-black">First Name <span class="text-danger">*</span></label>
                      <input type="text" class="form-control" id="firstName" name="firstname" value="<%=firstname%>">
                    </div>
                    <div class="col-md-6">
                      <label for="lastName" class="text-black">Last Name <span class="text-danger">*</span></label>
                      <input type="text" class="form-control" id="lastName" name="lastname" value="<%=lastname%>">
                    </div>
                  </div>

                  <div class="form-group row mb-5">
                    <div class="col-md-7">
                      <label for="email" class="text-black">Email <span class="text-danger">*</span></label>
                      <input type="email" class="form-control" id="email" name="email" placeholder=""
                        value="<%=email%>">
                    </div>

                    <div class="col-md-5">
                      <label for="email" class="text-black">Phone Number <span class="text-danger">*</span></label>
                      <input type="number" class="form-control" id="email" name="phonenumber" placeholder="" value="<%=phonenumber%>">
                    </div>
                  </div>

                  <div class="form-group row">
                    <div class="col-lg-12">
                      <input type="submit" class="btn btn-primary btn-lg btn-block" value="Save Changes"/>
                    </div>
                  </div>
                </div>
              </form>
            </div>
          </div>


          <div id="addressTab" class="tabcontent">
            <div class="col-md-12">

              <form action="http://localhost:12978/ST0510-JAD/editDeliveryDetails" method="post">

                <div class="p-3 p-lg-5 border">

                  <div class="form-group row">
                    <div class="col-md-12">
                      <label for="address" class="text-black">Address </label>
                      <input type="text" class="form-control" id="address" name="address" value="<%=address%>">
                    </div>
                  </div>

                  <div class="form-group row">
                    <div class="col-md-8">
                      <label for="city" class="text-black">Company</label>
                      <input type="text" class="form-control" id="city" name="company" value="<%=company%>">
                    </div>
                  </div>

                  <div class="form-group row mb-5">
                    <div class="col-md-6">
                      <label for="country" class="text-black">Country </label>
                      <input type="text" class="form-control" id="country" name="country" value="<%=country%>">
                    </div>
                    <div class="col-md-6">
                      <label for="postal" class="text-black">Zipcode </label>
                      <input type="text" class="form-control" id="zipcode" name="zipcode" value="<%=zipcode%>"> 
                    </div>
                  </div>
                  <div class="form-group row mb-5">
                    <div class="col-md-6">
                      <label for="country" class="text-black">Card number </label>
                      <input type="text" class="form-control" id="country" name="cardnumber" value="<%=cardnumber%>">
                    </div>
                    <div class="col-md-3">
                      <label for="postal" class="text-black">CCV </label>
                      <input type="text" class="form-control" id="zipcode" name="CCV" value="<%=CCV%>" > 
                    </div>
                    <div class="col-md-3">
                      <label for="postal" class="text-black">Expiry Date</label>
                      <input type="text" class="form-control" id="zipcode" name="expirydate" value="<%=expirydate%>" pattern="(?:0[1-9]|1[0-2])/[0-9]{2}" placeholder="MM/YY"> 
                    </div>
                  </div>
                  

                  <div class="form-group row">
                    <div class="col-lg-12">
                      <input type="submit" class="btn btn-primary btn-lg btn-block" value="Save Changes">
                    </div>
                  </div>
                </div>
              </form>
            </div>
          </div>



          <div id="chgPwTab" class="tabcontent">
            <div class="col-md-12">

              <form action="VerifyChange.jsp" method="post">

                <div class="p-5 p-lg-10 border">

                  <div class="form-group row">
					
                    <div class="col-md-12">
                      <label for="oldPw" class="text-black">Enter your old password: <span
                          class="text-danger">*</span></label>
                      <input type="password" class="form-control" id="oldPw" name="oldPw" placeholder="Old Password">
                    </div>
                  </div>

                  <div class="form-group row">

                    <div class="col-md-12">
                      <label for="newPw" class="text-black">Enter your new password: <span
                          class="text-danger">*</span></label>
                      <input type="password" class="form-control" id="newPw" name="newPw" placeholder="New Password">
                    </div>
                  </div>

                  <div class="form-group row">

                    <div class="col-md-12">
                      <label for="reenterPw" class="text-black">Please re-enter your new password: <span
                          class="text-danger">*</span></label>
                      <input type="password" class="form-control" id="reenterPw" name="reenterPw"
                        placeholder="Re-enter Password">
                    </div>
                  </div>

                </div>

                <div class="form-group row">
                  <div class="col-md-12 col-lg-12">
                    <input type="submit" class="btn btn-primary btn-lg btn-block" value="Change Password">
                  </div>
                </div>



              </form>
            </div>

          </div>
          
          
              
            </div>

          </div>
          

        </div>
      </div>
    </div>

    <!-- FOOTER -->
    <footer class="site-footer border-top">
      <div class="container" >
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


  <script>
    function openCity(evt, cityName) {
      var i, tabcontent, tablinks;
      tabcontent = document.getElementsByClassName("tabcontent");
      for (i = 0; i < tabcontent.length; i++) {
        tabcontent[i].style.display = "none";
      }
      tablinks = document.getElementsByClassName("tablinks");
      for (i = 0; i < tablinks.length; i++) {
        tablinks[i].className = tablinks[i].className.replace(" active", "");
      }
      document.getElementById(cityName).style.display = "block";
      evt.currentTarget.className += " active";
    }

    // Get the element with id="defaultOpen" and click on it
    document.getElementById("defaultOpen").click();
    // console.log("clicked")
  </script>

</body>

</html>