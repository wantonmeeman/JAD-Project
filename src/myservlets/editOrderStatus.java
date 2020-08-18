package myservlets;

import java.io.IOException;

import mydbaccess.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class editDeliveryDetails
 */
@WebServlet("/editOrderStatus")
public class editOrderStatus extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public editOrderStatus() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		//response.getWriter().append("Served at: ").append(request.getContextPath());
		String action = request.getParameter("action");
		int orderid = Integer.valueOf(request.getParameter("orderid"));
		userOrderDB getDB = new userOrderDB();
		boolean result = getDB.editOrderStatus(orderid, action);
		if(result) {
			response.sendRedirect("allUsersDetails?Err=EditSuccess");
		}else {
			response.sendRedirect("allUsersDetails?Err=DatabaseError");
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
