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
@WebServlet("/viewOrders")
public class viewOrders extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public viewOrders() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		userOrderDB getDB = new userOrderDB();
		
		String page = request.getParameter("page");
		//System.out.print((int)request.getSession().getAttribute("userid"));
		
		if(page == null) {
			page = "1";
		}
		
		HttpSession session = request.getSession();
		session.setAttribute("Orders", getDB.getOrderHistory(((int)session.getAttribute("userid")),Integer.valueOf(page)));
		
		session.setAttribute("OrdersT", getDB.getOrderHistoryTotal((int)session.getAttribute("userid")));
		
		//System.out.print("\nOrders: "+((ArrayList<order>)request.getSession().getAttribute("Orders")).size());
		response.setContentType("text/html");
		
		response.sendRedirect("http://localhost:12978/ST0510-JAD/JAD-Project/WebContent/Assignment1/view-order.jsp");
		//response.sendRedirect(request.getContextPath() +"/Assignment1/view-order.jsp");
		
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
