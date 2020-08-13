package mydbaccess;

import java.sql.*;
import myclasses.order;
import myclasses.user;
import myclasses.role;
import java.util.ArrayList;
import java.io.StringWriter;
import java.io.PrintWriter;



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
	
	String orderUsername= "";
	String orderEmail= "";
	String orderPhoneNumber= "";
	
	String orderProduct = "";
	
	String orderDate = "";
	int orderProductID= 0;
	int orderUserID= 0;
	String orderCardNumber= "";
	String orderCCV= "";
	String orderExpiryDate= "";
	String orderAddress= "";
	String orderZipCode= "";
	String orderCompany= "";
	double orderTotal= 0;
	String orderNotes= "";
	String orderQuantity= "";
	
	
	
	int rsSize = 0;
	
	public int getTotalUsers(String userSearch) {//For Pagination, we can get rid of this and fuse it with the normal function with a extra attribute/getset.
		int total_users = 0;
		try{
		  	Class.forName("com.mysql.jdbc.Driver");
		  	conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
		  	// conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=admin&password=@dmin1!&serverTimezone=UTC&characterEncoding=latin1");
		}catch(Exception e){
			return 0;
		}
		try {
			if(userSearch == null || userSearch.equals("")){
				query = "SELECT COUNT(*) as 'total_users' FROM users ";
				st = conn.createStatement();
				rs = st.executeQuery(query);
		  		}else{
		  		query = "SELECT COUNT(*) as 'total_users' FROM users WHERE username LIKE ?";
		  		  ppst = conn.prepareStatement(query);
		  		  ppst.setString(1,"%"+userSearch+"%");
		  		  rs = ppst.executeQuery();
		  		}
			
			while(rs.next()) {
				total_users = rs.getInt("total_users");
			}
			return total_users;
		}catch(Exception e) {
			return 0;
		}
	}
	
	
	public int getTotalRoles() {//For Pagination, we can get rid of this and fuse it with the normal function with a extra attribute/getset.
		int total_roles = 0;
		try{
		  	Class.forName("com.mysql.jdbc.Driver");
		  	conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
		  	// conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=admin&password=@dmin1!&serverTimezone=UTC&characterEncoding=latin1");
		}catch(Exception e){
			return 0;
		}
		try {
			query = "SELECT COUNT(*) as 'total_roles' FROM roles ";
			st = conn.createStatement();
			rs = st.executeQuery(query);
			while(rs.next()) {
				total_roles = rs.getInt("total_roles");
			}
			return total_roles;
		}catch(Exception e) {
			return 0;
		}
	}
	
	
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
			//ppst.setInt(1,(page-1)*5);
		    rs = ppst.executeQuery();
			
		}else if(timeSort == null || timeSort.equals("null")){
			
			//the column name is not a user input so it should be fine?

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
				//ppst.setInt(2,(page-1)*5);
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
//		System.out.print("\n\nTQuery1: "+query);
//		System.out.print("\nTQuery2: "+query1);
//		System.out.print("\nTQuery3: "+query2);
		
		return total;
		
		}catch(Exception e) {
			StringWriter sw = new StringWriter();
			PrintWriter pw = new PrintWriter(sw);
			e.printStackTrace(pw);
			String sStackTrace = sw.toString(); // stack trace as a string
			System.out.print(sStackTrace);
//			System.out.print(query+"\n");
//			System.out.print(query1+"\n");
//			System.out.print(query2+"\n");
			//System.out.print(query2+"\n");
			return 0;
		}
	}
	
	
	
	public ArrayList<user> getAllUser(String userSearch,int page) {//First Tab
		ArrayList<user> users = new ArrayList<user>();
		user userObj = null;
		try{
		  	Class.forName("com.mysql.jdbc.Driver");
		  	conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
		  	// conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=admin&password=@dmin1!&serverTimezone=UTC&characterEncoding=latin1");
		}catch(Exception e){
			return null;
		}
		try {
		if(userSearch == null || userSearch.equals("")){
	  		  query = "SELECT * FROM users LIMIT ? , 5";
	  		  ppst = conn.prepareStatement(query);
	  		  ppst.setInt(1,(page-1)*5);
		      rs = ppst.executeQuery();
	  		}else{
	  		  query = "SELECT * FROM users WHERE username LIKE ? LIMIT ? , 5"; 
	  		  ppst = conn.prepareStatement(query);
	  		  ppst.setString(1,"%"+userSearch+"%");
	  		  ppst.setInt(2,(page-1)*5);
	  		  rs = ppst.executeQuery();
	  		}
	        	while(rs.next()){//rs.next() returns true if there is a row below the current one, and moves to it when called.
	        		userObj = new user();
	        	    userObj.setUserid(rs.getInt("user_id"));
	        	    userObj.setUsername(rs.getString("username"));
	        	    userObj.setPassword(rs.getString("password"));
	        	    userObj.setEmail(rs.getString("email"));
	        	    userObj.setRole(rs.getString("role"));
	        	    userObj.setFirstname(rs.getString("firstname"));
	        	    userObj.setLastname(rs.getString("lastname"));
	        	    userObj.setPhonenumber(rs.getString("phonenumber"));
	        	    userObj.setCardnumber(rs.getString("cardnumber"));
	        	    userObj.setCcv(rs.getString("ccv"));
	        	    users.add(userObj);
	        	}
	        	return users;
		}catch(Exception e) {
			return null;
		}
	}
	
	public ArrayList<role> getAllRoles(int page) {//Tab2
		
		ArrayList<role> roles = new ArrayList<role>();
		role roleObj = null;
		try{
		  	Class.forName("com.mysql.jdbc.Driver");
		  	conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
		  	// conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=admin&password=@dmin1!&serverTimezone=UTC&characterEncoding=latin1");
		}catch(Exception e){
			return null;
		}
		try {
		query = "SELECT * FROM roles LIMIT ? ,5";//Second Tab
		ppst = conn.prepareStatement(query);
		ppst.setInt(1,(page-1)*5);
	    rs = ppst.executeQuery();
		roleObj = null;
		
		
		while (rs.next()){//rs.next() returns true if there is a row below the current one, and moves to it when called.
			roleObj = new role();
			roleObj.setRoleid(rs.getString("role_id"));
	    	roleObj.setRolename(rs.getString("role_name"));
	    	roles.add(roleObj);
		}
		return roles;
		
		}catch(Exception E) {
			return null;
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
		    
		    if (rs != null) {
				  rs.last();
				  rsSize = rs.getRow(); 
				 //return query;
			}
			if(rsSize > 5) {
				query = "SELECT * FROM orders " + timeSuffix +filterSuffix + sortSuffix +" LIMIT ?,5";
				ppst = conn.prepareStatement(query);
				ppst.setInt(1,(page-1)*5);
				//return query;
				//orderObj.setOrderPhoneNumber(query);
				//orders.add(orderObj);
				//return orders;
			   rs = ppst.executeQuery();
			   Limited = true;

			    
			}
		}else if(filterCategory.equals("name") || filterCategory.equals("username") || filterCategory.equals("email") || filterCategory.equals("phonenumber")){
			query = query + timeSuffix +filterSuffix + sortSuffix;
			ppst = conn.prepareStatement(query);
			//ppst.setInt(1,(page-1)*5);
		    rs = ppst.executeQuery();
			
		}else if(timeSort == null || timeSort.equals("null")){
			
			//the column name is not a user input so it should be fine?

			filterSuffix = "WHERE "+filterCategory+" LIKE ?";
			query = query + timeSuffix +filterSuffix + sortSuffix;
			ppst = conn.prepareStatement(query);
			ppst.setString(1,"%"+filterValue+"%");
			System.out.print("\nPPST:"+ppst.toString());
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
		//System.out.print("\n filterCategory: "+filterCategory);
		//System.out.print("\n filterValue: "+filterValue);
		//System.out.print("\n Result Set Size: "+rsSize);
		rs.beforeFirst();
		
		while (rs.next()){
			orderObj = new order();
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
	    	//orderObj.setOrderQuantity(String.valueOf(i));
	    	
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
	    	
			
			while(rs1.next()){
				orderObj.setOrderProduct(rs1.getString("name"));	
			}
			
			if(filterCategory == null || (!filterCategory.equals("username") && !filterCategory.equals("email") && !filterCategory.equals("phonenumber"))){
				query2 = "SELECT username,email,phonenumber FROM users where user_id = ?";
				ppst = conn.prepareStatement(query2);
				ppst.setInt(1,rs.getInt("fk_userid"));
				//ppst.setInt(2,(page-1)*5);
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
			
			if(!(orderObj.getOrderProduct() == null || orderObj.getOrderEmail() == null || orderObj.getOrderPhoneNumber() == null || orderObj.getOrderUsername() == null )){
				i++;
				System.out.print(orderObj.getOrderProduct());
				orders.add(orderObj);
				
			}
		}
		
		if(Limited){
			for(int x = 0;x < i;x++) {
				selectedOrders.add(orders.get(x));
				
			} 
		}else{
			if(i - ((page-1)*5) >= 5) {//if page has 5 entries Or has a limit SQL query;
				for(int x = 0;x < 5;x++) {
					System.out.print("stuff1");
					selectedOrders.add(orders.get(x+(page-1)*5));
				} 
			}else{//if page has >5 entries
				System.out.print(orders.size());
				System.out.print((i - ((page-1)*5)));
				for(int x = 0;x < (i - ((page-1)*5));x++) {
					selectedOrders.add(orders.get(((page-1)*5)+x));
				}}
		}
//		System.out.print("\nQUERY1:"+query+"\n");
//		System.out.print("QUERY2:"+query1+"\n");
//		System.out.print("QUERY3:"+query2+"\n");
		
		return selectedOrders;
		
		}catch(Exception e) {
			//Use this to return something to debug
			
			//return null;
			return null;
		}
		//return "seomthing";
			
	}
	public int getTotalUsersMax(String userSearch4) {//For Pagination, we can get rid of this and fuse it with the normal function with a extra attribute/getset.
		ArrayList<user> users = new ArrayList<user>();
		int total = 0;
		try{
		  	Class.forName("com.mysql.jdbc.Driver");
		  	conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
		  	// conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=admin&password=@dmin1!&serverTimezone=UTC&characterEncoding=latin1");
		}catch(Exception e){
			return 0;
		}
		try {
		query = "SELECT fk_userid,SUM(total) as user_total FROM orders GROUP BY fk_userid order by user_total desc;";
		st = conn.createStatement();
		rs = st.executeQuery(query);
		
		while(rs.next()){
			user userObj = new user();
			if(userSearch4 == null){
				query1 = "SELECT username,email,phonenumber FROM users where user_id = ?";
				ppst = conn.prepareStatement(query1);
				ppst.setInt(1,rs.getInt("fk_userid"));
    			rs1 = ppst.executeQuery();
			}else{
				query1 = "SELECT username,email,phonenumber FROM users where user_id = ? AND username LIKE ?";
				ppst = conn.prepareStatement(query1);
				ppst.setInt(1,rs.getInt("fk_userid"));
				ppst.setString(2,"%"+userSearch4+"%");
				rs1 = ppst.executeQuery();
			}
			
			while(rs1.next()){
				if(!(rs1.getString("username") == null || rs1.getString("Email") == null || rs1.getString("phonenumber") == null)) {
					total++;
				}
			}
			
			
		}
		}catch(Exception e) {
			return 0;
		}
		return total;
	}
	public ArrayList<user> getMaxUser(String userSearch4,int page) {
		
		ArrayList<user> users = new ArrayList<user>();
		try{
		  	Class.forName("com.mysql.jdbc.Driver");
		  	conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
		  	// conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=admin&password=@dmin1!&serverTimezone=UTC&characterEncoding=latin1");
		}catch(Exception e){
			System.out.print(e);
		}
		try {
		query = "SELECT fk_userid,SUM(total) as user_total FROM orders GROUP BY fk_userid order by user_total desc LIMIT ?,5";
		ppst = conn.prepareStatement(query);
		ppst.setInt(1,(page-1)*5);
		
		rs = ppst.executeQuery();
		while(rs.next()){
			user userObj = new user();
			if(userSearch4 == null){
				query1 = "SELECT username,email,phonenumber FROM users where user_id = ?";
				ppst = conn.prepareStatement(query1);
				ppst.setInt(1,rs.getInt("fk_userid"));
    			rs1 = ppst.executeQuery();
			}else{
				query1 = "SELECT username,email,phonenumber FROM users where user_id = ? AND username LIKE ?";
				ppst = conn.prepareStatement(query1);
				ppst.setInt(1,rs.getInt("fk_userid"));
				ppst.setString(2,"%"+userSearch4+"%");
				rs1 = ppst.executeQuery();
			}
			
			while(rs1.next()){
				if(!(rs1.getString("username") == null || rs1.getString("Email") == null || rs1.getString("phonenumber") == null)) {
					userObj.setUsername(rs1.getString("username"));
					userObj.setEmail(rs1.getString("Email"));
					userObj.setPhonenumber(rs1.getString("phonenumber"));
					userObj.setTotal(rs.getDouble("user_total"));
					users.add(userObj);
				}
			}
		}}catch(Exception e) {
//			StringWriter sw = new StringWriter();
//			PrintWriter pw = new PrintWriter(sw);
//			e.printStackTrace(pw);
//			String sStackTrace = sw.toString(); // stack trace as a string
//			userObj.setUsername(sStackTrace); 
//			users.add(userObj);
//			return users;
			System.out.print(e);
		}
		return users;
	
	}
}
