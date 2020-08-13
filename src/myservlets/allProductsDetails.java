package myservlets;

import java.io.IOException;

import java.util.ArrayList;

import mydbaccess.productDB;

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
@WebServlet("/allProductsDetails")
public class allProductsDetails extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public allProductsDetails() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		productDB getDB = new productDB();
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
		int lowStockRange = 100;
		
		if(request.getParameter("lowStockRange") != null) {
			lowStockRange = Integer.valueOf(request.getParameter("lowStockRange"));
		}
		
		ArrayList<product> Tab1 = getDB.getAllProducts(request.getParameter("productSort"),request.getParameter("productFilter"),request.getParameter("productSearch"),Integer.valueOf(page1Num));
		ArrayList<category> Tab2 = getDB.getAllCategories(Integer.valueOf(page2Num));
		ArrayList<product> Tab3 = getDB.getLowProducts(lowStockRange,Integer.valueOf(page3Num));
		
		//int total_users = getDB.getTotalUsers(request.getParameter("userSearch"));
		//int total_roles = getDB.getTotalRoles();
		//int total_orders = getDB.getTotalOrders(request.getParameter("orderSort"),request.getParameter("timeSort"),request.getParameter("filterValue"),request.getParameter("filterCategory"));
	
		
		HttpSession session = request.getSession(true);//Hopefully we can change this to setAttribute
		session.setAttribute("Tab1", Tab1);
		session.setAttribute("Tab2", Tab2);
		session.setAttribute("Tab3", Tab3);

		session.setAttribute("Tab1T",getDB.getTotalProducts(request.getParameter("productSort"),request.getParameter("productFilter"),request.getParameter("productSearch")));
		session.setAttribute("Tab2T",getDB.getTotalCategories());
		session.setAttribute("Tab3T",getDB.getTotalLowProducts(lowStockRange));
		
		
		response.setContentType("text/html");
		
		response.sendRedirect("JAD-Project/WebContent/Assignment1/admin-page.jsp?productSort="+request.getParameter("productSort")+"&productFilter="+request.getParameter("productFilter")+"&productSearch="+request.getParameter("productSearch")+"&LowStockValue="+lowStockRange+selectedTab);
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
