<%-- 
==========================================
Author: Alastair Tan (P1936096) & Yu Dong En (P1936348)
Class: DIT/2A/02
Description: ST0510 / JAD Assignment 1
===========================================
--%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="myclasses.*"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@page import="java.text.DecimalFormat" %>
<!DOCTYPE html>
<html lang="en">

<head>
<%  
	DecimalFormat format = new DecimalFormat("#0.00"); 
	HttpSession Session = request.getSession();
	String role = "";
	int userid = 0;
	
	String dropdownCategory = "";
	String rows = "";
	String rowsSold = "";
	String categoryTable = "";
	
	String Error = request.getParameter("Err");
	String lowStock = "";
	String Path = "http://localhost:8080"+request.getContextPath()+"/";
	String productSort = request.getParameter("productSort");
	String productSearch = request.getParameter("productSearch");
	String productFilter = request.getParameter("productFilter");
	int categoryID = 0;
	int productID = 0;
	int LSRValue = Integer.valueOf(request.getParameter("LowStockValue"));
	ArrayList<product> Tab1 = (ArrayList<product>)Session.getAttribute("Tab1");
	ArrayList<category> Tab2 = (ArrayList<category>)Session.getAttribute("Tab2");
	ArrayList<product> Tab3 = (ArrayList<product>)Session.getAttribute("Tab3");
	
	String Pagination1 = "";
	int PageNumber1 = 0;
	String Pagination2 = "";
	int PageNumber2 = 0;
	String Pagination3 = "";
	int PageNumber3 = 0;
	String Pagination4 = "";
	int PageNumber4 = 0;
	
	int Tab1T = (int)Session.getAttribute("Tab1T");
	int Tab2T = (int)Session.getAttribute("Tab2T");
	int Tab3T = (int)Session.getAttribute("Tab3T");
	
	for(int i = 0;i < Tab1T;i++){
		if((i % 5) == 0){
			PageNumber1 += 1;
    		Pagination1 += "<a href='"+Path+"allProductsDetails?page1="+PageNumber1+"&productFilter="+productFilter+"&productSort="+productSort+"&productSearch="+productSearch+"'><button class = 'btn btn-secondary'>"+PageNumber1+"</button></a>";
		}else{
			
		}
    	
    }
	for(int i = 0;i < Tab2T;i++){
		if((i % 5) == 0){
			PageNumber2 += 1;
    		Pagination2 += "<a href='"+Path+"allProductsDetails?page2="+PageNumber2+"'><button class = 'btn btn-secondary'>"+PageNumber2+"</button></a>";
		}else{
			
		}
    	
    }
	
	for(int i = 0;i < Tab3T;i++){
		if((i % 5) == 0){
			PageNumber3 += 1;
    		Pagination3 += "<a href='"+Path+"allProductsDetails?page3="+PageNumber3+"&LowStockValue"+LSRValue+"'><button class = 'btn btn-secondary'>"+PageNumber3+"</button></a>";
		}else{
			
		}
    	
    }
	String tab = request.getParameter("tab");
	if(tab == null){
		tab = "";
	}
	//This whole thing can be made easier, but low priority
	String Open1 = "";
	String Open2 = "";
	String Open3 = "";
	switch(tab){ //Makes A tab open by default
	case "2":
		Open2 = "defaultOpen";
		break;
	case "3":
		Open3 = "defaultOpen";
		break;
	case "1":
	default:
		Open1 = "defaultOpen";
		break;
}
	
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
	if(Error.equals("DatabaseError")){		
   		out.print("<script>alert('Database Error')</script>");			
   	}	
	if(Error.equals("DelSuccess")){
		out.print("<script>alert('Successfully deleted.')</script>");
	}
	if(Error.equals("AddSuccess")){
		out.print("<script>alert('Successfully added.')</script>");
	}
	}catch(Exception e){
		
	}

 				for(int i = 0;Tab1.size() > i;i++){

				String lowStockAlert = "";
		        	  if(Tab1.get(i).getProductStock_Quantity() < 100){//gives it color if low, we can change this to act on the third tab's number
		        	    lowStockAlert = "background-color:#cc3300";
		        	  }
		        	  
		        	  rows += "<tr style='"+lowStockAlert+"' ><th scope='row'>"
		        	  +Tab1.get(i).getProductID()+"</th><td>"+Tab1.get(i).getProduct_cat()+"</td><td>"
		        	  +Tab1.get(i).getProductName()+"</td><td>$"+Tab1.get(i).getProductCPrice()+"</td><td>$"
		        	  +Tab1.get(i).getProductRPrice()+"</td><td>"+Tab1.get(i).getProductStock_Quantity()+"</td><td>"
		        	  +Tab1.get(i).getSold()+"</td><td><div class='row'><div class='col-md-8'><a href='"+Path+"getProductDetails?productID="
		        	  +Tab1.get(i).getProductID()+"'><span class='icon icon-pencil'></span></a></div><div class='col-md-2'>"
		        	  +"<a href='confirmation.jsp?id="+Tab1.get(i).getProductID()+"&type=list' class='deleteProduct'><span class='icon icon-trash'></span></a></div></div></td></tr>";
 				}
		        		
 				for(int i = 0;Tab2.size() > i;i++){
 					categoryTable += "<tr>"
	        	    		+ "<th scope='row'>" + Tab2.get(i).getCategoryID() + "</th>"
	        	    		+ "<td>" + Tab2.get(i).getCategory_name() + "</td>"
	        	    		+ "<td>" + Tab2.get(i).getCategory_image() + "</td>"
	        	    		+ "<td><div class='row'><div class='col-md-4'><a href='"+Path+"getCategoryDetails?categoryID="+Tab2.get(i).getCategoryID()+"'><span class='icon icon-pencil'></span></a></div>"
	        	    		+ "<div class='col-md-8'>"
	        	    		+ "<a href='confirmation.jsp?id="+Tab2.get(i).getCategoryID()+"&type=cat'><span class='icon icon-trash'></span></a></div></div></td></tr>";
	        	    
	        	    
	        	    dropdownCategory += "<a class='dropdown-item' href='"+Path+"/allProductsDetails?productFilter="+Tab2.get(i).getCategory_name()+"&productSort="+productSort+"&productSearch="+productSearch+"'>"+Tab2.get(i).getCategory_name()+"</a>";
 	 			}
 				for(int i = 0;Tab3.size() > i;i++){

 					lowStock += "<tr><th scope='row'>"+Tab3.get(i).getProductID()+"</th><td>"+Tab3.get(i).getProductName()+"</td><td>$"+Tab3.get(i).getProductCPrice()+"</td><td>$"+Tab3.get(i).getProductRPrice()+"</td><td>"+Tab3.get(i).getProductStock_Quantity()+"</td><td>"+Tab3.get(i).getSold()+"</td><td><div class='row'><div class='col-md-8'><a href='Editlisting.jsp?productID="+Tab3.get(i).getProductID()+"'></a></div></div></td></tr>";
 					
 	 			}
        	    	
				
				
				/* //Fourth tab? Do we even need this? Maybe we delete it?
						Unused 4TH TAB ILL LEAVE IT HERE IF YOU NEED IT
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
		        	} */
	if(productSearch.equals("null") || productSearch == null){
		productSearch = "";
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
    /* $(document).ready(function () {
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


    }); */
    
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
    
    /* $(document).ready(function () {
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


      }); */
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
          <form action="${pageContext.request.contextPath}/AddCategoryServlet" method="post">
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
       
	  		
                <%
                                    if (role.equals("admin") || role.equals("member")) {
                                %>
                                <ul>
                                    <li><a href='${pageContext.request.contextPath}/CartServlet' class='site-cart  mr-3'><span
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
                        <li><a href='${pageContext.request.contextPath}/allProductsDetails'>Product Control</a></li>
                        <li><a href='${pageContext.request.contextPath}/viewOrders'>View Order History</a></li>
                        <%
                            } else if (role.equals("member")) {
                        %>
                        <li><a href='${pageContext.request.contextPath}/viewOrders'>View Order History</a></li>
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
		  <button class="users-tablinks btn btn-secondary" onclick="openCity(event, 'allProductsTab')" id=<%=Open1 %>>All Products</button>
		  <button class="users-tablinks btn btn-secondary" onclick="openCity(event, 'allCatTab')" id=<%=Open2 %>>Categories</button>
		  <button class="users-tablinks btn btn-secondary" onclick="openCity(event, 'lowStock')" id=<%=Open3 %>>Low Stock Items</button>
		</div>
		
		<div id="allProductsTab" class="users-tabcontent">
			<div class="mt-4 ml-4">
			  <h3><text class="text-dark font-weight-bold">Products List</text></h3>
			  <div class="btn-group">
                    <button type="button" class="btn btn-secondary btn-sm dropdown-toggle" id="dropdownMenuReference"
                      data-toggle="dropdown">Sorting</button>
                    <div class="dropdown-menu" aria-labelledby="dropdownMenuReference">
                      <a class="dropdown-item" href="${pageContext.request.contextPath}/allProductsDetails?productFilter=<%=productFilter%>&productSort=Ac_price&productSearch=<%=productSearch%>">Cost Price, Ascending</a>
                      <a class="dropdown-item" href="${pageContext.request.contextPath}/allProductsDetails?productFilter=<%=productFilter%>&productSort=Dc_price&productSearch=<%=productSearch%>">Cost Price, Descending</a>
                      <div class="dropdown-divider"></div>
                      <a class="dropdown-item" href="${pageContext.request.contextPath}/allProductsDetails?productFilter=<%=productFilter%>&productSort=Ar_price&productSearch=<%=productSearch%>">Retail Price, Ascending</a>
                      <a class="dropdown-item" href="${pageContext.request.contextPath}/allProductsDetails?productFilter=<%=productFilter%>&productSort=Dr_price&productSearch=<%=productSearch%>">Retail Price, Descending</a>
                     <div class="dropdown-divider"></div>
                      <a class="dropdown-item" href="${pageContext.request.contextPath}/allProductsDetails?productFilter=<%=productFilter%>&productSort=Astock_quantity&productSearch=<%=productSearch%>">Quantity, Ascending</a>
                      <a class="dropdown-item" href="${pageContext.request.contextPath}/allProductsDetails?productFilter=<%=productFilter%>&productSort=Dstock_quantity&productSearch=<%=productSearch%>">Quantity, Descending</a>
                     <div class="dropdown-divider"></div>
                     <a class="dropdown-item" href="${pageContext.request.contextPath}/allProductsDetails?productFilter=<%=productFilter%>&productSort=Asold&productSearch=<%=productSearch%>">Items Sold, Ascending</a>
                      <a class="dropdown-item" href="${pageContext.request.contextPath}/allProductsDetails?productFilter=<%=productFilter%>&productSort=Dsold&productSearch=<%=productSearch%>">Items Sold, Descending</a>
                    </div>
               </div>
               <div class="btn-group m-3">
                    <button type="button" class="btn btn-secondary btn-sm dropdown-toggle" id="dropdownMenuReference"
                      data-toggle="dropdown">Filter by Categories</button>
                    <div class="dropdown-menu" aria-labelledby="dropdownMenuReference">
                    <a class='dropdown-item' href='${pageContext.request.contextPath}/allProductsDetails?productSort=<%=productSort%>&productSearch=<%=productSearch%>'>None</a>
                      <%=dropdownCategory %>
                      
                    </div>
               </div>
			  <form action="${pageContext.request.contextPath}/allProductsDetails?productFilter=<%=productFilter%>&productSort=<%=productSort%>" method='post'>
			  <label>Search by Product Name: </label>
			  	<input type='text' placeholder="Name" name='productSearch' value="<%=productSearch%>"></input>
			  	<input type='submit' placeholder="Search For Product" value="Search"></input>
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
		  	<%=Pagination1%>
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
		  	<%=Pagination2 %>
		</div>
		
		<div id="lowStock" class="users-tabcontent">
		  <div class="mt-4 ml-4">
			  <h3><text class="text-dark font-weight-bold">Low Stock List</text></h3>
			  <form action="${pageContext.request.contextPath}/allProductsDetails" method='post'>
			  <label>Search by quantity under: </label>
			  	<input type='number' name='lowStockRange' value=<%=LSRValue %>></input>
			  	<input type='submit' placeholder="Set Range" value="Search"></input>
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
		  	<%=Pagination3 %>
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