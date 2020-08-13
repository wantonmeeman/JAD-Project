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
@WebServlet("/editDeliveryDetails")
public class editDeliveryDetails extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public editDeliveryDetails() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		//response.getWriter().append("Served at: ").append(request.getContextPath());
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
		  	//conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
		  	 conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=admin&password=@dmin1!&serverTimezone=UTC&characterEncoding=latin1");
		 }catch(Exception e){
			 
		 }
		try {
		  	if(conn == null){
		  		conn.close();
		  	}else{
		  		  String query = "UPDATE users SET expirydate='"+expirydate+"',CCV="+CCV+",cardnumber = "+cardnumber+",country = '"+country+"',  zipcode = '"+zipcode+"', address = '"+address+"', company = '"+company+"' WHERE user_id = "+userid; 
		  	      Statement st = conn.createStatement();
			      int rs = st.executeUpdate(query);
			      conn.close();
			      if(rs == 1){
				      response.sendRedirect("JAD-Project/WebContent/Assignment1/profile.jsp?Err=Success");
				     }else{
				    	 response.sendRedirect("JAD-Project/WebContent/Assignment1/profile.jsp?Err=DatabaseError");
				     }
		  	}
		}catch(SQLException e) {
			
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
