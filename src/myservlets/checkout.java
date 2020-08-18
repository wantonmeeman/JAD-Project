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
@WebServlet("/checkout")
public class checkout extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public checkout() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		//response.getWriter().append("Served at: ").append(request.getContextPath());
		int userid = (int)request.getSession().getAttribute("userid");
		String company = request.getParameter("company");
		String address = request.getParameter("address");
		String country = request.getParameter("country");
		String zipcode = request.getParameter("zipcode");
		String cardnumber = request.getParameter("cardnumber");
		String CCV = request.getParameter("CCV");
		String expirydate = request.getParameter("expirydate");
		String notes = request.getParameter("notes");
		
		
		ArrayList<cartObject> cart = (ArrayList<cartObject>)request.getSession().getAttribute("cart");
		userCartDB getDB = new userCartDB();
		
		boolean checkoutStatus = getDB.checkout(cart, userid, company, address, country, zipcode, cardnumber, CCV, expirydate, notes);
		
		if(checkoutStatus) {
			request.getSession().removeAttribute("cart");
			//response.sendRedirect(request.getContextPath() +"/Assignment1/thankyou.jsp");
			// response.sendRedirect("http://localhost:12978/ST0510-JAD/JAD-Project/WebContent/Assignment1/thankyou.jsp");
			response.sendRedirect(request.getContextPath() +"/Assignment1/thankyou.jsp");
		}else {
			System.out.print("Error");
			// response.sendRedirect("http://localhost:12978/ST0510-JAD/JAD-Project/WebContent/Assignment1/errorThankYou.jsp");
			response.sendRedirect(request.getContextPath() +"/Assignment1/errorThankYou.jsp");
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
