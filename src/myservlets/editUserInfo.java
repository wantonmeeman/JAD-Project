package myservlets;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import mydbaccess.UserDB;

/**
 * Servlet implementation class editUserInfo
 */
@WebServlet("/editUserInfo")
public class editUserInfo extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public editUserInfo() {
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
		
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String email = request.getParameter("email");
		String firstname = request.getParameter("firstname");
		String lastname = request.getParameter("lastname");
		String phonenumber = request.getParameter("phonenumber");
		// int userid = Integer.valueOf(request.getParameter("userid"));
		int userid = (int)request.getSession().getAttribute("userid");
		UserDB getDB = new UserDB();
			
		int result = getDB.editUserInfo(username, password, email, firstname, lastname, phonenumber, userid);
	      if(result == 1){
	    	  response.sendRedirect(request.getContextPath() + "/Assignment1/profile.jsp?Err=EditSuccess");
		      //response.sendRedirect(request.getContextPath() +"/Assignment1/all-users.jsp?Err=Success");
		  }else{
			  response.sendRedirect(request.getContextPath() + "/Assignment1/profile.jsp?Err=DatabaseError");
		    	 //response.sendRedirect(request.getContextPath() +"/Assignment1/all-users.jsp?Err=DatabaseError");
		  }
	}

}
