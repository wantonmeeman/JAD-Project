package myservlets;

import java.io.IOException;
import java.util.ArrayList;

import mydbaccess.RoleDB;
import mydbaccess.UserDB;
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
		UserDB userDB = new UserDB();
		RoleDB roleDB = new RoleDB();
		
		String selectedTab = "";
		String Tab = request.getParameter("tab");
		String error = request.getParameter("Err");
		String page1Num = request.getParameter("page1");
		
		if(Tab == null) {
			Tab = "";
		}else {
			selectedTab = "&tab="+Tab;
		}
		
		if(page1Num == null) {//Saves Memory of Page for Pagination 
			page1Num = "1";
		}else if(page1Num != "1" || Tab.equals("1")) {
			selectedTab = "&tab=1";
		}
		
		String page2Num = request.getParameter("page2");
		
		if(page2Num == null) {//Saves Memory of Page for Pagination 
			page2Num = "1";
		}else if(page2Num != "1" || Tab.equals("2")) {
			selectedTab = "&tab=2";
		}
		
		String page3Num = request.getParameter("page3");
		
		if(page3Num == null) {//Saves Memory of Page for Pagination 
			page3Num = "1";
		}else if(page3Num != "1") {
			selectedTab = "&tab=3";
		}
		
		
		String page4Num = request.getParameter("page4");
		
		if(page4Num == null) {//Saves Memory of Page for Pagination 
			page4Num = "1";
		}else if(page4Num != "1" || Tab.equals("4")) {
			selectedTab = "&tab=4";
		}
		//Tab1
		ArrayList<user> Tab1 = userDB.getAllUser(request.getParameter("userSort"),request.getParameter("userSearch"),request.getParameter("userCategory"),request.getParameter("roleFilter"),Integer.valueOf(page1Num));
		//Tab2
		ArrayList<role> Tab2 = roleDB.getRoles(Integer.valueOf(page2Num));
		//Tab3
		ArrayList<order> Tab3 = getDB.getAllOrders(Integer.valueOf(page3Num),request.getParameter("orderSort"),request.getParameter("timeSort"),request.getParameter("filterValue"),request.getParameter("filterCategory"));
		
		//Getting the totals
		int total_users = userDB.getTotalUsers(request.getParameter("userSearch"),request.getParameter("userCategory"),request.getParameter("roleFilter"));
		int total_roles = roleDB.getTotalRoles();
		int total_orders = getDB.getTotalOrders(request.getParameter("orderSort"),request.getParameter("timeSort"),request.getParameter("filterValue"),request.getParameter("filterCategory"));
		
		
		HttpSession session = request.getSession(); // Hopefully we can change this to setAttribute
		session.setAttribute("Tab1", Tab1);
		session.setAttribute("Tab2", Tab2);
		session.setAttribute("Tab3", Tab3);
		//session.setAttribute("Tab4", Tab4);
		
		session.setAttribute("Tab1T", total_users);
		session.setAttribute("Tab2T", total_roles);
		session.setAttribute("Tab3T", total_orders);
		//session.setAttribute("Tab4T", total_users_max);
		//System.out.print("\n"+Tab4.size());
		response.setContentType("text/html");
		
		
		//request.getRequestDispatcher("JAD-Project/WebContent/Assignment1/all-users.jsp?orderSort="+request.getParameter("orderSort")+"&timeSort="+request.getParameter("timeSort")+"&filterValue="+request.getParameter("filterValue")+"&filterCategory="+request.getParameter("filterCategory")).forward(request, response);
		// response.sendRedirect("http://localhost:12978/ST0510-JAD/JAD-Project/WebContent/Assignment1/all-users.jsp?Err="+error+"&roleFilter="+request.getParameter("roleFilter")+"&userSearch="+request.getParameter("userSearch")+"&userCategory="+request.getParameter("userCategory")+"&orderSort="+request.getParameter("orderSort")+"&timeSort="+request.getParameter("timeSort")+"&filterValue="+request.getParameter("filterValue")+"&filterCategory="+request.getParameter("filterCategory")+selectedTab);
		response.sendRedirect(request.getContextPath() +"/Assignment1/all-users.jsp?orderSort="+request.getParameter("orderSort")+"&timeSort="+request.getParameter("timeSort")+"&filterValue="+request.getParameter("filterValue")+"&filterCategory="+request.getParameter("filterCategory")+selectedTab);
		
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
