package mydbaccess;

import java.sql.*;

import myclasses.ProductClass;

public class ProductDB {
	
	public static ProductClass getProductByName (String name) {
		ProductClass product = null;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			String connURL = "jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC";
			Connection conn = DriverManager.getConnection(connURL);
			
			String query = "SELECT * FROM products WHERE name = ?";
			PreparedStatement pstmt = conn.prepareStatement(query);
			pstmt.setString(1, name);
			
			ResultSet rs = pstmt.executeQuery();
			
			if (rs.next()) {
				product = new ProductClass(rs.getInt("product_id"), rs.getString("name"), rs.getDouble("c_price"), rs.getDouble("r_price"), 
						rs.getInt("stock_quantity"), rs.getString("product_cat"), rs.getString("brief_description"), 
						rs.getString("detailed_description"), rs.getString("image"), rs.getString("sold"));
				
			}
			
			conn.close();
			
		} catch (Exception e) {
			System.out.println("Error :" + e);
		}
		
		return product;
	}
	
	public static int addProduct (String name, String briefDesc, String detailedDesc, String c_price, String r_price, String stockQuantity, String productCat, String sold){
		int productId = 0;
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
			String connURL = "jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC";
			Connection conn = DriverManager.getConnection(connURL);
			
			String query = "INSERT INTO products(name, brief_description, detailed_description, c_price, r_price, stock_quantity, product_cat, sold) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
			PreparedStatement pstmt = conn.prepareStatement(query);

			pstmt.setString(1, name);
			pstmt.setString(2, briefDesc);
			pstmt.setString(3, detailedDesc);
			pstmt.setFloat(4, Float.parseFloat(c_price));
			pstmt.setFloat(5, Float.parseFloat(r_price));
			pstmt.setInt(6, Integer.parseInt(stockQuantity));
			pstmt.setString(7, productCat);
			pstmt.setString(8, sold);
			
			int rs = pstmt.executeUpdate();
			
			if (rs != 0) {
				query = "SELECT product_id FROM products WHERE name = ?";
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, name);
				
				ResultSet productIdRS = pstmt.executeQuery();
				
				if (productIdRS.next()) {
					productId = productIdRS.getInt("product_id");
				}
			}
			
			conn.close();

		} catch (Exception e) {
			System.out.println("Error :" + e);
		}
		
		
		return productId;
	}
	
	public static int addProdImg (int product_id, String image){
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
			String connURL = "jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC";
			Connection conn = DriverManager.getConnection(connURL);
			
			String query = "UPDATE products SET image = ? WHERE product_id = ?";
			PreparedStatement pstmt = conn.prepareStatement(query);

			pstmt.setString(1, image);
			pstmt.setInt(2, product_id);
			
			int rs = pstmt.executeUpdate();
			
			conn.close();
			
			return rs;

		} catch (Exception e) {
			System.out.println("Error :" + e);
			return 0;
		}
		
	}
}
