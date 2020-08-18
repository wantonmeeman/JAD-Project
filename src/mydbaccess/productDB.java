package mydbaccess;

import myclasses.*;
import java.sql.*;
import java.util.ArrayList;

public class productDB {

	PreparedStatement ppst;
	Statement st;
	String query;
	ResultSet rs;
	Connection conn = null;

	String query1 = "";
	String query2 = "";
	ResultSet rs2;
	ResultSet rs1;

	String sortSuffix = "";
	String filterSuffix = "";
	String searchSuffix = "";
	
	
	//Get All With Limit, pagination 
	public ArrayList<product> getProducts(String productSort, String productFilter, String productSearch, int page) {// First
																														// Tab

		ArrayList<product> productList = new ArrayList<product>();
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
			// conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=admin&password=@dmin1!&serverTimezone=UTC&characterEncoding=latin1");
		} catch (Exception e) {
			System.out.print(e);
		}
		try {
			if (conn == null) {
				System.out.print("Conn Error");
				conn.close();
			} else {

				String query = "SELECT * FROM products ";

				// Sorting Logic
				
				if(productSort == null || productSort.equals("")) {
					sortSuffix = "";
				}else if(productSort.charAt(0) == 'A'){
					productSort = productSort.substring(1);
					sortSuffix = "ORDER BY "+productSort+" ASC ";
				}else if(productSort.charAt(0) == 'D'){
					productSort = productSort.substring(1);
					sortSuffix = "ORDER BY "+productSort+" DESC ";
				}
				
//				if (productSort == null || productSort.equals("null") || productSort.equals("")) {// Can Add a																		// btw,maybe later?
//					sortSuffix = " ";
//				} else if (productSort.equals("cPrice")) {
//					sortSuffix = " ORDER BY c_price ";
//				} else if (productSort.equals("rPrice")) {
//					sortSuffix = " ORDER BY r_price ";
//				} else if (productSort.equals("Quantity")) {
//					sortSuffix = " ORDER BY stock_quantity ";
//				} else if (productSort.equals("itemsSold")) {
//					sortSuffix = " ORDER BY sold ";
//				}

				// Filtering Logic

				if (productFilter == null || productFilter.equals("null") || productFilter.equals("")) {
					filterSuffix = "";
				} else {
					filterSuffix = " WHERE product_cat = '" + productFilter + "'";
				}

				// Searching Logic

				if (filterSuffix.equals("")) {
					searchSuffix = " WHERE name LIKE ? ";
				} else {
					searchSuffix = " AND name LIKE ? ";
				}

				if (productSearch == null || productSearch.equals("null") || productSearch == "") {
					searchSuffix = " ";
				}

				// This Adds all of the suffixes together to perform a search

				query = query + filterSuffix + searchSuffix + sortSuffix + "LIMIT ? , 5";
				if (searchSuffix.equals(" ")) {
					ppst = conn.prepareStatement(query);
					ppst.setInt(1, (page - 1) * 5);
					rs = ppst.executeQuery();
				} else {
					ppst = conn.prepareStatement(query);
					ppst.setString(1, "%" + productSearch + "%");
					ppst.setInt(2, (page - 1) * 5);
					rs = ppst.executeQuery();
				}

				while (rs.next()) {
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
		} catch (Exception e) {
			System.out.print(ppst.toString());
			e.printStackTrace();
			return null;
		}
		return null;
	}

	
	//Get totals , for pagination
	public int getTotalProducts(String productSort, String productFilter, String productSearch) {
		int total_products = 0;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
			// conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=admin&password=@dmin1!&serverTimezone=UTC&characterEncoding=latin1");
		} catch (Exception e) {
			System.out.print(e);
		}
		try {
			if (conn == null) {
				System.out.print("Conn Error");
				conn.close();
			} else {

				String query = "SELECT COUNT(*) as total_products FROM products ";

				// Sorting Logic

				if (productSort == null || productSort.equals("null") || productSort.equals("")) {// Can Add a
																									// descending option
																									// btw,maybe later?
					sortSuffix = " ";
				} else if (productSort.equals("cPrice")) {
					sortSuffix = " ORDER BY c_price ";
				} else if (productSort.equals("rPrice")) {
					sortSuffix = " ORDER BY r_price ";
				} else if (productSort.equals("Quantity")) {
					sortSuffix = " ORDER BY stock_quantity ";
				} else if (productSort.equals("itemsSold")) {
					sortSuffix = " ORDER BY sold ";
				}

				// Filtering Logic

				if (productFilter == null || productFilter.equals("null") || productFilter.equals("")) {
					filterSuffix = "";
				} else {
					filterSuffix = " WHERE product_cat = '" + productFilter + "'";
				}

				// Searching Logic

				if (filterSuffix.equals("")) {
					// searchSuffix = " WHERE name LIKE '%"+productSearch+"%' ";
					searchSuffix = " WHERE name LIKE ? ";
				} else {
					// searchSuffix = " AND name LIKE '%"+productSearch+"%' ";
					searchSuffix = " WHERE name LIKE ? ";
				}

				if (productSearch == null || productSearch.equals("null") || productSearch == "") {
					searchSuffix = " ";
				}

				// This Adds all of the suffixes together to perform a search

				query = query + filterSuffix + searchSuffix + sortSuffix;

				if (searchSuffix.equals(" ")) {
					st = conn.createStatement();
					rs = st.executeQuery(query);
				} else {
					ppst = conn.prepareStatement(query);
					ppst.setString(1, "%" + productSearch + "%");
					rs = ppst.executeQuery();
				}

				while (rs.next()) {
					total_products = rs.getInt("total_products");
				}
				return total_products;
			}
		} catch (Exception e) {
			System.out.print(e);
			return 0;
		}
		return 0;
	}
	
	
	public int getTotalLowProducts(int lowStockRange) {
		ArrayList<product> productList = new ArrayList<product>();
		try {
			if (lowStockRange == 0) {
				query = "SELECT COUNT(*) as total_products FROM products WHERE stock_quantity < 100";
				st = conn.createStatement();
				rs = st.executeQuery(query);
			} else {
				query = "SELECT COUNT(*) as total_products FROM products WHERE stock_quantity < ?";
				ppst = conn.prepareStatement(query);
				ppst.setInt(1, lowStockRange);
				rs = ppst.executeQuery();
			}

			while (rs.next()) {
				return rs.getInt("total_products");
			}
			return 0;
		} catch (Exception e) {
			System.out.print(e);
		}
		return 0;
	}

