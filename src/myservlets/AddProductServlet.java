package myservlets;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

/**
 * Servlet implementation class AddProductServlet
 */
@WebServlet("/AddProductServlet")
public class AddProductServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AddProductServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		// doGet(request, response);
		
		// Get values from form text fields
		String Error = "";
		String name = request.getParameter("name");
		String c_price = request.getParameter("c_price");
		String r_price = request.getParameter("r_price");
		String stockQuantity = request.getParameter("stockQuantity");
		String productCat = request.getParameter("productCat");
		String briefDesc = request.getParameter("briefDesc");
		String detailedDesc = request.getParameter("detailedDesc");
		String image = request.getParameter("image");
         
		double cPriceFloat = 0;
		double rPriceFloat = 0;
		
		try {
			cPriceFloat = Double.parseDouble(c_price);
		 	rPriceFloat = Double.parseDouble(r_price);
		} catch (NumberFormatException e) {
			Error = "NumberFormatError";
			response.sendRedirect("Editlisting.jsp?Err=NumberFormatError");
		}
		
        InputStream inputStream = null; // input stream of the upload file
         
        // obtains the upload file part in this multipart request
        Part filePart = request.getPart("photo");
        
        if (filePart != null) {
            // prints out some information for debugging
            System.out.println(filePart.getName());
            System.out.println(filePart.getSize());
            System.out.println(filePart.getContentType());
             
            // obtains input stream of the upload file
            inputStream = filePart.getInputStream();
        }
         
        Connection conn = null; // connection to the database
        String message = null;  // message will be sent back to client
         
        try {
            // connect to database
        	Class.forName("com.mysql.jdbc.Driver");
			String connURL = "jdbc:mysql://localhost/db1?user=root&password=alastair123&serverTimezone=UTC";
			conn = DriverManager.getConnection(connURL);
 
            // constructs SQL statement
            String sql = "INSERT INTO products(name, brief_description, detailed_description, c_price, r_price, stock_quantity, product_cat, image) VALUES(?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, name);
			pstmt.setString(2, briefDesc);
			pstmt.setString(3, detailedDesc);
			pstmt.setFloat(4, Float.parseFloat(c_price));
			pstmt.setFloat(5, Float.parseFloat(r_price));
			pstmt.setInt(6, Integer.parseInt(stockQuantity));
			pstmt.setString(7, productCat);
			// pstmt.setString(8, image);
             
            if (inputStream != null) {
                // fetches input stream of the upload file for the blob column
            	pstmt.setBlob(8, inputStream);
            }
 
            // sends the statement to the database server
            int row = pstmt.executeUpdate();
            if (row > 0) {
                message = "File uploaded and saved into database";
            }
        } catch (SQLException | ClassNotFoundException ex) {
            message = "ERROR: " + ex.getMessage();
            ex.printStackTrace();
        } finally {
            if (conn != null) {
                // closes the database connection
                try {
                    conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            // sets the message in request scope
            request.setAttribute("Message", message);
             
            // forwards to the message page
            getServletContext().getRequestDispatcher("/Message.jsp").forward(request, response);
		
        }
	}

}
