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
import mydbaccess.ProductDB;

/**
 * Servlet implementation class AddProductServlet
 */
@WebServlet("/add-product")
public class AddProductServlet2 extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private static final String UPLOAD_DIRECTORY = "images"; // Upload Image Directory
	private static final int THRESHOLD_SIZE = 1024 * 1024 * 1; // Size of image where image stored in memory = 1MB
	private static final int MAX_FILE_SIZE = 1024 * 1024 * 100; // Size of Maximum Image Size = 100MB
	private static final int MAX_REQUEST_SIZE = 1024 * 1024 * 150; // Size of Maximum Request Size = 150MB (include all
																	// other input of form)

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
		/*
		 * if (request.getSession().getAttribute("admin") != null) { Client client =
		 * ClientBuilder.newClient(); WebTarget target =
		 * client.target(request.getScheme() + "://" + request.getServerName() + ":" +
		 * request.getServerPort() + request.getContextPath() + "/api/categories/");
		 * Invocation.Builder invoBuilder = target.request(MediaType.APPLICATION_JSON);
		 * Response resp = invoBuilder.get();
		 * 
		 * if (resp.getStatus() == Response.Status.OK.getStatusCode()) { JSONArray
		 * categoryArr = new JSONArray(resp.readEntity(new GenericType<String>() { }));
		 * ArrayList<Category> categories = new ArrayList<Category>();
		 * 
		 * for (int i = 0; i < categoryArr.length(); i++) { JSONObject categoryObj =
		 * (JSONObject) categoryArr.get(i);
		 * 
		 * Category category = new Category(categoryObj.getInt("id"),
		 * categoryObj.getString("name"), categoryObj.getString("description"));
		 * 
		 * if (categoryObj.has("imageURL")) {
		 * category.setImageURL(categoryObj.getString("imageURL")); }
		 * 
		 * categories.add(category); }
		 * 
		 * request.setAttribute("categories", categories);
		 * 
		 * // Forward to /WEB-INF/views/categories.jsp // (Users can not access directly
		 * into JSP pages placed in WEB-INF) RequestDispatcher dispatcher =
		 * request.getServletContext()
		 * .getRequestDispatcher("/WEB-INF/views/addproduct.jsp");
		 * dispatcher.forward(request, response);
		 * 
		 * } } else { response.sendRedirect(request.getContextPath() + "/admin-login");
		 * }
		 */
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		if (request.getSession().getAttribute("role").equals("admin")) {
/*			String productName = null;
			Double productPrice = 0.0;
			int productQuantity = 0;
			String productBriefDesc = null;
			String productDetailedDesc = null;
			int categoryId = 0;
			Double productCostPrice = 0.0;*/
			
			String name = "";
			String c_price = "";
			String r_price = "";
			String stockQuantity = "";
			String productCat = "";
			String briefDesc = "";
			String detailedDesc = "";
			// String image = "";
			String sold = "";

			// configures upload settings
			DiskFileItemFactory factory = new DiskFileItemFactory(); // Manages file content either in memory or on disk
			factory.setSizeThreshold(THRESHOLD_SIZE); // Set size of image to determine if image stored in disk or
														// memory
			factory.setRepository(new File(System.getProperty("java.io.tmpdir"))); // Specify which repository image
																					// will be stored under

			ServletFileUpload upload = new ServletFileUpload(factory); // Set a real directory in file to store image,
																		// java only stores temporarily
			upload.setFileSizeMax(MAX_FILE_SIZE); // Set maximum size of a single file upload
			upload.setSizeMax(MAX_REQUEST_SIZE); // Set maximum size of the request

			// Constructs the directory path to store upload file
			String uploadPath = "";
			String[] fileArray = (getServletContext().getRealPath("")).split("\\\\"); // getServletContext().getRealPath("")
																						// gives
																						// WORKSPACE\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\PROJECTNAME
			for (int i = 0; i <= fileArray.length - 7; i++) {
				uploadPath += fileArray[i] + File.separator;
			}
			uploadPath += fileArray[fileArray.length - 1] + File.separator + "WebContent" + File.separator
					+ UPLOAD_DIRECTORY;

			// Creates the directory if it does not exist
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

/*				name = inputArray[0];
				productPrice = Double.parseDouble(inputArray[1]);
				productCostPrice = Double.parseDouble(inputArray[2]);
				categoryId = Integer.parseInt(inputArray[3]);
				productQuantity = Integer.parseInt(inputArray[4]);
				productBriefDesc = inputArray[5];
				productDetailedDesc = inputArray[6];*/
				
				
				name = inputArray[0];
				c_price = inputArray[1];
				r_price = inputArray[2];
				stockQuantity = inputArray[3];
				productCat = inputArray[4];
				briefDesc = inputArray[5];
				detailedDesc = inputArray[6];
				sold = "0";

				ProductClass product = ProductDB.getProductByName(name);

				if (product == null) {
					int productId = ProductDB.addProduct(name, briefDesc, detailedDesc, c_price, r_price, stockQuantity, productCat, sold);

					if (countImages > 0) {
						iter = formItems.iterator();

						while (iter.hasNext()) {
							FileItem item = (FileItem) iter.next();
							// Processes only fields that are not form fields
							if (!item.isFormField()) {
								String fileName = new File(item.getName()).getName();

								if (!fileName.equals("") && fileName != null && fileName.length() > 0) {
									// Saves the file on disk
									String filePath = uploadPath + File.separator + fileName;
									File storeFile = new File(filePath);
									item.write(storeFile);
									
									System.out.println(filePath);

									int addProductImage = ProductDB.addProdImg(productId, fileName);
								}
							}
						}
					}
				} else {
					request.getSession().setAttribute("error", "Duplicate Product Found.");
					response.sendRedirect(request.getContextPath() + "/admin");
				}

				response.sendRedirect(request.getContextPath() + "/admin");
			} catch (Exception e) {
				System.err.println("Error: " + e);
			}
		} else {
			response.sendRedirect(request.getContextPath() + "/admin-login");
		}
	}

}
