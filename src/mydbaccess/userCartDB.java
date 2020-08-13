package mydbaccess;

import java.sql.*;

import myclasses.*;
import java.util.ArrayList;
import java.io.StringWriter;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.text.DecimalFormat;


public class userCartDB {
	PreparedStatement ppst;
	String query;
	ResultSet rs;
	Connection conn = null;
	
	public ArrayList<cartObject> createCart(int productID,int quantity) {
	cartObject cartObj = new cartObject();
	ArrayList<cartObject> cart = new ArrayList<cartObject>();
	//Connecting to Database
	try {
		Class.forName("com.mysql.jdbc.Driver");
		conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
		// conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=admin&password=@dmin1!&serverTimezone=UTC&characterEncoding=latin1");
	} catch (Exception e) {
		cartObj.setError(e.toString());
		cart.add(cartObj);
		return cart;
		
	}
		try{
			//Get ProductID here
			//Get Quantity here
			cartObj.setProductID(productID);
			cartObj.setProductQuantity(quantity);
		
			try {
				if (conn == null) {
					cartObj.setError("Conn Error");
					cart.add(cartObj);
					conn.close();
				} else {
					String query = "SELECT * FROM products WHERE product_id = ?";
					PreparedStatement ppst = conn.prepareStatement(query);
					ppst.setInt(1, productID);
					ResultSet rs = ppst.executeQuery();
					while (rs.next()) {
						cartObj.setProductName(rs.getString("name"));
						cartObj.setProductPrice(rs.getDouble("r_price"));
						cartObj.setProductImage(rs.getString("image"));
						System.out.print("\nUser Input: "+cartObj.getProductQuantity());
						System.out.print("\nDatabase : "+rs.getInt("stock_quantity"));
						if(cartObj.getProductQuantity() > rs.getInt("stock_quantity")) {//More than Quantity
							cartObj.setError("OverStk");
							cart.add(cartObj);
							return cart;
						}else if(cartObj.getProductQuantity() < 0) {
							cartObj.setError("Invalid");
							cart.add(cartObj);
							return cart;
						}
					}
					conn.close();
					cart.add(cartObj);
					return cart;//Successful
				}
			} catch (Exception e) {
				cartObj.setError(e.toString());
				cart.add(cartObj);
				return cart;
			}
			
		}catch(Exception e){
			cartObj.setError(e.toString());
			cart.add(cartObj);
			return cart;
		}
		cartObj.setError("Error");
		cart.add(cartObj);
		return cart;
	}
	public ArrayList<cartObject> addToCart(ArrayList<cartObject> cart,int productID,int quantity) {
		//Connecting to Database
		cartObject cartObj = new cartObject();
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
			// conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=admin&password=@dmin1!&serverTimezone=UTC&characterEncoding=latin1");
		} catch (Exception e) {
			cartObj.setError(e.toString());
			cart.add(cartObj);
			return cart;
		}

