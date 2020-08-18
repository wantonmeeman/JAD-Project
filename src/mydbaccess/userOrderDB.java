package mydbaccess;

import java.sql.*;
import myclasses.order;
import myclasses.user;
import java.util.ArrayList;
import java.io.StringWriter;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.text.DecimalFormat;


public class userOrderDB {
	
	
	PreparedStatement ppst;
	Statement st;
	String query;
	ResultSet rs;
	Connection conn;
	
	String query1= "";
	String query2= "";
	ResultSet rs2;
	ResultSet rs1;
	
	String sortSuffix= "";
	String timeSuffix= "";
	String filterSuffix= "";
	
	DecimalFormat format = new DecimalFormat("#0.00"); 
	int rsSize = 0;
	
	public int getTotalOrders(String orderSort,String timeSort,String filterValue,String filterCategory) {//Tab3
		try{
		  	Class.forName("com.mysql.jdbc.Driver");
		  	conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
		  	// conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=admin&password=@dmin1!&serverTimezone=UTC&characterEncoding=latin1");
		}catch(Exception e){
			return 0;
		}
		
		try {
		query = "SELECT * FROM orders ";
		
		if(orderSort == null){
			sortSuffix = " ORDER BY date " ;
    	}else if(orderSort.equals("ATime")){
    		sortSuffix = " ORDER BY date DESC "; 
    	}else if(orderSort.equals("DTotal")){
    		sortSuffix = " ORDER BY total "; 
    	}else if(orderSort.equals("ATotal")){
    		sortSuffix = " ORDER BY total DESC ";  
    	}else if(orderSort.equals("DQuantity")){
    		sortSuffix = " ORDER BY quantity "; 
    	}else if(orderSort.equals("AQuantity")){
    		sortSuffix = " ORDER BY quantity DESC "; 
    	}else{
    		sortSuffix = " ORDER BY date " ;
    	}
		
		if(timeSort == null || timeSort.equals("")){
			timeSuffix = " ";
		}else if(timeSort.equals("Today")){
			timeSuffix = "WHERE DATE(orders.date) = CURDATE()";
		}else if(timeSort.equals("Week")){
			timeSuffix = "WHERE YEARWEEK(orders.date) = YEARWEEK(CURDATE())";
		}else if(timeSort.equals("Month")){
			timeSuffix = "WHERE MONTH(orders.date) = MONTH(CURRENT_DATE()) AND YEAR(orders.date) = YEAR(CURRENT_DATE())";//No YearMonth Function :(
		}
		
		
		if(filterValue == null || filterCategory == null || filterValue.equals("null")|| filterCategory.equals("null")|| filterValue.equals("") || filterCategory.equals("")){
			query = query + timeSuffix +filterSuffix + sortSuffix;
			ppst = conn.prepareStatement(query);
		    rs = ppst.executeQuery();
		    
		}else if(filterCategory.equals("name") || filterCategory.equals("username") || filterCategory.equals("email") || filterCategory.equals("phonenumber")){
			query = query + timeSuffix +filterSuffix + sortSuffix;
			ppst = conn.prepareStatement(query);
		    rs = ppst.executeQuery();
			
		}else if(timeSort == null || timeSort.equals("null")) {
			filterSuffix = "WHERE "+filterCategory+" LIKE ?";
			query = query + timeSuffix +filterSuffix + sortSuffix;
			ppst = conn.prepareStatement(query);
			ppst.setString(1,"%"+filterValue+"%");
			rs = ppst.executeQuery();
			
		}else{
			
			filterSuffix = "AND "+filterCategory+" LIKE ?";
			query = query + timeSuffix +filterSuffix + sortSuffix;
			ppst = conn.prepareStatement(query);
			ppst.setString(1,"%"+filterValue+"%");
			rs = ppst.executeQuery();
		}
		
		int total = 0;
		while (rs.next()){
			
			String email = null;
		    String phonenumber = null;
		    String username =  null;
			String name = null;
	    	
	    	if(filterCategory == null || !filterCategory.equals("name")){//if sort by product name
	    		
	    		query1 = "SELECT name FROM products where product_id = ?";
				ppst = conn.prepareStatement(query1);
				ppst.setInt(1,rs.getInt("fk_productid"));
				rs1 = ppst.executeQuery();
			}else{
				query1 = "SELECT name FROM products where product_id = ? AND "+filterCategory+" LIKE ?";
				ppst = conn.prepareStatement(query1);
				ppst.setInt(1,rs.getInt("fk_productid"));
    			ppst.setString(2,"%"+filterValue+"%");
    			rs1 = ppst.executeQuery();
			}
			if(filterCategory == null || (!filterCategory.equals("username") && !filterCategory.equals("email") && !filterCategory.equals("phonenumber"))){
				query2 = "SELECT username,email,phonenumber FROM users where user_id = ?";
				ppst = conn.prepareStatement(query2);
				ppst.setInt(1,rs.getInt("fk_userid"));
    			rs2 = ppst.executeQuery();
				
			}else{
				query2 = "SELECT username,email,phonenumber FROM users where user_id = ? AND "+filterCategory+" LIKE ?";
				ppst = conn.prepareStatement(query2);
				ppst.setInt(1,rs.getInt("fk_userid"));
    			ppst.setString(2,"%"+filterValue+"%");
    			rs2 = ppst.executeQuery();
				
			}
			while(rs2.next()) {
				email =rs2.getString("Email");
			    phonenumber = rs2.getString("phonenumber");
			    username =  rs2.getString("username");
			}
			while(rs1.next()) {
				name = rs1.getString("name");
			}
				if(!(name == null || email == null || phonenumber == null ||  username == null )){
					total++;
				}
			
		}
		return total;
		
		}catch(Exception e) {
			return 0;
		}
	}
	
	
	
