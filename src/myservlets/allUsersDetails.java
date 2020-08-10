package myservlets;

import java.io.IOException;
import java.util.ArrayList;

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
@WebServlet("/allUsersDetails")
public class allUsersDetails extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public allUsersDetails() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		userOrderDB getDB = new userOrderDB();
		ArrayList<user> Tab1 = getDB.getAllUser(request.getParameter("userSearch"));
		ArrayList<role> Tab2 = getDB.getAllRoles();
		ArrayList<order> Tab3 = getDB.getAllOrders(request.getParameter("orderSort"),request.getParameter("timeSort"),request.getParameter("filterValue"),request.getParameter("filterCategory"));
		ArrayList<user> Tab4 = getDB.getMaxUser(request.getParameter("userSearch4"));
		
		HttpSession session = request.getSession(true);
		session.setAttribute("Tab1", Tab1);
		session.setAttribute("Tab2", Tab2);
		session.setAttribute("Tab3", Tab3);
		session.setAttribute("Tab4", Tab4);
		
		response.setContentType("text/html");
		//request.getRequestDispatcher("JAD-Project/WebContent/Assignment1/all-users.jsp").forward(request, response);
		response.sendRedirect(request.getContextPath() + "/Assignment1/all-users.jsp?orderSort="+request.getParameter("orderSort")+"&timeSort="+request.getParameter("timeSort")+"&filterCategory="+request.getParameter("filterCategory"));
		
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
