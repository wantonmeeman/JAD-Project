package myservlets;

import java.io.IOException;

import java.util.ArrayList;

import mydbaccess.CategoryDB;
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
@WebServlet("/getProductDetails")
public class getProductDetails extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public getProductDetails() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		productDB getDB = new productDB();
		CategoryDB categoryDB = new CategoryDB(); 
		
		product productDetails = getDB.getProduct(Integer.valueOf(request.getParameter("productID")));
		HttpSession session = request.getSession();
		ArrayList<category> categories = categoryDB.getAllCategories(); 
		session.setAttribute("productDetails", productDetails);
		session.setAttribute("categories", categories);
		
		// response.sendRedirect("http://localhost:12978/ST0510-JAD/JAD-Project/WebContent/Assignment1/Editlisting.jsp");
    	response.sendRedirect(request.getContextPath() +"/Assignment1/Editlisting.jsp");
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