	public ArrayList<order> getAllOrders(int page,String orderSort,String timeSort,String filterValue,String filterCategory) {//Tab3
	//public String getAllOrders(int page,String orderSort,String timeSort,String filterValue,String filterCategory) {//Tab3
		ArrayList<order> orders = new ArrayList<order>();
		order orderObj = new order();
		boolean Limited = false;
		ArrayList<order> selectedOrders = new ArrayList<order>();
		try{
		  	Class.forName("com.mysql.jdbc.Driver");
		  	conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
		  	// conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=admin&password=@dmin1!&serverTimezone=UTC&characterEncoding=latin1");
		}catch(Exception e){
			return null;
		}
		
		try {
		query = "SELECT * FROM orders ";
		
		if(orderSort == null || orderSort.equals("")) {
			sortSuffix = "ORDER BY date";
		}else if(orderSort.charAt(0) == 'A'){
			orderSort = orderSort.substring(1);
			sortSuffix = "ORDER BY "+orderSort+" ASC ";
		}else if(orderSort.charAt(0) == 'D'){
			orderSort = orderSort.substring(1);
			sortSuffix = "ORDER BY "+orderSort+" DESC ";
		}
		
		if(timeSort == null || timeSort.equals("")){
			timeSuffix = " ";
		}else if(timeSort.equals("Today")){
			timeSuffix = "WHERE DATE(orders.date) = CURDATE()";
		}else if(timeSort.equals("Week")){
			timeSuffix = "WHERE YEARWEEK(orders.date) = YEARWEEK(CURDATE())";
		}else if(timeSort.equals("Month")){
			timeSuffix = "WHERE MONTH(orders.date) = MONTH(CURRENT_DATE()) AND YEAR(orders.date) = YEAR(CURRENT_DATE())";//No YearMonth Function :(
		}
		
		
		if(filterValue == null || filterCategory == null || filterValue.equals("null")|| filterCategory.equals("null")|| filterValue.equals("") || filterCategory.equals("")){
			query = query + timeSuffix +filterSuffix + sortSuffix;
			ppst = conn.prepareStatement(query);
		    rs = ppst.executeQuery();
		    
		    if (rs != null) {
				  rs.last();
				  rsSize = rs.getRow(); 
			}
			if(rsSize > 5) {
				query = "SELECT * FROM orders " + timeSuffix +filterSuffix + sortSuffix +" LIMIT ?,5";
				ppst = conn.prepareStatement(query);
				ppst.setInt(1,(page-1)*5);
			   rs = ppst.executeQuery();
			   Limited = true;

			}
		}else if(filterCategory.equals("name") || filterCategory.equals("username") || filterCategory.equals("email") || filterCategory.equals("phonenumber")){
			query = query + timeSuffix +filterSuffix + sortSuffix;
			ppst = conn.prepareStatement(query);
		    rs = ppst.executeQuery();
			
		}else if(timeSort == null || timeSort.equals("null")){
			
			//the column name is not a user input so it should be fine?

			filterSuffix = "WHERE "+filterCategory+" LIKE ?";
			query = query + timeSuffix +filterSuffix + sortSuffix;
			ppst = conn.prepareStatement(query);
			ppst.setString(1,"%"+filterValue+"%");
			rs = ppst.executeQuery();
			if (rs != null) {
				  rs.last();//Go to the Last row
				  rsSize = rs.getRow(); //get the size
			}
			if(rsSize > 5) {//if the size is bigger than 5
				query = "SELECT * FROM orders " + timeSuffix +filterSuffix + sortSuffix +" LIMIT ?,5";
				ppst = conn.prepareStatement(query);
				ppst.setString(1,"%"+filterValue+"%");
				ppst.setInt(2,(page-1)*5);
				rs = ppst.executeQuery();
				Limited = true;

			    
			}
			
			
		}else{
			
			filterSuffix = "AND "+filterCategory+" LIKE ?";
			query = query + timeSuffix +filterSuffix + sortSuffix;
			ppst = conn.prepareStatement(query);
			ppst.setString(1,"%"+filterValue+"%");
			rs = ppst.executeQuery();
			 if (rs != null) {
				  rs.last();
				  rsSize = rs.getRow(); 
				 //return query;
			}
			if(rsSize > 5) {
				query = "SELECT * FROM orders " + timeSuffix +filterSuffix + sortSuffix +" LIMIT ?,5";
				ppst = conn.prepareStatement(query);
				ppst.setString(1,"%"+filterValue+"%");
				ppst.setInt(2,(page-1)*5);
				rs = ppst.executeQuery();
				Limited = true;

			    
			}
		}
		
		int i = 0;
		rs.beforeFirst();
		
		while (rs.next()){
			orderObj = new order();
			orderObj.setOrderid(rs.getInt("orderid"));
			orderObj.setOrderDate(rs.getString("date"));
	    	orderObj.setOrderProductID(rs.getInt("fk_productid"));
	    	orderObj.setOrderUserID(rs.getInt("fk_userid"));
	    	orderObj.setOrderCardNumber(rs.getString("cardnumber"));
	    	orderObj.setOrderCCV(rs.getString("CCV"));
	    	orderObj.setOrderExpiryDate(rs.getString("expirydate"));
	    	orderObj.setOrderAddress(rs.getString("address"));
	    	orderObj.setOrderZipCode(rs.getString("zipcode"));
	    	orderObj.setOrderCompany(rs.getString("company"));
	    	orderObj.setOrderTotal(rs.getDouble("total"));
	    	orderObj.setOrderNotes(rs.getString("notes"));
	    	orderObj.setOrderQuantity(rs.getString("quantity"));
	    	orderObj.setOrderDelDate(rs.getString("delivery_date"));
	    	System.out.print(rs.getString("status"));
	    	orderObj.setOrderStatus(rs.getString("status"));
	    	
	    	if(filterCategory == null || !filterCategory.equals("name")){ //if sort by product name
	    		
	    		query1 = "SELECT name FROM products where product_id = ?";
				ppst = conn.prepareStatement(query1);
				ppst.setInt(1,rs.getInt("fk_productid"));
				rs1 = ppst.executeQuery();
			}else{
				query1 = "SELECT name FROM products where product_id = ? AND " + filterCategory + " LIKE ?";
				ppst = conn.prepareStatement(query1);
				ppst.setInt(1,rs.getInt("fk_productid"));
    			ppst.setString(2,"%"+filterValue+"%");
    			rs1 = ppst.executeQuery();
			}
			
			while(rs1.next()){
				orderObj.setOrderProduct(rs1.getString("name"));	
			}
			
			if(filterCategory == null || (!filterCategory.equals("username") && !filterCategory.equals("email") && !filterCategory.equals("phonenumber"))){
				query2 = "SELECT username,email,phonenumber FROM users where user_id = ?";
				ppst = conn.prepareStatement(query2);
				ppst.setInt(1,rs.getInt("fk_userid"));
    			rs2 = ppst.executeQuery();
				
			}else{
				query2 = "SELECT username,email,phonenumber FROM users where user_id = ? AND "+filterCategory+" LIKE ?";
				ppst = conn.prepareStatement(query2);
				ppst.setInt(1,rs.getInt("fk_userid"));
    			ppst.setString(2,"%"+filterValue+"%");
    			rs2 = ppst.executeQuery();
				
			}
			while(rs2.next()){
				orderObj.setOrderUsername(rs2.getString("username"));
				orderObj.setOrderEmail(rs2.getString("Email"));
				orderObj.setOrderPhoneNumber(rs2.getString("phonenumber"));
			}
			
			if(!(orderObj.getOrderProduct() == null || orderObj.getOrderEmail() == null || orderObj.getOrderPhoneNumber() == null || orderObj.getOrderUsername() == null )){// Ignore results where they are null
				i++;//This is the length of the arrayList?
				orders.add(orderObj);
			}
		}
		
		// The following code manually sorts through the ArrayList.
		// This had to be done as to get certain information, i had to make queries to different tables.
		// With Pagination, it is usually done with LIMIT <pagenumber>,5(See other functions)
		// However, if a search query is provided,
		// and it is directed at a table that is not the first query(example:searching for username in the User's table)
		// This means, if i LIMIT 0,5 the first query, and some of the selected rows do not fufill the WHERE statement,
		// This means that the information will be null and a half completed object will be added to the ArrayList
		// Or,if a check is implemented(see above), there will be less than 5 objects in the arrayList.
		// For example, if a user wanted to search by username. The first query would be to the orders table ,
		// Where all of the information is stored,if the first query returns 5 rows, 
		// and the second query,which gets the username/etc., will have to do a LIKE search by the username so the query will look like this
		// SELECT * FROM tablename WHERE fk_userid = <value from query1> AND LIKE "%userinput%"
		// As we only have 5 rows from the first query, some rows will return null as they dont fufill the WHERE clause.
		// Specifically the LIKE clause.
		// This means that most of the time if limit is used in the first query with a search statement
		// The ArrayList returned will be of a size that is >5
		//
		// SOLUTION
		//
		// Manually Parse the ArrayList to only include the first 5 values.
		// QnA
		// Why not use a or || clause?
		// It will make the search useless
		// 
		// Why not just return the half-completed objects?:
		// It will make the search useless
		
		if(Limited){//if page has 5 entries Or has a limit SQL query;
			return orders;
		}else{
			if(i - ((page-1)*5) >= 5) {
				for(int x = 0;x < 5;x++) {
					selectedOrders.add(orders.get(x+(page-1)*5));
				} 
			}else{//if page has >5 entries
				for(int x = 0;x < (i - ((page-1)*5));x++) {
					selectedOrders.add(orders.get(((page-1)*5)+x));
				}
			}
		}
		
		return selectedOrders;
		
		}catch(Exception e) {
			System.out.print(ppst.toString());
			e.printStackTrace();
			return null;
		}
			
	}
	
