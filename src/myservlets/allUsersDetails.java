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
		String selectedTab = "";
		String Tab = request.getParameter("tab");
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
		
		ArrayList<user> Tab1 = getDB.getAllUser(request.getParameter("userSearch"),Integer.valueOf(page1Num));
		ArrayList<role> Tab2 = getDB.getAllRoles(Integer.valueOf(page2Num));
		ArrayList<order> Tab3 = getDB.getAllOrders(Integer.valueOf(page3Num),request.getParameter("orderSort"),request.getParameter("timeSort"),request.getParameter("filterValue"),request.getParameter("filterCategory"));
		//String Tab3 = getDB.getAllOrders(Integer.valueOf(page3Num),request.getParameter("orderSort"),request.getParameter("timeSort"),request.getParameter("filterValue"),request.getParameter("filterCategory"));
		ArrayList<user> Tab4 = getDB.getMaxUser(request.getParameter("userSearch4"),Integer.valueOf(page4Num));
		int total_users = getDB.getTotalUsers(request.getParameter("userSearch"));
		int total_roles = getDB.getTotalRoles();
		int total_orders = getDB.getTotalOrders(request.getParameter("orderSort"),request.getParameter("timeSort"),request.getParameter("filterValue"),request.getParameter("filterCategory"));
		int total_users_max = getDB.getTotalUsersMax(request.getParameter("userSearch4"));
		
//		System.out.print("\n"+"\n"+total_users_max);
//		System.out.print("\n"+"\n"+Tab4.size());
		
		HttpSession session = request.getSession(true);//Hopefully we can change this to setAttribute
		session.setAttribute("Tab1", Tab1);
		session.setAttribute("Tab2", Tab2);
		session.setAttribute("Tab3", Tab3);
		session.setAttribute("Tab4", Tab4);
		
		session.setAttribute("total_users", total_users);
		session.setAttribute("total_roles", total_roles);
		session.setAttribute("total_orders", total_orders);
		session.setAttribute("total_users_max", total_users_max);
		//System.out.print("\n"+Tab4.size());
		response.setContentType("text/html");
		//
		//request.getRequestDispatcher("JAD-Project/WebContent/Assignment1/all-users.jsp?orderSort="+request.getParameter("orderSort")+"&timeSort="+request.getParameter("timeSort")+"&filterValue="+request.getParameter("filterValue")+"&filterCategory="+request.getParameter("filterCategory")).forward(request, response);
		//IDK what to change this to soooo
		response.sendRedirect(request.getContextPath() + "/Assignment1/all-users.jsp?orderSort="+request.getParameter("orderSort")+"&timeSort="+request.getParameter("timeSort")+"&filterValue="+request.getParameter("filterValue")+"&filterCategory="+request.getParameter("filterCategory")+selectedTab);
		
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
