package myservlets;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class editDeliveryDetails
 */
@WebServlet("/editUserAdmin")
public class editUserAdmin extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public editUserAdmin() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String email = request.getParameter("email");
		String firstname = request.getParameter("firstname");
		String lastname = request.getParameter("lastname");
		String phonenumber = request.getParameter("phonenumber");
		String country = request.getParameter("country");
		String company = request.getParameter("company");
		String zipcode = request.getParameter("zipcode");
		String address = request.getParameter("address");
		String cardnumber = request.getParameter("cardnumber");
		String CCV = request.getParameter("CCV");
		String expirydate = request.getParameter("expirydate");
		int userid = (int)request.getSession().getAttribute("userid");
		
		Connection conn = null;
		try{
		  	Class.forName("com.mysql.jdbc.Driver");
		  	conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
		  	 //conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=admin&password=@dmin1!&serverTimezone=UTC&characterEncoding=latin1");
		 }catch(Exception e){
			 System.out.println(e);
		 }
		try {
		  	if(conn == null){
		  		conn.close();
		  	}else{//should we add null error redirecting? This involves a stupidly long if statement.
		  		  String query = "UPDATE users SET username = ?, password = ?, email = ?, firstname = ?, lastname = ?, phonenumber = ?, expirydate= ?, CCV = ?, cardnumber = ?, country = ?, zipcode = ?, address = ?, company = ? WHERE user_id = ?"; 
		  	      PreparedStatement pstmt = conn.prepareStatement(query);
		  	      pstmt.setString(1, username);
		  	      pstmt.setString(2, password);
		  	      pstmt.setString(3, email);
		  	      pstmt.setString(4, firstname);
		  	      pstmt.setString(5, lastname);
		  	      pstmt.setString(6, phonenumber);
		  	      pstmt.setString(7, expirydate);
		  	      pstmt.setString(8, CCV);
		  	      pstmt.setString(9, cardnumber);
		  	      pstmt.setString(10, country);
		  	      pstmt.setString(11, zipcode);
		  	      pstmt.setString(12, address);
		  	      pstmt.setString(13, company);
		  	      pstmt.setInt(14, userid);
		  	      
			      int rs = pstmt.executeUpdate();
			      conn.close();
			      
			      if(rs == 1){
				      response.sendRedirect(request.getContextPath() + "/allUsersDetails");
				     }else{
				    	 response.sendRedirect("JAD-Project/WebContent/Assignment1/all-users.jsp?Err=DatabaseError");
				     }
		  	}
		}catch(SQLException e) {
			System.out.println(e);
		}
	}

}
