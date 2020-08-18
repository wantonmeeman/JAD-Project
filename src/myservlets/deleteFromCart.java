package myservlets;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import myclasses.cartObject;
import mydbaccess.userCartDB;

import java.sql.*;
import java.util.ArrayList;
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
		int productID = Integer.parseInt(request.getParameter("productID"));
		ArrayList<cartObject> cart = (ArrayList<cartObject>)request.getSession().getAttribute("cart");
		userCartDB getDB = new userCartDB();
		ArrayList<cartObject> newCart = getDB.deleteObject(cart,productID);//No error Handling for this one
		request.getSession().setAttribute("cart",newCart);
		// response.sendRedirect("JAD-Project/WebContent/Assignment1/cart.jsp");
		response.sendRedirect(request.getContextPath() +"/Assignment1/cart.jsp");
		

	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
