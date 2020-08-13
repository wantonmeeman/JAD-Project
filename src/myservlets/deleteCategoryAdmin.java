package myservlets;

import java.io.IOException;

import java.util.ArrayList;

import mydbaccess.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


/**
 * Servlet implementation class editDeliveryDetails
 */
@WebServlet("/deleteCategoryAdmin")
public class deleteCategoryAdmin extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public deleteCategoryAdmin() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String Path = "http://localhost:8080"+request.getContextPath()+"/";
		int catID = Integer.parseInt(request.getParameter("catID"));
		productDB getDB = new productDB();
		if(getDB.deleteCategory(catID)) {
			response.sendRedirect(Path+"allProductsDetails?Err=DelSuccess");
		}
		System.out.print("Error");
		
		  		  
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
