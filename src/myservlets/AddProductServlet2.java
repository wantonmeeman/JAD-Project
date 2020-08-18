package myservlets;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.json.JSONArray;
import org.json.JSONObject;

import myclasses.ProductClass;
import mydbaccess.ProductImgDB;

/**
 * Servlet implementation class AddProductServlet
 */
@WebServlet("/add-product")
public class AddProductServlet2 extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private static final String UPLOAD_DIRECTORY = "images";
	private static final int THRESHOLD_SIZE = 1024 * 1024 * 1;
	private static final int MAX_FILE_SIZE = 1024 * 1024 * 100;
	private static final int MAX_REQUEST_SIZE = 1024 * 1024 * 150;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public AddProductServlet2() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		if (request.getSession().getAttribute("role").equals("admin")) {
			
			String name = "";
			String c_price = "";
			String r_price = "";
			String stockQuantity = "";
			String productCat = "";
			String briefDesc = "";
			String detailedDesc = "";
			// String image = "";
			String sold = "";
			String selectedTab = "&tab=1";
			int lowStockRange = 100;

			// Upload Settings
			DiskFileItemFactory factory = new DiskFileItemFactory();
			factory.setSizeThreshold(THRESHOLD_SIZE);
			
			factory.setRepository(new File(System.getProperty("java.io.tmpdir")));

			ServletFileUpload upload = new ServletFileUpload(factory);
			upload.setFileSizeMax(MAX_FILE_SIZE);
			upload.setSizeMax(MAX_REQUEST_SIZE);


			String uploadPath = "";
			String[] fileArray = (getServletContext().getRealPath("")).split("\\\\");
			for (int i = 0; i <= fileArray.length - 7; i++) {
				uploadPath += fileArray[i] + File.separator;
			}
			uploadPath += fileArray[fileArray.length - 1] + File.separator + "WebContent" + File.separator
					+ UPLOAD_DIRECTORY;


			File uploadDir = new File(uploadPath);
			if (!uploadDir.exists()) {
				uploadDir.mkdir();
			}

			try {
				List formItems = upload.parseRequest((HttpServletRequest) request);
				Iterator<FileItem> iter = formItems.iterator();
				String[] inputArray = new String[8];
				int count = 0;
				int countImages = 0;

				while (iter.hasNext()) {
					FileItem item = iter.next();
					if (item.isFormField()) {
						inputArray[count] = item.getString();
						count++;
					} else {
						String imageName = new File(item.getName()).getName();
						if (!imageName.equals("") && imageName != null && imageName.length() > 0) {
							countImages++;
						}
					}
				}
				
				name = inputArray[0];
				c_price = inputArray[1];
				r_price = inputArray[2];
				stockQuantity = inputArray[3];
				productCat = inputArray[4];
				briefDesc = inputArray[5];
				detailedDesc = inputArray[6];
				sold = "0";

				ProductClass product = ProductImgDB.getProductByName(name);

				if (product == null) {
					int productId = ProductImgDB.addProduct(name, briefDesc, detailedDesc, c_price, r_price, stockQuantity, productCat, sold);

					if (countImages > 0) {
						iter = formItems.iterator();

						while (iter.hasNext()) {
							FileItem item = (FileItem) iter.next();
							if (!item.isFormField()) {
								String fileName = new File(item.getName()).getName();

								if (!fileName.equals("") && fileName != null && fileName.length() > 0) {
									String filePath = uploadPath + File.separator + fileName;
									File storeFile = new File(filePath);
									item.write(storeFile);
									
									System.out.println(filePath);

									int addProductImage = ProductImgDB.addProdImg(productId, fileName);
								}
							}
						}
					}
				} else {
					request.getSession().setAttribute("error", "Duplicate Product Found.");
					// response.sendRedirect(request.getContextPath() + "/Assignment1/admin-page.jsp");
					response.sendRedirect(request.getContextPath() +"/Assignment1/admin-page.jsp?productSort="+request.getParameter("productSort")+"&productFilter="+request.getParameter("productFilter")+"&productSearch="+request.getParameter("productSearch")+"&LowStockValue="+lowStockRange+selectedTab);
				}

				// response.sendRedirect(request.getContextPath() + "/Assignment1/admin-page.jsp");
				response.sendRedirect(request.getContextPath() +"/Assignment1/admin-page.jsp?productSort="+request.getParameter("productSort")+"&productFilter="+request.getParameter("productFilter")+"&productSearch="+request.getParameter("productSearch")+"&LowStockValue="+lowStockRange+selectedTab);
			} catch (Exception e) {
				System.err.println("Error: " + e);
			}
		} else {
			response.sendRedirect(request.getContextPath() + "/Assignment1/loginpage.jsp");
		}
	}

}
