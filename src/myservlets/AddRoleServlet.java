package myservlets;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import mydbaccess.RoleDB;
import mydbaccess.UserDB;

/**
 * Servlet implementation class AddRoleServlet
 */
@WebServlet("/AddRoleServlet")
public class AddRoleServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AddRoleServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		// response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
		
		String roleName = request.getParameter("dbRole");

		RoleDB getDB = new RoleDB();
			
		int result = getDB.addRole(roleName);
	      if(result == 1){
	    	  response.sendRedirect(request.getContextPath() + "/Assignment1/all-users.jsp?Err=EditSuccess");
		      //response.sendRedirect(request.getContextPath() +"/Assignment1/all-users.jsp?Err=Success");
		  }else{
			  response.sendRedirect(request.getContextPath() + "/Assignment1/all-users.jsp?Err=DatabaseError");
		    	 //response.sendRedirect(request.getContextPath() +"/Assignment1/all-users.jsp?Err=DatabaseError");
		  }
	}

}
