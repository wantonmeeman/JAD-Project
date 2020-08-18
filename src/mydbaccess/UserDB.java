package mydbaccess;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.text.DecimalFormat;

import mydbaccess.UserDB;
import myclasses.user;

public class UserDB {
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
	
	
	// Get User by ID
	public user getUserDetails(int UserID) {
		Connection conn = null;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
			// conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=admin&password=@dmin1!&serverTimezone=UTC&characterEncoding=latin1");
		} catch (Exception e) {
			System.out.print(e);
			return null;
		}
		if (conn == null) {
			System.out.print("Conn Error");
			// conn.close();
			return null;
		} else {
			user userObj = new user();
			query = "SELECT * FROM users where user_id=?";
			try {
				ppst = conn.prepareStatement(query);
				ppst.setInt(1, UserID);
				rs = ppst.executeQuery();
				while (rs.next()) {
					userObj.setUsername(rs.getString("username"));
					userObj.setUserid(rs.getInt("user_id"));
					userObj.setPassword(rs.getString("password"));
					userObj.setEmail(rs.getString("email"));
					userObj.setRole(rs.getString("role"));
					userObj.setFirstname(rs.getString("firstname"));
					userObj.setLastname(rs.getString("lastname"));
					userObj.setPhonenumber(rs.getString("phonenumber"));
					userObj.setCardnumber(rs.getString("cardnumber"));
					userObj.setCcv(rs.getString("CCV"));
					userObj.setExpirydate(rs.getString("expirydate"));
					userObj.setCompany(rs.getString("company"));
					userObj.setAddress(rs.getString("address"));
					userObj.setCountry(rs.getString("country"));
					userObj.setZipcode(rs.getString("zipcode"));
				}
			} catch (Exception e) {
				System.out.print(e);
				return null;
			}
			return userObj;
		}
	}

	// Get All Users + Pagination
	public ArrayList<user> getAllUser(String userSort,String userSearch,String userCategory,String roleFilter,int page) {//First Tab
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
			
		if(userSort == null || userSort.equals("")) {
			userSort = "";
		}else if(userSort.equals("DTotal") || userSort.equals("ATotal")) {
			
		}else if(userSort.charAt(0) == 'A'){
			userSort = userSort.substring(1);
			sortSuffix = "ORDER BY "+userSort+" ASC ";
		}else if(userSort.charAt(0) == 'D'){
			userSort = userSort.substring(1);
			sortSuffix = "ORDER BY "+userSort+" DESC ";
		}
			if((userSearch == null || userSearch.equals("") || userSearch.equals("null")) && (roleFilter == null || roleFilter.equals("") || roleFilter.equals("null"))){
	  		  query = "SELECT * FROM users "+sortSuffix+"LIMIT ? , 5";
	  		  ppst = conn.prepareStatement(query);
	  		  ppst.setInt(1,(page-1)*5);
		      rs = ppst.executeQuery();
	  		}else if(roleFilter == null || roleFilter.equals("") || roleFilter.equals("null")){
	  		  query = "SELECT * FROM users WHERE "+userCategory+" LIKE ? "+sortSuffix+"LIMIT ? , 5"; //Unsafe, however there is no workaround.
	  		  ppst = conn.prepareStatement(query);
	  		  ppst.setString(1,"%"+userSearch+"%");
	  		  ppst.setInt(2,(page-1)*5);
	  		  rs = ppst.executeQuery();
	  		}else if((userSearch == null || userSearch.equals("") || userSearch.equals("null"))){
	  			query = "SELECT * FROM users WHERE role LIKE ? "+sortSuffix+"LIMIT ? , 5"; 
		  		ppst = conn.prepareStatement(query);
		  		ppst.setString(1,"%"+roleFilter+"%");
		  		ppst.setInt(2,(page-1)*5);
		  		rs = ppst.executeQuery();
	  		}else {//Both not null
	  			query = "SELECT * FROM users WHERE role LIKE ? AND "+userCategory+" LIKE ? "+sortSuffix+"LIMIT ? , 5"; //Unsafe, however there is no workaround.
		  		ppst = conn.prepareStatement(query);
		  		ppst.setString(1,"%"+roleFilter+"%");
		  		ppst.setString(2,"%"+userSearch+"%");
		  		ppst.setInt(3,(page-1)*5);
		  		rs = ppst.executeQuery();
	  		}
	        	while(rs.next()){
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
	        	    userObj.setCompany(rs.getString("company"));
	        	    userObj.setAddress(rs.getString("address"));
	        	    userObj.setCountry(rs.getString("country"));
	        	    
	        	    query = "SELECT SUM(total) as user_total FROM orders WHERE fk_userid = ?";
	        		ppst = conn.prepareStatement(query);
	        		ppst.setInt(1,rs.getInt("user_id"));
	        		rs1 = ppst.executeQuery();
	        		
	        		while(rs1.next()) {
	        			BigDecimal d = new BigDecimal(format.format(rs1.getDouble("user_total")));
	        			String result = d.toPlainString();
	        			userObj.setTotal(result);
	        		}
	        		
	        	    users.add(userObj);
	        	}
	        	
	        	if(userSort.equals("DTotal")) {
	        		String temp = "";  //Bubble Sorting
	              for(int i=0; i < users.size();i++){  //Desc
	                      for(int j=1; j < (users.size()-i); j++){  
	                               if(Double.valueOf(users.get(j-1).getTotal()) < Double.valueOf(users.get(j).getTotal())){  
	                                      //swap elements  
	                                      temp = users.get(j-1).getTotal();  
	                                      users.get(j-1).setTotal(users.get(j).getTotal());  
	                                      users.get(j).setTotal(temp);  
	                              }  
	                               
	                      }  
	              }  
	        	}else if(userSort.equals("ATotal")) {
	        		String temp = "";  //Bubble Sorting
	              for(int i=0; i < users.size();i++){  //Asc
                      for(int j=1; j < (users.size()-i); j++){  
                               if(Double.valueOf(users.get(j-1).getTotal()) > Double.valueOf(users.get(j).getTotal())){  
                                      //swap elements  
                                      temp = users.get(j-1).getTotal();  
                                      users.get(j-1).setTotal(users.get(j).getTotal());  
                                      users.get(j).setTotal(temp);  
                              }  
                               
                      }  
	              }  
	        	}
	        	return users;
		}catch(Exception e) {
			System.out.print("\n"+ppst.toString());
			e.printStackTrace();
			return null;
		}
	}
	
	// Get Number of Users
	public int getTotalUsers(String userSearch,String userCategory,String roleFilter) {//For Pagination, we can get rid of this and fuse it with the normal function with a extra attribute/getset.
		int total_users = 0;
		try{
		  	Class.forName("com.mysql.jdbc.Driver");
		  	conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
		  	// conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=admin&password=@dmin1!&serverTimezone=UTC&characterEncoding=latin1");
		}catch(Exception e){
			return 0;
		}
		try {
			if((userSearch == null || userSearch.equals("")) && (roleFilter == null || roleFilter.equals(""))){
		  		  query = "SELECT COUNT(*) as total_users FROM users";
		  		  ppst = conn.prepareStatement(query);
			      rs = ppst.executeQuery();
		  		}else if(roleFilter == null || roleFilter.equals("")){
		  		  query = "SELECT COUNT(*) as total_users FROM users WHERE "+userCategory+" LIKE ?"; //Unsafe, however there is no workaround.
		  		  ppst = conn.prepareStatement(query);
		  		  ppst.setString(1,"%"+userSearch+"%");
		  		  rs = ppst.executeQuery();
		  		}else if((userSearch == null || userSearch.equals(""))){
		  			query = "SELECT COUNT(*) as total_users FROM users WHERE role LIKE ?"; 
			  		ppst = conn.prepareStatement(query);
			  		ppst.setString(1,"%"+roleFilter+"%");
			  		rs = ppst.executeQuery();
		  		}else {//Both not null
		  			query = "SELECT COUNT(*) as total_users FROM users WHERE role LIKE ? AND "+userCategory+" LIKE ?"; //Unsafe, however there is no workaround.
			  		ppst = conn.prepareStatement(query);
			  		ppst.setString(1,"%"+roleFilter+"%");
			  		ppst.setString(2,"%"+userSearch+"%");
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
	
	// Edit User Info at profile.jsp (not billing)
	public static int editUserInfo(String username, String password, String email, String firstname, String lastname,
			String phonenumber, int UserID) {
		Connection conn = null;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
			String query = "UPDATE users SET username = ?, email = ?, firstname = ?, lastname = ?, phonenumber = ? WHERE user_id = ?";
			PreparedStatement ppst = conn.prepareStatement(query);

			ppst.setString(1, username);
			ppst.setString(2, email);
			ppst.setString(3, firstname);
			ppst.setString(4, lastname);
			ppst.setString(5, phonenumber);
			ppst.setInt(6, UserID);
			int rs = ppst.executeUpdate();

			conn.close();

			return rs;
		} catch (Exception e) {
			System.out.print(e);
			return 0;
		}
	}

	// Edit User Billing Details at profile.jsp (not Info)
	public static int editUserBilling(String address, String company, String country, String zipcode, String cardnumber,
			String ccv, String expirydate, int UserID) {
		Connection conn = null;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
			String query = "UPDATE users SET address = ?, company = ?, country = ?, zipcode = ?, cardnumber = ?, CCV = ?, expirydate = ? WHERE user_id = ?";
			PreparedStatement ppst = conn.prepareStatement(query);

			ppst.setString(1, address);
			ppst.setString(2, company);
			ppst.setString(3, country);
			ppst.setString(4, zipcode);
			ppst.setString(5, cardnumber);
			ppst.setString(6, ccv);
			ppst.setString(7, expirydate);
			ppst.setInt(8, UserID);
			int rs = ppst.executeUpdate();

			if (rs == 1) {

			}

			return rs;

		} catch (Exception e) {
			System.out.print(e);
			return 0;
		}
	}
	
	
}
