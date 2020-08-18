package myservlets;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import mydbaccess.CategoryDB;
import mydbaccess.RoleDB;

/**
 * Servlet implementation class AddCategoryServlet
 */
@WebServlet("/AddCategoryServlet")
public class AddCategoryServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AddCategoryServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);

		String catName = request.getParameter("catName");
		String imageName = request.getParameter("catImageURL");

		CategoryDB getDB = new CategoryDB();
			
		int result = getDB.addCategory(catName, imageName);
	      if(result == 1){
	    	  response.sendRedirect(request.getContextPath() + "/Assignment1/index.jsp");
		      // response.sendRedirect(request.getContextPath() +"/Assignment1/all-users.jsp?Err=Success");
		  }else{
			  response.sendRedirect(request.getContextPath() + "/Assignment1/admin-page.jsp?Err=DatabaseError");
			  // response.sendRedirect(request.getContextPath() +"/Assignment1/all-users.jsp?Err=DatabaseError");
		  }
	}

}
