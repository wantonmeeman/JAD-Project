package myservlets;

import java.io.File;
import java.io.IOException;
import java.util.Iterator;
import java.util.List;

import mydbaccess.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import myclasses.ProductClass;

/**
 * Servlet implementation class editDeliveryDetails
 */
@WebServlet("/editProductAdmin")
public class editProductAdmin extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	
	private static final String UPLOAD_DIRECTORY = "images";
	private static final int THRESHOLD_SIZE = 1024 * 1024 * 1;
	private static final int MAX_FILE_SIZE = 1024 * 1024 * 100;
	private static final int MAX_REQUEST_SIZE = 1024 * 1024 * 150;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public editProductAdmin() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub

		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);

		if (request.getSession().getAttribute("role").equals("admin")) {

			int productID = 0;
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

				productID = Integer.parseInt(inputArray[0]);
				name = inputArray[1];
				c_price = inputArray[2];
				r_price = inputArray[3];
				stockQuantity = inputArray[4];
				productCat = inputArray[5];
				briefDesc = inputArray[6];
				detailedDesc = inputArray[7];
				sold = "0";

				ProductClass product = ProductImgDB.getProductByName(name);

				if (product == null || product.getProductID() == productID) {
					productDB productDB = new productDB();
					boolean editProductRS = productDB.editProduct(productID, name, briefDesc, detailedDesc, c_price, r_price,
							stockQuantity, productCat);

					if (countImages > 0) {
						iter = formItems.iterator();

						while (iter.hasNext()) {
							FileItem item = (FileItem) iter.next();
							if (!item.isFormField()) {
								String fileName = new File(item.getName()).getName();

								if (!fileName.equals("") && fileName != null && fileName.length() > 0) {
									// Saves the file on disk
									String filePath = uploadPath + File.separator + fileName;
									File storeFile = new File(filePath);
									item.write(storeFile);

									System.out.println(filePath);

									int addProductImage = ProductImgDB.addProdImg(productID, fileName);
								}
							}
						}
					}
				} else {
					request.getSession().setAttribute("error", "Duplicate Product Found.");
				}

				response.sendRedirect(request.getContextPath() + "/Assignment1/admin-page.jsp?productSort="
						+ request.getParameter("productSort") + "&productFilter="
						+ request.getParameter("productFilter") + "&productSearch="
						+ request.getParameter("productSearch") + "&LowStockValue=" + lowStockRange + selectedTab);
			} catch (Exception e) {
				System.err.println("Error: " + e);
			}
		} else {
			response.sendRedirect(request.getContextPath() + "/Assignment1/loginpage.jsp");
		}

	}

}
