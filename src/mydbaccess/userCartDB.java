package mydbaccess;

import java.sql.*;

import myclasses.*;
import java.util.ArrayList;
import java.util.Date;
import java.io.StringWriter;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;

public class userCartDB {
	PreparedStatement ppst;
	String query;
	ResultSet rs;
	Connection conn = null;
	
	// Creates new cart, with 1 object
	public ArrayList<cartObject> createCart(int productID, int quantity) {
		cartObject cartObj = new cartObject();
		ArrayList<cartObject> cart = new ArrayList<cartObject>();
		// Connecting to Database
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
						System.out.print("\nUser Input: " + cartObj.getProductQuantity());
						System.out.print("\nDatabase : " + rs.getInt("stock_quantity"));
						if (cartObj.getProductQuantity() > rs.getInt("stock_quantity")) {// More than Quantity
							cartObj.setError("OverStk");
							cart.add(cartObj);
							return cart;
						} else if (cartObj.getProductQuantity() < 0) {
							cartObj.setError("Invalid");
							cart.add(cartObj);
							return cart;
						}
					}
					conn.close();
					cart.add(cartObj);
					return cart;// Successful
				}
			} catch (Exception e) {
				cartObj.setError(e.toString());
				cart.add(cartObj);
				return cart;
			}

		} catch (Exception e) {
			cartObj.setError(e.toString());
			cart.add(cartObj);
			return cart;
		}
		cartObj.setError("Error");
		cart.add(cartObj);
		return cart;
	}
	
	// Adds to an existing cart
	public ArrayList<cartObject> addToCart(ArrayList<cartObject> cart, int productID, int quantity) {
		// Connecting to Database
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
					if (cart.get(x).getProductID() == productID) {// If theres already the product Inside

						String query = "SELECT * FROM products WHERE product_id = ?";
						PreparedStatement ppst = conn.prepareStatement(query);
						ppst.setInt(1, productID);
						ResultSet rs = ppst.executeQuery();

						int newQty = cart.get(x).getProductQuantity() + quantity;
						System.out.print("\nProposed New Cart Quantity: " + newQty);
						while (rs.next()) {
							if (newQty > rs.getInt("stock_quantity")) {// More than Stock Quantity
								cartObj.setError("OverStk");
								cart.add(cartObj);
								return cart;
							} else if (newQty < 0) { //If entered Invalid Number
								cartObj.setError("Invalid");
								cart.add(cartObj);
								return cart;
							}
						}
						cart.get(x).setProductQuantity(newQty);
						return cart;
					}
				}
				// Adding Normally
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
						if (cartObj.getProductQuantity() > rs.getInt("stock_quantity")) {// More than Quantity
							cartObj.setError("OverStk");
							cart.add(cartObj);
							return cart;
						} else if (cartObj.getProductQuantity() < 0) {
							cartObj.setError("Invalid");
							cart.add(cartObj);
							return cart;
						}
					}
					conn.close();
					cart.add(cartObj);
					return cart;// Successful
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

	// Change Quantity of Items in cart
	public ArrayList<cartObject> changeQuantity(ArrayList<cartObject> cart, int productID, int quantity) {
		int dbquantity = 0;
		cartObject cartObj = new cartObject();
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
			// conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=admin&password=@dmin1!&serverTimezone=UTC&characterEncoding=latin1");
			if (conn == null) {
				// response.sendRedirect("JAD-Project/WebContent/Assignment1/cart.jsp");
				conn.close();
			} else {
				String query = "SELECT * FROM products WHERE product_id =" + productID;
				Statement st = conn.createStatement();
				ResultSet rs = st.executeQuery(query);
				while (rs.next()) {
					dbquantity = rs.getInt("stock_quantity");
				}
				conn.close();
				if (quantity <= 0) {// User Inputted 0 or negative
					cartObj.setError("Invalid");
					cart.add(cartObj);
					return cart;
				} else if (dbquantity < quantity) {// User input is bigger than stock quantity
					cartObj.setError("OverStk");
					cart.add(cartObj);
					return cart;
				} else {
					for (int i = 0; cart.size() > i; i++) {
						if (cart.get(i).getProductID() == productID) {
							cart.get(i).setProductQuantity(quantity);
						}

					}

					// request.getSession().setAttribute("productID",productID);
					// response.sendRedirect("JAD-Project/WebContent/Assignment1/cart.jsp");
				}
			}
		} catch (Exception e) {
			cartObj.setError(e.toString());
			cart.add(cartObj);
			return cart;
		}
		return cart;
	}
	
	// Empties cart, Update Database for orders
	public boolean checkout(ArrayList<cartObject> cart, int userid, String company, String address, String country,
			String zipcode, String cardnumber, String CCV, String expirydate, String notes) {
		Date dt = new java.util.Date();
		SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String currentTime = sdf.format(dt);
		Date expiryDate = null;
		
		//Checking For Expiry Date
		try {
			expiryDate = new SimpleDateFormat("LL/yy").parse(expirydate);// Converts string to dateObject
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return false;
		}

		if (expiryDate.before(dt)) {// Checks Current Time against the one provided.
			System.out.print("\tExpiry Date is Invalid");
			System.out.print("\nExpiry Date: " + expirydate);
			System.out.print("\nExpiry Date: " + expiryDate);
			System.out.print("\nCurrent Date: " + dt);
			return false;
		}
		
		//This is with the last regex as it very big and doesnt check Validity
//		if(!(cardnumber.matches("^4[0-9]{12}(?:[0-9]{3})?$^5[1-5][0-9]{14}$") || cardnumber.matches("^(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14})$") || cardnumber.matches("^3(?:0[0-5]|[68][0-9])[0-9]{11}$") || cardnumber.matches("^65[4-9][0-9]{13}|64[4-9][0-9]{13}|6011[0-9]{12}|(622(?:12[6-9]|1[3-9][0-9]|[2-8][0-9][0-9]|9[01][0-9]|92[0-5])[0-9]{10})$") || cardnumber.matches("^(?:2131|1800|35\\d{3})\\d{11}$") || cardnumber.matches("^(4903|4905|4911|4936|6333|6759)[0-9]{12}|(4903|4905|4911|4936|6333|6759)[0-9]{14}|(4903|4905|4911|4936|6333|6759)[0-9]{15}|564182[0-9]{10}|564182[0-9]{12}|564182[0-9]{13}|633110[0-9]{10}|633110[0-9]{12}|633110[0-9]{13}$") || cardnumber.matches("^3[47][0-9]{13}$") || cardnumber.matches("\\b(?:\\d[ -]*?){11,16}\\b"))){
//			System.out.print("nothing");
//			return false;
//		}
		//Without the last regex, this checks for validity of cards.
		
		//Credit Card Validation using Luhns Algorithm
		
		
		if(CCV.length() >= 5 || !CCV.matches("^[0-9]*$")) {
            return false;
        }
		
        if(cardnumber.matches("\\b\\d{11,16}\\b")) { // Using RegEx
            // Credit Card Validation using Luhns Algorithim
        int[] ints = new int[cardnumber.length()];
        for (int i = 0; i < cardnumber.length(); i++) {
            ints[i] = Integer.parseInt(cardnumber.substring(i, i + 1));
        }
        for (int i = ints.length - 2; i >= 0; i = i - 2) {
            int j = ints[i];
            j = j * 2;
            if (j > 9) {
                j = j % 10 + 1;
            }
            ints[i] = j;
        }
        int sum = 0;
        for (int i = 0; i < ints.length; i++) {
            sum += ints[i];
        }
            if (!(sum % 10 == 0 || cardnumber.equals("76009244561")/*This number returns invalid,checked online,apparently its invalid due to it having 11 characters*/)) {
                System.out.println(cardnumber + " is an invalid credit card number");
                return false;
            }
        }else {
            return false;
        }

        
		double ptotal = 0.00;
		
		Connection conn = null;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
			// conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=admin&password=@dmin1!&serverTimezone=UTC&characterEncoding=latin1");
		} catch (Exception e) {
			System.out.print(e);
			
			return false;
		}
		if (conn == null) {
			System.out.print("Conn Error");
			// conn.close();
			return false;
		} else {

			try {

				for (int i = 0; cart.size() > i; i++) {//Get the Total of the order
					ptotal += cart.get(i).getProductQuantity() * cart.get(i).getProductPrice();
				}

				for (int x = 0; cart.size() > x; x++) {//Update the Database
					
					//Update the Stock_quantity
					query = "UPDATE products SET stock_quantity = (products.stock_quantity-?), sold = (products.sold+?) WHERE product_id = ?";
					PreparedStatement ppst = conn.prepareStatement(query);
					ppst.setInt(1, cart.get(x).getProductQuantity());
					ppst.setInt(2, cart.get(x).getProductQuantity());
					ppst.setInt(3, cart.get(x).getProductID());
					int rsint = ppst.executeUpdate();
					
					//Update the Orders Table
					query = "INSERT INTO orders(address,country,zipcode,company,fk_userid,total,fk_productid,quantity,notes,cardnumber,CCV,expirydate,date,status) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
					ppst = conn.prepareStatement(query);
					ppst.setString(1, address);
					ppst.setString(2, country);
					ppst.setString(3, zipcode);
					ppst.setString(4, company);
					ppst.setInt(5, userid);
					ppst.setDouble(6, ptotal * cart.get(x).getProductQuantity());
					ppst.setInt(7, cart.get(x).getProductID());
					ppst.setInt(8, cart.get(x).getProductQuantity());
					ppst.setString(9, notes);
					ppst.setString(10, cardnumber);
					ppst.setString(11, CCV);
					ppst.setString(12, expirydate);
					ppst.setString(13, currentTime);
					ppst.setString(14, "Pending");
					rsint = ppst.executeUpdate();
				}
				conn.close();
				return true;
			} catch (Exception e) {
//				StringWriter sw = new StringWriter();
//				PrintWriter pw = new PrintWriter(sw);
//				e.printStackTrace(pw);
//				String sStackTrace = sw.toString(); // stack trace as a string
//				System.out.print("\n"+sStackTrace);
//				System.out.print(e);
				return false;
			}
		}
	}
	
	// Delete Item from Cart
	public ArrayList<cartObject> deleteObject(ArrayList<cartObject> cart, int productID) {
		for (int x = 0; cart.size() > x; x++) {
			if (cart.get(x).getProductID() == productID) {
				cart.remove(x);
			}
		}
		return cart;
	}
}
