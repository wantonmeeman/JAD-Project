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
@WebServlet("/editRoleAdmin")
public class editRoleAdmin extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public editRoleAdmin() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		//response.getWriter().append("Served at: ").append(request.getContextPath());
		String roleName = request.getParameter("roleName");
		int roleID = Integer.valueOf(request.getParameter("roleID"));//(int)request.getSession().getAttribute("userid");
		RoleDB getDB = new RoleDB();
			
		boolean result = getDB.editRoleDetails(roleName,roleID);
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
