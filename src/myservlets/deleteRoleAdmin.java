package myservlets;

import java.io.IOException;
import java.util.ArrayList;

import mydbaccess.RoleDB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


/**
 * Servlet implementation class editDeliveryDetails
 */
@WebServlet("/deleteRoleAdmin")
public class deleteRoleAdmin extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public deleteRoleAdmin() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		int roleID = Integer.parseInt(request.getParameter("roleID"));
		
		RoleDB getDB = new RoleDB();
		if(getDB.deleteRole(roleID)) {
			response.sendRedirect(request.getContextPath()+"/allUsersDetails?Err=DelSuccess");
		}
		System.out.print("Error");
		
		  		  
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
