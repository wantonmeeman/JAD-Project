package myservlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import mydbaccess.AdminUserDB;
import mydbaccess.UserDB;

/**
 * Servlet implementation class AddUserAdmin
 */
@WebServlet("/addUserAdmin")
public class AddUserAdmin extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public AddUserAdmin() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.sendRedirect(request.getContextPath() + "/Assignment1/adduser.jsp");
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String email = request.getParameter("email");
		String role = request.getParameter("userrole");
		String firstname = request.getParameter("firstname");
		String lastname = request.getParameter("lastname");
		String phonenumber = request.getParameter("phonenumber");

		int addUserRS = AdminUserDB.adminAddUser(username, password, email, role, firstname, lastname, phonenumber);

		if (addUserRS == 1) {
			response.sendRedirect(request.getContextPath() + "/allUsersDetails");
		} else {
			response.sendRedirect(request.getContextPath() + "/Assignment1/all-users.jsp?Err=DatabaseError");
		}
	}

}
