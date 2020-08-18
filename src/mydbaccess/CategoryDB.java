package mydbaccess;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;

import myclasses.category;

public class CategoryDB {
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

	// Get ALL Categories
	public ArrayList<category> getAllCategories() {
		ArrayList<category> categoryList = new ArrayList<category>();
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
			// conn =
			// DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=admin&password=@dmin1!&serverTimezone=UTC&characterEncoding=latin1");
		} catch (Exception e) {
			System.out.print(e);
		}
		try {
			if (conn == null) {
				System.out.print("Conn Error");
				conn.close();
			} else {

				query = "SELECT * FROM categories";
				ppst = conn.prepareStatement(query);
				rs = ppst.executeQuery();
				while (rs.next()) {
					category categoryObj = new category();
					categoryObj.setCategoryID(rs.getInt("category_id"));
					categoryObj.setCategory_name(rs.getString("category_name"));
					categoryObj.setCategory_image(rs.getString("image"));
					categoryList.add(categoryObj);
				}
			}
		} catch (Exception e) {
			System.out.print(e);
		}
		
		return categoryList;
	}
	
	// Get 1 Category
	public category getCategory(int catID) {
		category categoryObj = new category();
		Connection conn = null;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
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
				query = "SELECT * FROM categories WHERE category_id = ?";
				ppst = conn.prepareStatement(query);
				ppst.setInt(1, catID);
				rs = ppst.executeQuery();

				while (rs.next()) {
					categoryObj.setCategoryID(rs.getInt("category_id"));
					categoryObj.setCategory_name(rs.getString("category_name"));
					categoryObj.setCategory_image(rs.getString("image"));
				}
				return categoryObj;
			}
		} catch (Exception e) {
			return null;
		}
		return null;
	}

	// Get Categories for Pagination (5 per page)
	public ArrayList<category> getCategories(int page) {
		ArrayList<category> categoryList = new ArrayList<category>();
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(
					"jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
			// conn =
			// DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=admin&password=@dmin1!&serverTimezone=UTC&characterEncoding=latin1");
		} catch (Exception e) {
			System.out.print(e);
		}
		try {
			if (conn == null) {
				System.out.print("Conn Error");
				conn.close();
			} else {

				query = "SELECT * FROM categories LIMIT ?,5";
				ppst = conn.prepareStatement(query);
				ppst.setInt(1, (page - 1) * 5);
				rs = ppst.executeQuery();

				while (rs.next()) {
					category categoryObj = new category();
					categoryObj.setCategoryID(rs.getInt("category_id"));
					categoryObj.setCategory_name(rs.getString("category_name"));
					categoryObj.setCategory_image(rs.getString("image"));
					categoryList.add(categoryObj);
				}
				return categoryList;
			}
		} catch (Exception e) {
			System.out.print(e);
			return null;
		}
		return null;
	}

	// Get Number of Categories
	public int getTotalCategories() {
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

				query = "SELECT COUNT(*) as total_categories FROM categories";
				st = conn.createStatement();
				rs = st.executeQuery(query);

				while (rs.next()) {// rs.next() returns true if there is a row below the current one, and moves to
									// it when called.
					return rs.getInt("total_categories");
				}
			}
		} catch (Exception e) {
			System.out.print(e);
			return 0;
		}
		return 0;
	}
	
	// Add Category
	public static int addCategory(String catName, String imageName) {
		try {
			Class.forName("com.mysql.jdbc.Driver");
			String connURL = "jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC";
			Connection conn = DriverManager.getConnection(connURL);

			String query = "INSERT INTO categories (category_name, image) VALUES (?, ?)";
			PreparedStatement pstmt = conn.prepareStatement(query);
			pstmt.setString(1, catName);
			pstmt.setString(2, imageName);
			int rs = pstmt.executeUpdate();

			conn.close();

			return rs;
		} catch (Exception e) {
			System.out.println("Error :" + e);
			return 0;
		}
	}
	
	// Update Category
	public boolean editCategory(int catID,String image,String cat_name) {
		query = "UPDATE categories SET category_name= ?, image=? WHERE category_id = ?"; 
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
			// conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=admin&password=@dmin1!&serverTimezone=UTC&characterEncoding=latin1");
		} catch (Exception e) {
			System.out.print(e);
			return false;
		}
		try {
		  ppst = conn.prepareStatement(query);
		  ppst.setString(1,cat_name);
		  ppst.setString(2,image);
		  ppst.setInt(3,catID);
		  System.out.print("Database Error1");
	      int rs = ppst.executeUpdate();
	      System.out.print("Database Error2");
	      conn.close();
	      if(rs != 1){
	    	  System.out.print("Database Error");
	    	  return false;
	      }else{
	    	  return true;
	      }
		}catch(Exception e) {
			System.out.print(e);
			System.out.print(catID);
			System.out.print(cat_name);
			System.out.print(image);
			return false;
			
		}
	}
	
	
	// Delete Category by categoryID
	public boolean deleteCategory(int CatID) {
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
				String query = "DELETE FROM categories WHERE category_id = ?";
				PreparedStatement ppst = conn.prepareStatement(query);
				ppst.setInt(1, CatID);
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
