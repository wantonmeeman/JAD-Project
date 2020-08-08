package myservlets;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class changeQuantity
 */
@WebServlet("/changeQuantity")
public class changeQuantity extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public changeQuantity() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		//response.getWriter().append("Served at: ").append(request.getContextPath());
		Connection conn = null;
		int dbquantity = 0;
		int[] quantityArr = ((int[])request.getSession().getAttribute("quantityArr"));
		int[] productArr = ((int[])request.getSession().getAttribute("productArr"));
		int quantity = Integer.parseInt(request.getParameter("quantity"));
		int productID = Integer.parseInt(request.getParameter("productID"));
		try{
			Class.forName("com.mysql.jdbc.Driver");
			//conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=admin&password=@dmin1!&serverTimezone=UTC&characterEncoding=latin1");
			if(conn == null){
				//response.sendRedirect("JAD-Project/WebContent/Assignment1/cart.jsp");
			  	conn.close();
			}else{
				String query = "SELECT * FROM products WHERE product_id ="+productID;
				Statement st = conn.createStatement();
				ResultSet rs = st.executeQuery(query);
				while(rs.next()){
					dbquantity = rs.getInt("stock_quantity");
				} 
				conn.close();
				if(quantity <= 0){
					response.sendRedirect("JAD-Project/WebContent/Assignment1/cart.jsp?Err=Invalid");
				}else if(dbquantity < quantity){
					response.sendRedirect("JAD-Project/WebContent/Assignment1/cart.jsp?Err=OverStk");
				}else{
					for(int i = 0;productArr.length>i;i++) {
						if(productArr[i] == productID) {
							quantityArr[i] = quantity;
						}
					}
					request.getSession().setAttribute("productID",productID);
					response.sendRedirect("JAD-Project/WebContent/Assignment1/cart.jsp");
				}
			}
		}catch(Exception e){
			
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