	// For View Order History
	public ArrayList<order> getOrderHistory(String orderSort,int userid,int page) {
		System.out.print("why1");
		ArrayList<order> orderList  = new ArrayList<order>();
		Connection conn = null;
	     try{
	        Class.forName("com.mysql.jdbc.Driver");
	      	conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
	       	// conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/digitgames?characterEncoding=latin1","admin","@dmin1!");
	        if(conn == null){
	        	System.out.print("Conn Error");
	        	conn.close();
	        	return null;
	        }else{
	        	
	        	if(orderSort == null || orderSort.equals("")) {
	        		sortSuffix = "";
	    		}else if(orderSort.charAt(0) == 'A'){
	    			orderSort = orderSort.substring(1);
	    			sortSuffix = "ORDER BY "+orderSort+" ASC ";
	    		}else if(orderSort.charAt(0) == 'D'){
	    			orderSort = orderSort.substring(1);
	    			sortSuffix = "ORDER BY "+orderSort+" DESC ";
	    		}
	        	
	        	query = "SELECT * FROM orders WHERE fk_userid = ? "+sortSuffix+" LIMIT ?,5";
			    PreparedStatement ppst = conn.prepareStatement(query);
			    ppst.setInt(1,userid);
			    ppst.setInt(2,(page-1)*5);
			    ResultSet rs = ppst.executeQuery();
			    while (rs.next()) {
			    	order orderObj = new order();
			    	orderObj.setOrderProductID(rs.getInt("fk_productid"));
			    	orderObj.setOrderDate(rs.getString("date"));
			    	orderObj.setOrderCardNumber(rs.getString("cardnumber"));
			    	orderObj.setOrderAddress(rs.getString("address"));
			    	orderObj.setOrderZipCode(rs.getString("zipcode"));
			    	orderObj.setOrderCompany(rs.getString("company"));
			    	orderObj.setOrderTotal(rs.getDouble("total"));
			    	orderObj.setOrderNotes(rs.getString("notes"));
			    	orderObj.setOrderQuantity(rs.getString("quantity"));
			    	orderObj.setOrderStatus(rs.getString("status"));
			    	orderObj.setOrderDelDate(rs.getString("delivery_date"));
			    	
			    	query = "SELECT * FROM products WHERE product_id = ?";
			    	ppst = conn.prepareStatement(query);
			    	ppst.setInt(1,rs.getInt("fk_productid"));
				    ResultSet rs1 = ppst.executeQuery();

					while(rs1.next()){
						orderObj.setOrderImage(rs1.getString("image"));
						orderObj.setOrderProduct(rs1.getString("name"));
					}
				    orderList.add(orderObj);
			    }
			    return orderList;
	        }
	     }catch(Exception e){
	    	 System.out.print(e);
	    	 return null;
	     }
	}
	//Total order history
	public int getOrderHistoryTotal(int userid) {
		int total = 0;
		Connection conn = null;
	     try{
	        Class.forName("com.mysql.jdbc.Driver");
	      	conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
	       	// conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/digitgames?characterEncoding=latin1","admin","@dmin1!");
	        if(conn == null){
	        	System.out.print("Conn Error");
	        	conn.close();
	        	return 0;
	        }else{
	        	
	        	query = "SELECT COUNT(*) as total_orders FROM orders WHERE fk_userid = ?";
			    PreparedStatement ppst = conn.prepareStatement(query);
			    ppst.setInt(1,userid);
			    ResultSet rs = ppst.executeQuery();
			    System.out.print("1");
			    while (rs.next()) {
				    total = rs.getInt("total_orders");
			    }
			    return total;
	        }
	     }catch(Exception e){
	    	 System.out.print(e);
	    	 return 0;
	     }
	    
	}
	//Editing Order List
	public boolean editOrderStatus(int orderid,String action) {
		Connection conn = null;
	     try{
	        Class.forName("com.mysql.jdbc.Driver");
	      	conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
	       	// conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/digitgames?characterEncoding=latin1","admin","@dmin1!");
	        if(conn == null){
	        	System.out.print("Conn Error");
	        	conn.close();
	        	return false;
	        }else{
	        	if(action.equals("Delivered")) {
	        		query = "UPDATE orders SET status = ?,delivery_date = NOW() WHERE orderid = ?";
	        	}else {
	        		query = "UPDATE orders SET status = ? WHERE orderid = ?";
	        	}
			    PreparedStatement ppst = conn.prepareStatement(query);
			    ppst.setString(1,action);
			    ppst.setInt(2,orderid);
			    int rs = ppst.executeUpdate();
			    if(rs == 1) {
	  				return true;
	  			}
	  			return false;
	        }
	     }catch(Exception e){
	    	 System.out.print(e);
	    	 return false;
	     }
		
	}
}
