package mydbaccess;
import myclasses.*;
import java.sql.*;
import java.util.ArrayList;
import java.io.StringWriter;
import java.io.PrintWriter;



public class productDB {
	
	
	PreparedStatement ppst;
	Statement st;
	String query;
	ResultSet rs;
	Connection conn = null;
	
	String query1= "";
	String query2= "";
	ResultSet rs2;
	ResultSet rs1;
	
	String sortSuffix = "";
	String filterSuffix = "";
	String searchSuffix = "";
	
	public ArrayList<product> getAllProducts(String productSort,String productFilter,String productSearch,int page){//First Tab
		
		ArrayList<product> productList  = new ArrayList<product>();
    try{
	  	Class.forName("com.mysql.jdbc.Driver");
	  	conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
	  	// conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=admin&password=@dmin1!&serverTimezone=UTC&characterEncoding=latin1");
	}catch(Exception e){
		    System.out.print(e);
	}
    try {
	  	if(conn == null){
	  		 System.out.print("Conn Error");
	  		conn.close();
	  	}else{
	  		
	  		String query = "SELECT * FROM products ";
	  		
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
	  			searchSuffix = " AND name LIKE ? ";
	  		}
	  		
	  		if(productSearch == null || productSearch.equals("null") || productSearch == ""){
	  			searchSuffix = " ";
	  		}	
	  		 
	  		//This Adds all of the suffixes together to perform a search
	  		
	  	  	query = query + filterSuffix + searchSuffix + sortSuffix + "LIMIT ? , 5";
	  	  	if(searchSuffix.equals(" ")){
	  	  		ppst = conn.prepareStatement(query);
	  	  		ppst.setInt(1, (page-1)*5);
		   	 	rs = ppst.executeQuery();
	  	  	}else{
	  	  		ppst = conn.prepareStatement(query);
	  	  		ppst.setString(1,"%"+productSearch+"%");
	  	  		ppst.setInt(2, (page-1)*5);
	  	 		rs = ppst.executeQuery();
	  		 }
	  	  	
	        while(rs.next()){
	        	product productObj = new product();
	        	productObj.setProductID(rs.getInt("product_id"));
	        	productObj.setProductName(rs.getString("name"));
	        	productObj.setProductBrief_Description(rs.getString("brief_description"));
	        	productObj.setProductDetailed_Description(rs.getString("detailed_description"));
	        	productObj.setProductCPrice(rs.getDouble("c_price"));
	        	productObj.setProductRPrice(rs.getDouble("r_price"));
	        	productObj.setProductStock_Quantity(rs.getInt("stock_quantity"));
	        	productObj.setProduct_cat(rs.getString("product_cat"));
	        	productObj.setSold(rs.getInt("sold"));
	        	productList.add(productObj);
	        	}
	        return productList;
	  	}
	 }catch(Exception e) {
		 StringWriter sw = new StringWriter();
			PrintWriter pw = new PrintWriter(sw);
			e.printStackTrace(pw);
			String sStackTrace = sw.toString(); // stack trace as a string
		System.out.print("\n"+sStackTrace);
		//System.out.print(e);
		 System.out.print(ppst.toString());
	  	 return null;
	 }
	return null;
	}
	
	public int getTotalProducts(String productSort,String productFilter,String productSearch){
		int total_products = 0;
    try{
	  	Class.forName("com.mysql.jdbc.Driver");
	  	conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
	  	// conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=admin&password=@dmin1!&serverTimezone=UTC&characterEncoding=latin1");
	}catch(Exception e){
		    System.out.print(e);
	}
    try {
	  	if(conn == null){
	  		 System.out.print("Conn Error");
	  		conn.close();
	  	}else{
	  		
	  		String query = "SELECT COUNT(*) as total_products FROM products ";
	  		
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
	        	total_products = rs.getInt("total_products");
	        }
	        return total_products;
	  	}
	 }catch(Exception e) {
		 System.out.print(e);
	  	  return 0;
	 }
	return 0;
	}
	
	public ArrayList<category> getAllCategories(int page){//Second Tab
		ArrayList<category> categoryList  = new ArrayList<category>();
    try{
	  	Class.forName("com.mysql.jdbc.Driver");
	  	conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
	  	// conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=admin&password=@dmin1!&serverTimezone=UTC&characterEncoding=latin1");
	}catch(Exception e){
		    System.out.print(e);
	}
    try {
	  	if(conn == null){
	  		 System.out.print("Conn Error");
	  		conn.close();
	  	}else{
	  		
	  		query = "SELECT * FROM categories LIMIT ?,5";
			ppst = conn.prepareStatement(query);
			ppst.setInt(1, (page-1)*5);
			rs = ppst.executeQuery();
			
    		while (rs.next()){//rs.next() returns true if there is a row below the current one, and moves to it when called.
    			category categoryObj = new category();
    	    	categoryObj.setCategoryID(rs.getInt("category_id"));
    	    	categoryObj.setCategory_name(rs.getString("category_name"));
    	    	categoryObj.setCategory_image(rs.getString("image"));
         		categoryList.add(categoryObj);
    		}
	        return categoryList;
	  	}
	 }catch(Exception e) {
		 System.out.print(e);
	  	  return null;
	 }
	return null;
	}
	
	public int getTotalCategories(){//Second Tab
    try{
	  	Class.forName("com.mysql.jdbc.Driver");
	  	conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
	  	// conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=admin&password=@dmin1!&serverTimezone=UTC&characterEncoding=latin1");
	}catch(Exception e){
		    System.out.print(e);
	}
    try {
	  	if(conn == null){
	  		 System.out.print("Conn Error");
	  		conn.close();
	  	}else{
	  		
	  		query = "SELECT COUNT(*) as total_categories FROM categories";
			st = conn.createStatement();
			rs = st.executeQuery(query);
			
    		while (rs.next()){//rs.next() returns true if there is a row below the current one, and moves to it when called.
    			return rs.getInt("total_categories");
    		}
	  	}
	 }catch(Exception e) {
		 System.out.print(e);
	  	  return 0;
	 }
	return 0;
	}
	
	public ArrayList<product> getLowProducts(int lowStockRange,int page){
	ArrayList<product> productList  = new ArrayList<product>();
	try {
		if(lowStockRange == 0){
			query = "SELECT * FROM products WHERE stock_quantity < 100  LIMIT ?,5";
			ppst = conn.prepareStatement(query);
			ppst.setInt(1,(page-1)*5);
			rs = ppst.executeQuery();
		}else{
			query = "SELECT * FROM products WHERE stock_quantity < ?  LIMIT ?,5";
			ppst = conn.prepareStatement(query);
			ppst.setInt(1,lowStockRange);
			ppst.setInt(2,(page-1)*5);
			rs = ppst.executeQuery();
		}

	while(rs.next()){
		product productObj = new product();
    	productObj.setProductID(rs.getInt("product_id"));
    	productObj.setProductName(rs.getString("name"));
    	productObj.setProductBrief_Description(rs.getString("brief_description"));
    	productObj.setProductDetailed_Description(rs.getString("detailed_description"));
    	productObj.setProductCPrice(rs.getDouble("c_price"));
    	productObj.setProductRPrice(rs.getDouble("r_price"));
    	productObj.setProductStock_Quantity(rs.getInt("stock_quantity"));
    	productObj.setProduct_cat(rs.getString("product_cat"));
    	productObj.setSold(rs.getInt("sold"));
    	productList.add(productObj);
	}
		return productList;
	}catch(Exception e) {
		System.out.print(e);
	}
		return null;
	}
	
	public int getTotalLowProducts(int lowStockRange){
		ArrayList<product> productList  = new ArrayList<product>();
		try {
			if(lowStockRange == 0){
				query = "SELECT COUNT(*) as total_products FROM products WHERE stock_quantity < 100";
				st = conn.createStatement();
				rs = st.executeQuery(query);
			}else{
				query = "SELECT COUNT(*) as total_products FROM products WHERE stock_quantity < ?";
				ppst = conn.prepareStatement(query);
				ppst.setInt(1,lowStockRange);
				rs = ppst.executeQuery();
			}

		while(rs.next()){
			return rs.getInt("total_products");
		}
			return 0;
		}catch(Exception e) {
			System.out.print(e);
		}
			return 0;
		}
}
