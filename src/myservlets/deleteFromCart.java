package myservlets;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;
/**
 * Servlet implementation class VerifyUserServlet
 */
@WebServlet("/deleteFromCart")
public class deleteFromCart extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public deleteFromCart() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		//response.getWriter().append("Served at: ").append(request.getContextPath());
		int[] productArr = (int[])request.getSession().getAttribute("productArr");
		int[] quantityArr = (int[])request.getSession().getAttribute("quantityArr");
		int product = Integer.parseInt(request.getParameter("product"));
		//for(int x = 0;x < productArr.length;x++) {
			//response.getWriter().append(Integer.toString(productArr[x]));
		//}
		//response.getWriter().append(",");
		
		response.getWriter().append(Integer.toString(quantityArr[product]));
		for(int x = 0;productArr.length > x;x++) {
			if(productArr[x] == product) {
				productArr[x] = 0;
				quantityArr[x] = 0;
			}
		}
		//for(int x = 0;x < productArr.length;x++) {
			//response.getWriter().append(Integer.toString(productArr[x]));
		//}
		//response.getWriter().append("Served at: ");
		response.sendRedirect("JAD-Project/WebContent/Assignment1/cart.jsp");

	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
