package myservlets;

import java.io.IOException;

import java.util.ArrayList;

import mydbaccess.userDetailsDB;
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
		String Path = "http://localhost:8080"+request.getContextPath()+"/";
		int userID = Integer.parseInt(request.getParameter("userID"));
		userDetailsDB getDB = new userDetailsDB();
		if(getDB.deleteUser(userID)) {
			response.sendRedirect(Path+"allUsersDetails?Err=DelSuccess");
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
