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
<%  
	
	DecimalFormat format = new DecimalFormat("#0.00"); 
	String userid = request.getParameter("userid");  
	String role = request.getParameter("role");
	String AdminPage = "";
	
	String dbUserID = "";
	String username = "";
	String password = "";
	String email = "";
	String dbRole = "";
	String firstname = "";
	String lastname = "";
	String phonenumber = "";
	
	String dbRoleID = "";
	String roleName = "";
	
	String rows = "";
	String roleTable = "";
	int RowCount;
	String Error = request.getParameter("Err");
	
	try{
	   	if(Error.equals("NullError")){
	   		out.print("<script>alert('Please fill in all required fields!')</script>");
	   	}
	   	
		if(Error.equals("DelSuccess")){
			out.print("<script>alert('Successfully deleted.')</script>");
		}
		
		if(Error.equals("AddSuccess")){
			out.print("<script>alert('Successfully added.')</script>");
		}
		
		if(Error.equals("EditSuccess")){
			out.print("<script>alert('Changes saved.')</script>");
		}
		
	} catch(Exception e) {
		
	}
	

	String Header = "<ul><li><a href='loginpage.jsp'>Login</a></li><li><a href='register.jsp'>Register</span></a></li><li id='logoutButton'></li></ul>";
        try{
        	if(role.equals("admin")){ 
                AdminPage = "<li><a href='all-users.jsp?userid="+userid+"&role="+role+"'>User Control</a></li>"
                		+ "<li><a href='admin-page.jsp?userid="+userid+"&role="+role+"'>Product Control</a></li>";
                		
                Header = "<div class='site-top-icons'>"
                        + "<ul><li><a href='cart.jsp?userid="+userid+"&role="+role+"' class='site-cart  mr-3'><span class='icon icon-shopping_cart'></span></a></li>"
                          + "<li><a href='profile.jsp?userid="+userid+"&role="+role+"'>Edit Profile</a></li>" 
                          + "<li><a href='index.jsp?' class='btn btn-sm btn-secondary'>Logout</span></a></li>" 
                          + "<li id='logoutButton'></li></ul></div>";              
             } else if (role.equals("member")) {
            	  Header = "<div class='site-top-icons'>"
                          + "<ul><li><a href='cart.jsp?userid="+userid+"&role="+role+"' class='site-cart  mr-3'><span class='icon icon-shopping_cart'></span></a></li>"
                            + "<li><a href='profile.jsp?userid="+userid+"&role="+role+"'>Edit Profile</a></li>" 
                            + "<li><a href='index.jsp?' class='btn btn-sm btn-secondary'>Logout</span></a></li>" 
                            + "<li id='logoutButton'></li></ul></div>";     
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
		  		  String query = "SELECT * FROM users";
		  		  Statement st = conn.createStatement();
			      ResultSet rs = st.executeQuery(query);
		        		for(int i = 0;rs.next() == true;i++){//rs.next() returns true if there is a row below the current one, and moves to it when called.
		        	    	dbUserID = rs.getString("user_id");
		        	    	username = rs.getString("username");
		        	    	password = rs.getString("password");
		        	    	email = rs.getString("email");
		        	    	dbRole = rs.getString("role");
		        	    	firstname = rs.getString("firstname");
		        	    	lastname = rs.getString("lastname");
		        	    	phonenumber = rs.getString("phonenumber");
		        	    	
		        	    	// image = rs.getString("image");
		        	    	rows += "<tr>"
		        	    		+ "<th scope='row'>" + dbUserID + "</th>"
		        	    		+ "<td>" + username + "</td>"
		        	    		+ "<td>" + firstname + "</td>"
		        	    		+ "<td>" + lastname + "</td>"
		        	    		+ "<td>" + email + "</td>"
		        	    		+ "<td>" + dbRole + "</td>"
		        	    		+ "<td><div class='row'><div class='col-md-8'>"
		        	    		+ "<div class='ml-4 col-md-2'>"
		        	    		+ "<a href='#' class='deleteUser'><span class='icon icon-trash'></span></a></div></div></td></tr>";
		        	}
		        		
						String query2 = "SELECT * FROM roles";
						Statement st2 = conn.createStatement();
						ResultSet rs2 = st2.executeQuery(query2);
						
		        		while (rs2.next()){//rs.next() returns true if there is a row below the current one, and moves to it when called.
		        			dbRoleID = rs2.getString("role_id");
		        	    	roleName = rs2.getString("role_name");
		        	    	
		        	    	roleTable += "<tr>"
			        	    		+ "<th scope='row'>" + dbRoleID + "</th>"
			        	    		+ "<td>" + roleName + "</td>"
			        	    		+ "<td><div class='row'><div class='col-md-3'><a href='edit-role.jsp?userid="+userid+"&role="+role+"&dbRoleID="+dbRoleID+"'><span class='icon icon-pencil'></span></a></div>"
			        	    		+ "<div class='col-md-2'>"
			        	    		+ "<a href='#' class='deleteRole'><span class='icon icon-trash'></span></a></div></div></td></tr>";
		        	}
				        		
		        conn.close();
			}
		  	

%>
  <title>Digit Games &mdash; Categories</title>
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
  
  <script>
    $(document).ready(function () {
      var modal = document.getElementById("myModal");
      var span = document.getElementById("close");

      $('body').on('click', '.deleteUser', function (event) {
        console.log("pressed");
        modal.style.display = "block";

        // When the user clicks on <span> (x), close the modal
        span.onclick = function () {
          document.getElementById("myModal").style.display = "none";
        }
      })


    });
    
    $(document).ready(function () {
        var modal = document.getElementById("addRoleModal");
        var span = document.getElementById("close2");

        $('body').on('click', '.addRole', function (event) {
          console.log("pressed");
          modal.style.display = "block";

          // When the user clicks on <span> (x), close the modal
          span.onclick = function () {
            document.getElementById("addRoleModal").style.display = "none";
          }
        })


      });
    
    $(document).ready(function () {
        var modal = document.getElementById("delRoleModal");
        var span = document.getElementById("close3");

        $('body').on('click', '.deleteRole', function (event) {
          console.log("pressed");
          modal.style.display = "block";

          // When the user clicks on <span> (x), close the modal
          span.onclick = function () {
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
            <h3 mb-5 class="text-dark">Are you sure you want to delete this user?</h3>
            
           	<a href="DeleteUser.jsp?userid=<%=userid %>&role=<%=role %>&dbUserID=<%=dbUserID %>" class="btn btn-sm btn-danger">Delete User</a>
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
          <form action="AddRole.jsp?userid=<%=userid%>&role=<%=role%>" method="post">
			<h3 mb-5 class="text-dark">Add Role</h3>
			
			<div class="col-md-12 mt-4">
				<label for="dbRole" class="text-black">New Role Name:</label>
				<input type="text" class="form-control" id="dbRole" name="dbRole" placeholder="Role Name">
			</div>
			
            <div class="col-lg-3 p-3 mt-4">
              <input id="uploadProd" type="submit" class="btn btn-sm btn-info" value="Add Role">
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
            <h3 mb-5 class="text-dark">Are you sure you want to delete this role?</h3>
            
           	<a href="DeleteRole.jsp?userid=<%=userid %>&role=<%=role %>&dbRoleID=<%=dbRoleID %>" class="btn btn-sm btn-danger">Delete Role</a>
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
          <div class="col-md-12 mb-0"><a href="index.jsp">Home</a> <span class="mx-2 mb-0">/</span> <strong
              class="text-black">Administrator Page (Users)</strong></div>
        </div>
      </div>
    </div>

    <div class="site-section">
      <div class="container">

        <div class="col-md-12">
          <h2 class="h3 mb-5 text-black">Admin Control Page (All Users) </h2>
        </div>

        <div class="col-md-12 mb-5 d-flex flex-row-reverse">          	
          	<div class="p-2">
            	<a href="#" class="addRole btn btn-sm btn-dark">Add New Role</a>
         	 </div>

        </div>

		<!-- TABS -->
		<div class="users-tab">
		  <button class="users-tablinks btn btn-secondary" onclick="openCity(event, 'allUsersTab')" id="defaultOpen">All Users</button>
		  <button class="users-tablinks btn btn-secondary" onclick="openCity(event, 'allRolesTab')">Roles</button>
		</div>
		
		<div id="allUsersTab" class="users-tabcontent">
			<div class="mt-4 ml-4">
			  <h3><text class="text-dark font-weight-bold">Users List</text></h3>
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
		                <th scope="col">Actions</th>
		              </tr>
		            </thead>
		            <tbody>
		              <%=rows%>
		            </tbody>
		          </table>
        		</div>
		  	</div>
		</div>
		
		<div id="allRolesTab" class="users-tabcontent">
		  <div class="mt-4 ml-4">
			  <h3><text class="text-dark font-weight-bold">Roles List</text></h3>
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
		              <%=roleTable %>
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
      tabcontent = document.getElementsByClassName("users-tabcontent");
      for (i = 0; i < tabcontent.length; i++) {
        tabcontent[i].style.display = "none";
      }
      tablinks = document.getElementsByClassName("users-tablinks");
      for (i = 0; i < tablinks.length; i++) {
        tablinks[i].className = tablinks[i].className.replace(" active", "");
      }
      document.getElementById(cityName).style.display = "block";
      evt.currentTarget.className += " active";
    }

    // Get the element with id="defaultOpen" and click on it
    document.getElementById("defaultOpen").click();

    
  </script>

</body>

</html>