		try {
			if (conn == null) {
				cartObj.setError("Conn Error");
				cart.add(cartObj);
				conn.close();
			} else {
//				
				for (int x = 0; cart.size() > x; x++) {
					if(cart.get(x).getProductID() == productID) {//If theres already the product Inside
						
						String query = "SELECT * FROM products WHERE product_id = ?";
						PreparedStatement ppst = conn.prepareStatement(query);
						ppst.setInt(1, productID);
						ResultSet rs = ppst.executeQuery();
						
						int newQty = cart.get(x).getProductQuantity() + quantity;
						System.out.print("\nProposed New Cart Quantity: "+newQty);
						while(rs.next()) {
							if(newQty > rs.getInt("stock_quantity")) {//More than Quantity
								cartObj.setError("OverStk");
								cart.add(cartObj);
								return cart;
							}else if(newQty < 0) {
								cartObj.setError("Invalid");
								cart.add(cartObj);
								return cart;
							}
						}
						cart.get(x).setProductQuantity(newQty);
						return cart;
					}
				}
						//Adding Normally
						cartObj.setProductID(productID);
						cartObj.setProductQuantity(quantity);
						
						try {
								String query = "SELECT * FROM products WHERE product_id = ?";
								PreparedStatement ppst = conn.prepareStatement(query);
								ppst.setInt(1, productID);
								ResultSet rs = ppst.executeQuery();
								while (rs.next()) {
									cartObj.setProductName(rs.getString("name"));
									cartObj.setProductPrice(rs.getDouble("r_price"));
									cartObj.setProductImage(rs.getString("image"));
									if(cartObj.getProductQuantity() > rs.getInt("stock_quantity")) {//More than Quantity
										
										cartObj.setError("OverStk");
										cart.add(cartObj);
										return cart;
									}else if(cartObj.getProductQuantity() < 0) {
										cartObj.setError("Invalid");
										cart.add(cartObj);
										return cart;
									}
								}
								conn.close();
								cart.add(cartObj);
								return cart;//Successful
						} catch (Exception e) {
							cartObj.setError("Error");
							cart.add(cartObj);
							return cart;	
						}
						
				}
				conn.close();
				cartObj.setError("Error");
				cart.add(cartObj);
				return cart;
		} catch (Exception e) {
			cartObj.setError(e.toString());
			cart.add(cartObj);
			return cart;
		}
	}
	public ArrayList<cartObject> changeQuantity(ArrayList<cartObject> cart,int productID,int quantity){
		int dbquantity = 0;
		cartObject cartObj = new cartObject();
		try{
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
			// conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=admin&password=@dmin1!&serverTimezone=UTC&characterEncoding=latin1");
			if(conn == null){
				//response.sendRedirect("JAD-Project/WebContent/Assignment1/cart.jsp");
			  	conn.close();
			}else{
				String query = "SELECT * FROM products WHERE product_id ="+productID;
				Statement st = conn.createStatement();
				ResultSet rs = st.executeQuery(query);
				while(rs.next()){
					dbquantity = rs.getInt("stock_quantity");
				} 
				conn.close();
				if(quantity <= 0){//User Inputted 0 or negative
					cartObj.setError("Invalid");
					cart.add(cartObj);
					return cart;
				}else if(dbquantity < quantity){//User input is bigger than stock quantity
					cartObj.setError("OverStk");
					cart.add(cartObj);
					return cart;
				}else{
					for(int i = 0;cart.size() > i;i++) {
						if(cart.get(i).getProductID() == productID) {
							cart.get(i).setProductQuantity(quantity);
						}
						
					}
					
					//request.getSession().setAttribute("productID",productID);
					//response.sendRedirect("JAD-Project/WebContent/Assignment1/cart.jsp");
				}
			}
		}catch(Exception e){
			cartObj.setError(e.toString());
			cart.add(cartObj);
			return cart;
		}
		return cart;
	}
	public boolean checkout(ArrayList<cartObject> cart,int userid,String company,String address,String country,String zipcode,String cardnumber,String CCV,String expirydate,String notes){
	java.util.Date dt = new java.util.Date();
	java.text.SimpleDateFormat sdf = 
	new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String currentTime = sdf.format(dt);
	
	double ptotal = 0.00;
	Connection conn = null;
    try{
		  	Class.forName("com.mysql.jdbc.Driver");
		  	conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
		  	// conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=admin&password=@dmin1!&serverTimezone=UTC&characterEncoding=latin1");
    }catch(Exception e){
    	System.out.print(e);
    	return false;
  	}
    if(conn == null){
  		System.out.print("Conn Error");
  		//conn.close();
  		return false;
  	}else{
  		
  		try {
  		
		for(int i = 0;cart.size()>i;i++){
			ptotal += cart.get(i).getProductQuantity()*cart.get(i).getProductPrice();
		}
		
  		for(int x = 0;cart.size()>x;x++){
  			
	  		query = "UPDATE products SET stock_quantity = (products.stock_quantity-?), sold = (products.sold+?) WHERE product_id = ?";
	  		PreparedStatement ppst = conn.prepareStatement(query);
	  		ppst.setInt(1,cart.get(x).getProductQuantity());
	  		ppst.setInt(2,cart.get(x).getProductQuantity());
	  		ppst.setInt(3,cart.get(x).getProductID());
			int rsint = ppst.executeUpdate();
		
			
			query = "INSERT INTO orders(address,country,zipcode,company,fk_userid,total,fk_productid,quantity,notes,cardnumber,CCV,expirydate,date) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)";
			ppst = conn.prepareStatement(query);
			ppst.setString(1,address);
			ppst.setString(2,country);
			ppst.setString(3,zipcode);
			ppst.setString(4,company);
			ppst.setInt(5,userid);
			ppst.setDouble(6, ptotal * cart.get(x).getProductQuantity());
			ppst.setInt(7,cart.get(x).getProductID());
			ppst.setInt(8,cart.get(x).getProductQuantity());
			ppst.setString(9,notes);
			ppst.setString(10,cardnumber);
			ppst.setString(11,CCV);
			ppst.setString(12,expirydate);
			ppst.setString(13,currentTime);
  		  	rsint = ppst.executeUpdate();
	}
  		conn.close();
  		return true;
  	}catch(Exception e) {
    	System.out.print(e);
    	return false;
  	}
  	}
	}
	public ArrayList<cartObject> deleteObject(ArrayList<cartObject> cart,int productID){
		for(int x = 0;cart.size() > x;x++) {
			if(cart.get(x).getProductID() == productID) {
				cart.remove(x);
			}
		}
		return cart;
	}
	
}
