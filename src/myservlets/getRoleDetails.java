package myservlets;

import java.io.IOException;
import java.util.ArrayList;

import mydbaccess.RoleDB;
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
@WebServlet("/getRoleDetails")
public class getRoleDetails extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public getRoleDetails() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		RoleDB getDB = new RoleDB();
		
		role roleDetails = getDB.getRoleDetails((Integer.valueOf(request.getParameter("roleID"))));
		HttpSession session = request.getSession();
		session.setAttribute("roleDetails", roleDetails);
		
		response.sendRedirect(request.getContextPath() + "/Assignment1/edit-role.jsp");
		
    	 
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
