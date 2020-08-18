package myservlets;

import java.io.IOException;


import mydbaccess.AdminUserDB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


/**
 * Servlet implementation class editDeliveryDetails
 */
@WebServlet("/deleteUserAdmin")
public class deleteUserAdmin extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public deleteUserAdmin() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		int userID = Integer.parseInt(request.getParameter("userID"));
		AdminUserDB getDB = new AdminUserDB();
		
		if(getDB.deleteUser(userID)) {
			response.sendRedirect(request.getContextPath() + "/allUsersDetails?Err=DelSuccess");
		} else {
			System.out.print("Error");
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
