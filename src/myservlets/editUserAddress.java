package myservlets;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import mydbaccess.UserDB;

/**
 * Servlet implementation class editUserAddress
 */
@WebServlet("/editUserAddress")
public class editUserAddress extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public editUserAddress() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
		
		String address = request.getParameter("address");
		String company = request.getParameter("company");
		String country = request.getParameter("country");
		String zipcode = request.getParameter("zipcode");
		String cardnumber = request.getParameter("cardnumber");
		String CCV = request.getParameter("CCV");
		String expirydate = request.getParameter("expirydate");
		// int userid = Integer.valueOf(request.getParameter("userid"));
		
		int userid = (int)request.getSession().getAttribute("userid");
		
		UserDB getDB = new UserDB();
			
		int result = getDB.editUserBilling(address, company, country, zipcode, cardnumber, CCV, expirydate, userid);
			      if(result == 1){
			    	  response.sendRedirect(request.getContextPath() + "/Assignment1/profile.jsp?Err=EditSuccess");
				      // response.sendRedirect(request.getContextPath() +"/Assignment1/all-users.jsp?Err=Success");
				  }else{
					  response.sendRedirect(request.getContextPath() + "/Assignment1/profile.jsp?Err=DatabaseSuccess");
					  // response.sendRedirect(request.getContextPath() +"/Assignment1/all-users.jsp?Err=DatabaseError");
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
