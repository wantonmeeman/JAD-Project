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
	HttpSession Session = request.getSession();
	String role = "";
	int userid = 0;
	String AdminPage = "";
	String productID = "";
	String Name = "";
	String briefDescription = "";
	String detailedDescription = "";
	String cPrice = "";
	String rPrice = "";
	int stockQuantity = 0;
	String productCat = "";
	String sold = "";
	String lowStock = "";
	String lowStockAlert = "";
	
	String categoryID = "";
	String categoryName = "";
	String categoryURL = "";
	
	String dropdownCategory = "";
	String rows = "";
	String rowsSold = "";
	String categoryTable = "";
	int RowCount;
	String sortSuffix = "";
	String filterSuffix = "";
	String searchSuffix = "";
	
	String lowStockRange = request.getParameter("lowStockRange");
	String lSRValue = "100";
	String productSort = request.getParameter("productSort");
	String productFilter = request.getParameter("productFilter");
	String productSearch = request.getParameter("productSearch");
	String Error = request.getParameter("Err");
	ResultSet rs;
	Statement st;
	PreparedStatement ppst;
	
	try{
		userid = (int)Session.getAttribute("userid");  
		role = (String)Session.getAttribute("role");
	}catch(Exception e){
		response.sendRedirect("404.jsp");
	}

	try{
	if(Error.equals("EditSuccess")){
		out.print("<script>alert('Changes saved.')</script>");
	}
	if(Error.equals("DelSuccess")){
		out.print("<script>alert('Successfully deleted.')</script>");
	}
	if(Error.equals("AddSuccess")){
		out.print("<script>alert('Successfully added.')</script>");
	}
	}catch(Exception e){
		
	}
	String Header = "<ul><li><a href='loginpage.jsp'>Login</a></li><li><a href='register.jsp'>Register</span></a></li><li id='logoutButton'></li></ul>";
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
		  		
		  		String query = "SELECT * FROM products ";//First Tab
		  		
		  		//Sorting Logic 
		  		
		  		if(productSort == null || productSort.equals("null") || productSort.equals("")){//Can Add a descending option btw,maybe later?
        			sortSuffix = " ";
            	}else if(productSort.equals("cPrice")){
            		sortSuffix = " ORDER BY c_price "; 
            	}else if(productSort.equals("rPrice")){
            		sortSuffix = " ORDER BY r_price "; 
            	}else if(productSort.equals("Quantity")){
            		sortSuffix = " ORDER BY stock_quantity ";  
            	}else if(productSort.equals("itemsSold")){
            		sortSuffix = " ORDER BY sold "; 
            	}
				
		  		//Filtering Logic
		  		
        		if(productFilter == null || productFilter.equals("null") ||  productFilter.equals("")){
        			filterSuffix = "";
        		}else{
        			filterSuffix = " WHERE product_cat = '"+productFilter+"'";
        		}
        		
		  		//Searching Logic
        		
		  		if(filterSuffix.equals("")){
		  			//searchSuffix = " WHERE name LIKE '%"+productSearch+"%' ";
		  			searchSuffix = " WHERE name LIKE ? ";
		  		}else{
		  			//searchSuffix = " AND name LIKE '%"+productSearch+"%' ";
		  			searchSuffix = " WHERE name LIKE ? ";
		  		}
		  		
		  		if(productSearch == null || productSearch.equals("null") || productSearch == ""){
		  			searchSuffix = " ";
		  		}	
		  		 
		  		//This Adds all of the suffixes together to perform a search
		  		
		  	  	query = query + filterSuffix + searchSuffix + sortSuffix;
		  		
		  	  	if(searchSuffix.equals(" ")){
		  	  		st = conn.createStatement();
			   	 	rs = st.executeQuery(query);
		  	  	}else{
		  	  		ppst = conn.prepareStatement(query);
		  	  		ppst.setString(1,"%"+productSearch+"%");
		  	 		rs = ppst.executeQuery();
		  		 }
		  	  	
		        while(rs.next()){
		        	productID = rs.getString("product_id");
		        	Name = rs.getString("name");
		        	briefDescription = rs.getString("brief_description");
		        	detailedDescription = rs.getString("detailed_description");
		        	cPrice =  format.format(rs.getDouble("c_price"));
		        	rPrice  =  format.format(rs.getDouble("r_price"));
		        	stockQuantity = rs.getInt("stock_quantity");
		        	productCat = rs.getString("product_cat");
		        	sold = rs.getString("sold");
		        	    	
		        	  if(stockQuantity < 100){//gives it color if low, we can change this to act on the third tab's number
		        	    lowStockAlert = "background-color:#cc3300";
		        	  }else{
		        	    lowStockAlert = "";
		        	  }
		        	  
		        	  rows += "<tr style='"+lowStockAlert+"' ><th scope='row'>"+productID+"</th><td>"+productCat+"</td><td>"+Name+"</td><td>$"+cPrice+"</td><td>$"+rPrice+"</td><td>"+stockQuantity+"</td><td>"+sold+"</td><td><div class='row'><div class='col-md-8'><a href='Editlisting.jsp?productID="+productID+"'><span class='icon icon-pencil'></span></a></div><div class='col-md-2'><a href='#' class='deleteProduct'><span class='icon icon-trash'></span></a></div></div></td></tr>";
		        }
		        	
		        //2nd Tab		
				query = "SELECT * FROM categories";
				st = conn.createStatement();
				rs = st.executeQuery(query);
				
        		while (rs.next()){//rs.next() returns true if there is a row below the current one, and moves to it when called.
        	    	categoryID = rs.getString("category_id");
        	    	categoryName = rs.getString("category_name");
           	    	categoryURL = rs.getString("image");
        	    	
        	    	categoryTable += "<tr>"
	        	    		+ "<th scope='row'>" + categoryID + "</th>"
	        	    		+ "<td>" + categoryName + "</td>"
	        	    		+ "<td>" + categoryURL + "</td>"
	        	    		+ "<td><div class='row'><div class='col-md-4'><a href='edit-category.jsp?categoryID="+categoryID+"'><span class='icon icon-pencil'></span></a></div>"
	        	    		+ "<div class='col-md-8'>"
	        	    		+ "<a href='#' class='deleteCat'><span class='icon icon-trash'></span></a></div></div></td></tr>";
	        	    
	        	    dropdownCategory += "<a class='dropdown-item' href='admin-page.jsp?productFilter="+categoryName+"&productSort="+productSort+"&productSearch="+productSearch+"'>"+categoryName+"</a>";
             		
        		}
        		
        		//3rd Tab
        		if(lowStockRange == null || lowStockRange.equals("")){
        			query = "SELECT * FROM products WHERE stock_quantity < 100";//We can change this to if equals("") WHERE stock_quantity < 0 ,LMKWYT
        			st = conn.createStatement();
    				rs = st.executeQuery(query);
        		}else{
        			//query = "SELECT * FROM products WHERE stock_quantity <"+lowStockRange;
        			query = "SELECT * FROM products WHERE stock_quantity < ?";
        			lSRValue = lowStockRange;
        			ppst = conn.prepareStatement(query);
		  	  		ppst.setString(1,lowStockRange);
		  	 		rs = ppst.executeQuery();//Apparently theres a memory leak here
		  	 		//rs.close(); doesnt help so :shrug:
        		}

				while(rs.next()){
					productID = rs.getString("product_id");
        	    	Name = rs.getString("name");
        	    	briefDescription = rs.getString("brief_description");
        	    	detailedDescription = rs.getString("detailed_description");
        	    	cPrice =  format.format(rs.getDouble("c_price"));
        	    	rPrice  =  format.format(rs.getDouble("r_price"));
        	    	stockQuantity = rs.getInt("stock_quantity");
        	    	sold = rs.getString("sold");
        	    	lowStock += "<tr><th scope='row'>"+productID+"</th><td>"+Name+"</td><td>$"+cPrice+"</td><td>$"+rPrice+"</td><td>"+stockQuantity+"</td><td>"+sold+"</td><td><div class='row'><div class='col-md-8'><a href='Editlisting.jsp?productID="+productID+"'></a></div></div></td></tr>";
				}
				
				//Fourth tab? Do we even need this? Maybe we delete it?
				  query = "SELECT * FROM products ORDER BY sold DESC";
		  		  st = conn.createStatement();
			      rs = st.executeQuery(query);
		          while(rs.next()){//rs.next() returns true if there is a row below the current one, and moves to it when called.
		        	    productID = rs.getString("product_id");
		        	    Name = rs.getString("name");
		        	    briefDescription = rs.getString("brief_description");
		        	    detailedDescription = rs.getString("detailed_description");
		        	    cPrice =  format.format(rs.getDouble("c_price"));
		        	    rPrice  =  format.format(rs.getDouble("r_price"));
		        	    stockQuantity = rs.getInt("stock_quantity");
		        	    productCat = rs.getString("product_cat");
		        	    sold = rs.getString("sold");
		        	    	
		        	    if(stockQuantity < 100){
		        	    	lowStockAlert = "background-color:#cc3300";
		        	    }else{
		        	    	lowStockAlert = "";
		        	    }
		        	    	
		        	    rowsSold += "<tr style='"+lowStockAlert+"' ><th scope='row'>"+productID+"</th><td>"+productCat+"</td><td>"+Name+"</td><td>$"+cPrice+"</td><td>$"+rPrice+"</td><td>"+stockQuantity+"</td><td>"+sold+"</td><td></td></tr>";
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
  
  	// Delete Product
    $(document).ready(function () {
      var modal = document.getElementById("myModal");
      var span = document.getElementById("close");

      $('body').on('click', '.deleteProduct', function (event) {
        console.log("pressed");
        modal.style.display = "block";

        // When the user clicks on <span> (x), close the modal
        span.onclick = function () {
          document.getElementById("myModal").style.display = "none";
        }
      })


    });
    
    // Add Category
    $(document).ready(function () {
        var modal = document.getElementById("addCatModal");
        var span = document.getElementById("close2");

        $('body').on('click', '.addCat', function (event) {
          console.log("pressed");
          modal.style.display = "block";

          // When the user clicks on <span> (x), close the modal
          span.onclick = function () {
            document.getElementById("addCatModal").style.display = "none";
          }
        })


      });
    
    $(document).ready(function () {
        var modal = document.getElementById("delCatModal");
        var span = document.getElementById("close3");

        $('body').on('click', '.deleteCat', function (event) {
          console.log("pressed");
          modal.style.display = "block";

          // When the user clicks on <span> (x), close the modal
          span.onclick = function () {
            document.getElementById("delCatModal").style.display = "none";
          }
        })


      });
  </script>
</head>

<body>
<!-- The Modal (Delete Product) -->
  <div id="myModal" class="modal">

    <!-- Modal content -->
    <div class="modal-content">
      <span id="close" class="close">&times;</span>
      <div class="form-group row">

        <div class="col-md-5">
          <form>
            <h3 mb-5 class="text-dark">Are you sure you want to delete this product?</h3>
            
           	<a href="DeleteListing.jsp?productID=<%=productID %>" class="btn btn-sm btn-danger">Delete Product</a>
          </form>
        </div>

      </div>
    </div>

  </div>
  
  
  <!-- The Modal (Add Category) -->
  <div id="addCatModal" class="modal">

    <!-- Modal content -->
    <div class="modal-content">
      <span id="close2" class="close">&times;</span>
      <div class="form-group row">

        <div class="col-md-5">
          <form action="AddCategory.jsp? " method="post">
			<h3 mb-5 class="text-dark">Add New Category</h3>
			
			<div class="col-md-12 mt-4">
				<label for="catName" class="text-black">New Category Name: </label>
				<input type="text" class="form-control" id="catName" name="catName" placeholder="Category Name">
			</div>
			
			<div class="col-md-12 mt-4">
				<label for="catImageURL" class="text-black">Category Image Path: </label>
				<input type="text" class="form-control" id="catImageURL" name="catImageURL" placeholder="Image URL">
			</div>
			
            <div class="col-lg-3 p-3 mt-4">
              <input id="uploadProd" type="submit" class="btn btn-sm btn-info" value="Add Category">
            </div>

          </form>
        </div>

      </div>
    </div>

  </div>
  
  
  <!-- The Modal (Delete Category) -->
  <div id="delCatModal" class="modal">

    <!-- Modal content -->
    <div class="modal-content">
      <span id="close3" class="close">&times;</span>
      <div class="form-group row">

        <div class="col-md-5">
          <form>
            <h3 mb-5 class="text-dark">Are you sure you want to delete this category?</h3>
            
           	<a href="DeleteCategory.jsp?categoryID=<%=categoryID %>" class="btn btn-sm btn-danger">Delete Category</a>
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
              class="text-black">Administrator Page (Products)</strong></div>
        </div>
      </div>
    </div>

    <div class="site-section">
      <div class="container">

        <div class="col-md-12">
          <h2 class="h3 mb-5 text-black">Admin Control Page (All Products) </h2>
        </div>

        <div class="col-md-12 mb-5 d-flex flex-row-reverse">          	
          	<div class="p-2">
            	<a href="addlisting.jsp? " class="btn btn-sm btn-info">Create New Product</a>
         	 </div>
          	
          	<div class="p-2">
            	<a href="#" class="addCat btn btn-sm btn-dark">Add New Category</a>
          	</div>
         	 
        </div>


		<!-- TABS -->
		<div class="users-tab">
		  <button class="users-tablinks btn btn-secondary" onclick="openCity(event, 'allProductsTab')" id="defaultOpen">All Products</button>
		  <button class="users-tablinks btn btn-secondary" onclick="openCity(event, 'allCatTab')">Categories</button>
		  <button class="users-tablinks btn btn-secondary" onclick="openCity(event, 'lowStock')">Low Stock Items</button>
		  <button class="users-tablinks btn btn-secondary" onclick="openCity(event, 'bestSell')">Products By best selling</button>
		</div>
		
		<div id="allProductsTab" class="users-tabcontent">
			<div class="mt-4 ml-4">
			  <h3><text class="text-dark font-weight-bold">Products List</text></h3>
			  <div class="btn-group">
                    <button type="button" class="btn btn-secondary btn-sm dropdown-toggle" id="dropdownMenuReference"
                      data-toggle="dropdown">Sorting</button>
                    <div class="dropdown-menu" aria-labelledby="dropdownMenuReference">
                      <a class="dropdown-item" href="admin-page.jsp?productFilter=<%=productFilter%>&productSort=cPrice&productSearch=<%=productSearch%>">Cost Price</a>
                      <a class="dropdown-item" href="admin-page.jsp?productFilter=<%=productFilter%>&productSort=rPrice&productSearch=<%=productSearch%>">Retail Price</a>
                      <a class="dropdown-item" href="admin-page.jsp?productFilter=<%=productFilter%>&productSort=Quantity&productSearch=<%=productSearch%>">Quantity</a>
                      <a class="dropdown-item" href="admin-page.jsp?productFilter=<%=productFilter%>&productSort=itemsSold&productSearch=<%=productSearch%>">Items Sold</a>
                    </div>
               </div>
               <div class="btn-group">
                    <button type="button" class="btn btn-secondary btn-sm dropdown-toggle" id="dropdownMenuReference"
                      data-toggle="dropdown">Filter by Categories</button>
                    <div class="dropdown-menu" aria-labelledby="dropdownMenuReference">
                      <%=dropdownCategory %>
                    </div>
               </div>
			  <form action="admin-page.jsp?productFilter=<%=productFilter%>&productSort=<%=productSort%>" method='post'>
			  	<input type='text' name='productSearch'></input>
			  	<input type='submit' placeholder="Search For Product"></input>
			  </form>
			  
			  <div class="mt-4">
		          <table class="table table-hover">
		            <thead>
		              <tr>
		                <th scope="col">#</th>
		                <th scope="col">Product Category</th>
		                <th scope="col">Product Name</th>
		                <th scope="col">Cost Price</th>
		                <th scope="col">Retail Price</th>
		                <th scope="col">Quantity</th>
		                <th scope="col">Items Sold</th>
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
		
		<div id="allCatTab" class="users-tabcontent">
		  <div class="mt-4 ml-4">
			  <h3><text class="text-dark font-weight-bold">Category List</text></h3>
			  <div class="mt-4">
		          <table class="table table-hover">
		            <thead>
		              <tr>
		                <th scope="col">#</th>
		                <th scope="col">Category Names</th>
		                <th scope="col">Image URL</th>
		                <th scope="col">Actions</th>
		              </tr>
		            </thead>
		            <tbody>
		              <%=categoryTable %>
		            </tbody>
		          </table>
        		</div>
		  	</div>
		</div>
		
		<div id="lowStock" class="users-tabcontent">
		  <div class="mt-4 ml-4">
			  <h3><text class="text-dark font-weight-bold">Low Stock List</text></h3>
			  <form action="admin-page.jsp" method='post'>
			  	<input type='number' name='lowStockRange' value=<%=lSRValue %>></input>
			  	<input type='submit' placeholder="Set Range"></input>
			  </form>
			  <div class="mt-4">
		          <table class="table table-hover">
		            <thead>
		              <tr>
		                <th scope="col">#</th>
		                <th scope="col">Product Name</th>
		                <th scope="col">Cost Price</th>
		                <th scope="col">Retail Price</th>
		                <th scope="col">Quantity</th>
		                <th scope="col">Items Sold</th>
		              </tr>
		            </thead>
		            <tbody>
		              <%=lowStock %>
		            </tbody>
		          </table>
        		</div>
		  	</div>
		</div>
		
		<div id="bestSell" class="users-tabcontent">
		  <div class="mt-4 ml-4">
			  <h3><text class="text-dark font-weight-bold">Products by Best Selling</text></h3>
			  <div class="mt-4">
		          <table class="table table-hover">
		            <thead>
		              <tr>
		                <th scope="col">#</th>
		                <th scope="col">Product Category</th>
		                <th scope="col">Product Name</th>
		                <th scope="col">Cost Price</th>
		                <th scope="col">Retail Price</th>
		                <th scope="col">Quantity</th>
		                <th scope="col">Items Sold</th>
		              </tr>
		            </thead>
		            <tbody>
		              <%=rowsSold%>
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