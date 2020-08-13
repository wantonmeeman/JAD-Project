package myservlets;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.client.*;
import javax.ws.rs.core.*;

import org.json.JSONObject;

/**
 * Servlet implementation class CartServlet
 */
@WebServlet("/CartServlet")
public class CartServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CartServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		// response.getWriter().append("Served at: ").append(request.getContextPath());
		
		Client client = ClientBuilder.newClient();
        WebTarget target = client.target("https://api.exchangeratesapi.io/").path("latest").queryParam("base",
                "SGD");
        Invocation.Builder invoBuilder = target.request(MediaType.APPLICATION_JSON);
        Response resp = invoBuilder.get();

        if (resp.getStatus() == Response.Status.OK.getStatusCode()) {
            JSONObject ratesObj = (JSONObject) (new JSONObject(resp.readEntity(new GenericType<String>() {
            }))).get("rates");

            request.setAttribute("rates", ratesObj);

            if (request.getParameter("currency") != null) {
                request.setAttribute("rate", ratesObj.getDouble(request.getParameter("currency")));
                request.setAttribute("currency", request.getParameter("currency"));
            }
            
            response.sendRedirect(request.getContextPath() + "/Assignment1/cart.jsp");
        }
        
		/*
		 * dropdown displaying all the currency <select onchange="currenyChange()">
		 * <option value="currency (e.g SGD)">SGD</option>
		 * 
		 * currencyChange() { get the value of the currency select
		 * response.sendRedirect(url + param (curreny=val)); }
		 * 
		 * total request.getAttribute("rate") * amount they pay
		 * request.getAttribute("currency") = 1 * 100 SGD = 100SGD
		 */
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
