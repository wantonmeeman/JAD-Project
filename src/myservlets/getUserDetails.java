package myservlets;

import java.io.IOException;
import java.util.ArrayList;

import mydbaccess.userDetailsDB;
import mydbaccess.userOrderDB;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import myclasses.*;

/**
 * Servlet implementation class allUsersDetails
 */
@WebServlet("/getUserDetails")
public class getUserDetails extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public getUserDetails() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		userDetailsDB getDB = new userDetailsDB();
		
		HttpSession session = request.getSession();
		if(request.getParameter("rd") == null) {
			user userDetails = getDB.getUserDetails((int)session.getAttribute("userid"));
			session.setAttribute("userDetails", userDetails);
			response.sendRedirect("http://localhost:12978/ST0510-JAD/JAD-Project/WebContent/Assignment1/checkout.jsp");
			//response.sendRedirect(request.getContextPath() +"/Assignment1/checkout.jsp");
		}else {
			user userDetails = getDB.getUserDetails(Integer.valueOf(request.getParameter("userID")));
			ArrayList<role> allRoles = getDB.getAllRoles();
			session.setAttribute("roles", allRoles);
			session.setAttribute("userDetails", userDetails);
			response.sendRedirect("http://localhost:12978/ST0510-JAD/JAD-Project/WebContent/Assignment1/EditUser.jsp");
			//response.sendRedirect(request.getContextPath() +"/Assignment1/EditUser.jsp");
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
