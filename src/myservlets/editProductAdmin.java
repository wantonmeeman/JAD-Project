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
@WebServlet("/editProductAdmin")
public class editProductAdmin extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public editProductAdmin() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		//response.getWriter().append("Served at: ").append(request.getContextPath());
		String name = request.getParameter("name");
		String c_price = request.getParameter("c_price");
		String r_price = request.getParameter("r_price");
		int stockQuantity = Integer.valueOf(request.getParameter("stockQuantity"));
		String productCat = request.getParameter("productCat");
		String briefDesc = request.getParameter("briefDesc");
		String detailedDesc = request.getParameter("detailedDesc");
		String image = request.getParameter("image");
		int productid = Integer.valueOf(request.getParameter("productID"));//(int)request.getSession().getAttribute("userid");
		System.out.print(productid);
		productDB getDB = new productDB();
		boolean result = getDB.editProduct(productid,name,c_price,r_price,stockQuantity,productCat,briefDesc,detailedDesc,image);
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
