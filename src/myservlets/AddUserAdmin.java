package myservlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class AddUserAdmin
 */
@WebServlet("/addUserAdmin")
public class AddUserAdmin extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AddUserAdmin() {
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
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String email = request.getParameter("email");
		String role = request.getParameter("userrole");
		String firstname = request.getParameter("firstname");
		String lastname = request.getParameter("lastname");
		String phonenumber = request.getParameter("phonenumber");
		
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
		  		  String query = "INSERT INTO users (username, password, email, role, firstname, lastname, phonenumber) VALUES (?, ?, ?, ?, ?, ?, ?);"; 
		  	      PreparedStatement pstmt = conn.prepareStatement(query);
		  	      pstmt.setString(1, username);
		  	      pstmt.setString(2, password);
		  	      pstmt.setString(3, email);
		  	      pstmt.setString(4, role);
		  	      pstmt.setString(5, firstname);
		  	      pstmt.setString(6, lastname);
		  	      pstmt.setString(7, phonenumber);
		  	      
			      int rs = pstmt.executeUpdate();
			      conn.close();
			      
			      if(rs == 1){
				      response.sendRedirect(request.getContextPath() + "/allUsersDetails");
				     }else{
				    	 response.sendRedirect(request.getContextPath() + "/Assignment1/all-users.jsp?Err=DatabaseError");
				     }
		  	}
		}catch(SQLException e) {
			System.out.println(e);
		}
	}

}