	//Get products below a certain amount limited by 5,pagination
	public ArrayList<product> getLowProducts(int lowStockRange, int page) {
		ArrayList<product> productList = new ArrayList<product>();
		try {
			if (lowStockRange == 0) {
				query = "SELECT * FROM products WHERE stock_quantity < 100  LIMIT ?,5";
				ppst = conn.prepareStatement(query);
				ppst.setInt(1, (page - 1) * 5);
				rs = ppst.executeQuery();
			} else {
				query = "SELECT * FROM products WHERE stock_quantity < ?  LIMIT ?,5";
				ppst = conn.prepareStatement(query);
				ppst.setInt(1, lowStockRange);
				ppst.setInt(2, (page - 1) * 5);
				rs = ppst.executeQuery();
			}

			while (rs.next()) {
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
		} catch (Exception e) {
			System.out.print(e);
		}
		return null;
	}

	
	// Get 1 Object, by productID
	public product getProduct(int productID) {
		product productObj = new product();
		Connection conn = null;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn =  DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
			// conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=admin&password=@dmin1!&serverTimezone=UTC&characterEncoding=latin1");
		} catch (Exception e) {
			System.out.print(e);
			return null;
		}
		try {
			if (conn == null) {
				System.out.print("Conn Error");
				conn.close();
			} else {
				query = "SELECT * FROM products WHERE product_id = ?";
				ppst = conn.prepareStatement(query);
				ppst.setInt(1, productID);
				rs = ppst.executeQuery();

				while (rs.next()) {
					productObj.setProductID(rs.getInt("product_id"));
					productObj.setProductName(rs.getString("name"));
					productObj.setProductBrief_Description(rs.getString("brief_description"));
					productObj.setProductDetailed_Description(rs.getString("detailed_description"));
					productObj.setProductCPrice(rs.getDouble("c_price"));
					productObj.setProductRPrice(rs.getDouble("r_price"));
					productObj.setProductStock_Quantity(rs.getInt("stock_quantity"));
					productObj.setProduct_cat(rs.getString("product_cat"));
					productObj.setProductImage(rs.getString("image"));
				}
				return productObj;
			}
		} catch (Exception e) {
			return null;
		}
		return null;
	}
	
	
	// Edit Product
	public boolean editProduct(int productID,String productTitle,String bDescription,String fDescription,String cPrice,String rPrice, String stockQuantity,String productCat) {
		product productObj = new product();
		Connection conn = null;
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
			// conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=admin&password=@dmin1!&serverTimezone=UTC&characterEncoding=latin1");
		} catch (Exception e) {
			System.out.print(e);
			return false;
		}
		try {
			System.out.print("Stuff");
			if (conn == null) {
				System.out.print("Conn Error");
				conn.close();
			} else {
				   query = "UPDATE products SET name = ?, brief_description = ?, detailed_description = ?, c_price = ?, r_price = ?, stock_quantity = ?, product_cat = ? WHERE product_id = ?";
			       PreparedStatement pstmt = conn.prepareStatement(query);
			       System.out.print("Stuff");
			       pstmt.setString(1, productTitle);
			       pstmt.setString(2, bDescription);
			       pstmt.setString(3, fDescription);
			       pstmt.setFloat(4, Float.parseFloat(cPrice));
			       pstmt.setFloat(5, Float.parseFloat(rPrice));
			       pstmt.setInt(6, Integer.parseInt(stockQuantity));
			       pstmt.setString(7, productCat);
			       pstmt.setInt(8, productID);
			       
			       int rs = pstmt.executeUpdate();

			      if(rs != 1){
			    	  
			    	  System.out.print("Database Error");
			    	  conn.close();
			    	  return false;
			      }else{
			    	  conn.close();
			    	  return true;
			      }
			}
		} catch (Exception e) {
			return false;
		}
		return false;
	}
	
	
	public boolean deleteProduct(int productID) {
		Connection conn = null;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
			// conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=admin&password=@dmin1!&serverTimezone=UTC&characterEncoding=latin1");
		} catch (Exception e) {
			System.out.print(e);
			return false;
		}
		try {
			if (conn == null) {
				System.out.print("Conn Error");
				conn.close();
			} else {
				String query = "DELETE FROM products WHERE product_id = ?";
				PreparedStatement ppst = conn.prepareStatement(query);
				ppst.setInt(1, productID);
				int rs = ppst.executeUpdate();
				conn.close();
				if (rs != 1) {
					System.out.print("Database Error");
					return false;
				} else {
					return true;
				}
			}

		} catch (Exception e) {
			return false;
		}
		return false;
	}
}
