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
@WebServlet("/editCategoryAdmin")
public class editCategoryAdmin extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public editCategoryAdmin() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		//response.getWriter().append("Served at: ").append(request.getContextPath());
		String catName = request.getParameter("catName");
		String catImageURL = request.getParameter("catImageURL");
		int catid = Integer.valueOf(request.getParameter("categoryID"));//(int)request.getSession().getAttribute("userid");
		
		CategoryDB getDB = new CategoryDB();
		boolean result = getDB.editCategory(catid,catImageURL,catName);
			      if(result == true){
			    	  response.sendRedirect("allProductsDetails?Err=EditSuccess");
				      //response.sendRedirect(request.getContextPath() +"/Assignment1/all-users.jsp?Err=Success");
				  }else{
				      response.sendRedirect("allProductsDetails?Err=DatabaseError");
				    	 //response.sendRedirect(request.getContextPath() +"/Assignment1/all-users.jsp?Err=DatabaseError");
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
