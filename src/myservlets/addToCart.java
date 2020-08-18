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
@WebServlet("/addToCart")
public class addToCart extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public addToCart() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		//response.getWriter().append("Served at: ").append(request.getContextPath());
		int quantity = Integer.parseInt(request.getParameter("quantity"));
		int productID = Integer.parseInt(request.getParameter("productID"));
		ArrayList<cartObject> cart = (ArrayList<cartObject>)request.getSession().getAttribute("cart");
		userCartDB getDB = new userCartDB();
		ArrayList<cartObject> newCart;
		String Error = null;
		
		if(cart == null || cart.size() < 1) {
			newCart = getDB.createCart(productID,quantity);
			Error = newCart.get(newCart.size()-1).getError();
			System.out.print("Cart Size: "+newCart.size());
			System.out.print("Servlet Error: "+Error);
			if(Error == null) {
				request.getSession().setAttribute("cart",newCart);
				// response.sendRedirect("JAD-Project/WebContent/Assignment1/cart.jsp");
				
				response.sendRedirect(request.getContextPath() + "/Assignment1/cart.jsp");
			}else{
				newCart.remove(newCart.size()-1);
				// response.sendRedirect("JAD-Project/WebContent/Assignment1/cart.jsp?Err="+Error);
				response.sendRedirect(request.getContextPath() + "/Assignment1/cart.jsp?Err="+Error);
			}
		}else{
			newCart = getDB.addToCart(cart,productID,quantity);
			Error = newCart.get(newCart.size()-1).getError();
			System.out.print("Cart Size: "+newCart.size());
			System.out.print("Servlet Error: "+Error);
			if(Error == null) {
				request.getSession().setAttribute("cart",newCart);
				//System.out.print(newCart.size());
				// response.sendRedirect("JAD-Project/WebContent/Assignment1/cart.jsp");
				response.sendRedirect(request.getContextPath() + "/Assignment1/cart.jsp");
			}else{
				newCart.remove(newCart.size()-1);
				// response.sendRedirect("JAD-Project/WebContent/Assignment1/cart.jsp?Err="+Error);
				response.sendRedirect(request.getContextPath() + "/Assignment1/cart.jsp?Err="+Error);
			}
			
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
