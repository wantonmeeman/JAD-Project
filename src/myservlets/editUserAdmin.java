package myservlets;

import java.io.IOException;

import mydbaccess.*;
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
		// TODO Auto-generated method stub
		
		//response.getWriter().append("Served at: ").append(request.getContextPath());
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
		int userid = Integer.valueOf(request.getParameter("userid"));//(int)request.getSession().getAttribute("userid");
		AdminUserDB getDB = new AdminUserDB();
			
		boolean result = getDB.adminEditUser(username, password, email, firstname, lastname, phonenumber, expirydate, CCV, cardnumber, country, zipcode, address, company, userid);
			      if(result == true){
			    	  response.sendRedirect("allUsersDetails?Err=EditSuccess");
				      //response.sendRedirect(request.getContextPath() +"/Assignment1/all-users.jsp?Err=Success");
				  }else{
				    	 response.sendRedirect("allUsersDetails?Err=DatabaseError");
				    	 //response.sendRedirect(request.getContextPath() +"/Assignment1/all-users.jsp?Err=DatabaseError");
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
