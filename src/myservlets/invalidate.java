package myservlets;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class invalidate
 */
@WebServlet("/invalidate")
public class invalidate extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public invalidate() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		//response.getWriter().append("Served at: ").append(request.getContextPath());
		String redirect = request.getParameter("rd");
		//response.getWriter().append(redirect);
		
		request.getSession().removeAttribute("productArr");
		request.getSession().removeAttribute("quantityArr");
		if(redirect.equals("index")){
			request.getSession().removeAttribute("userid");
			request.getSession().removeAttribute("role");
			response.sendRedirect("JAD-Project/WebContent/Assignment1/index.jsp");
		}else if(redirect.equals("cart")){
			response.sendRedirect("JAD-Project/WebContent/Assignment1/cart.jsp");
		}
	}

	/**e	
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
