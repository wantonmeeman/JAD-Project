package myclasses;

public class order {
	private String orderUsername;
	private String orderPhoneNumber;
	private String orderAddress;
	private String orderCountry;
	private String orderProduct;
	private String orderEmail;
	private int orderUserID;
	private int orderProductID;
	private String orderCompany;
	private String orderQuantity;
	private double orderTotal;
	private String orderNotes;
	private String orderCCV;
	private String orderZipCode;
	private String orderCardNumber;
	private String orderImage;
	private String orderDate;
	private String orderExpiryDate;
	private int totalOrders;
	public order(String orderUsername,String orders,String orderPhoneNumber,String orderAddress,String orderCountry,String orderProduct,String orderEmail,int orderUserID,int orderProductID,String orderCompany,String orderQuantity,double orderTotal,String orderNotes,String orderCCV,String orderZipCode,String orderCardNumber,String orderImage,String orderDate,String orderExpiryDate,int totalOrders) {
		this.orderUsername = orderUsername;
		this.orderPhoneNumber = orderPhoneNumber;
		this.orderAddress = orderAddress;
		this.orderCountry = orderCountry;
		this.orderProduct = orderProduct;
		this.orderEmail = orderEmail;
		this.orderUserID = orderUserID;
		this.orderProductID = orderProductID;
		this.orderCompany = orderCompany;
		this.orderQuantity = orderQuantity;
		this.orderTotal = orderTotal;
		this.orderNotes = orderNotes;
		this.orderCCV = orderCCV;
		this.orderZipCode = orderZipCode;
		this.orderCardNumber = orderCardNumber;
		this.orderImage = orderImage;
		this.orderDate = orderDate;
		this.orderExpiryDate = orderExpiryDate;
	}
	public order() {
		
	}
	public String getOrderUsername() {
		return orderUsername;
	}
	public void setOrderUsername(String orderUsername) {
		this.orderUsername = orderUsername;
	}
	public String getOrderPhoneNumber() {
		return orderPhoneNumber;
	}
	public void setOrderPhoneNumber(String orderPhoneNumber) {
		this.orderPhoneNumber = orderPhoneNumber;
	}
	public String getOrderAddress() {
		return orderAddress;
	}
	public void setOrderAddress(String orderAddress) {
		this.orderAddress = orderAddress;
	}
	public String getOrderCountry() {
		return orderCountry;
	}
	public void setOrderCountry(String orderCountry) {
		this.orderCountry = orderCountry;
	}
	public String getOrderProduct() {
		return orderProduct;
	}
	public void setOrderProduct(String orderProduct) {
		this.orderProduct = orderProduct;
	}
	public String getOrderEmail() {
		return orderEmail;
	}
	public void setOrderEmail(String orderEmail) {
		this.orderEmail = orderEmail;
	}
	public int getOrderUserID() {
		return orderUserID;
	}
	public void setOrderUserID(int orderUserID) {
		this.orderUserID = orderUserID;
	}
	public int getOrderProductID() {
		return orderProductID;
	}
	public void setOrderProductID(int orderProductID) {
		this.orderProductID = orderProductID;
	}
	public String getOrderCompany() {
		return orderCompany;
	}
	public void setOrderCompany(String orderCompany) {
		this.orderCompany = orderCompany;
	}
	public String getOrderQuantity() {
		return orderQuantity;
	}
	public void setOrderQuantity(String orderQuantity) {
		this.orderQuantity = orderQuantity;
	}
	public double getOrderTotal() {
		return orderTotal;
	}
	public void setOrderTotal(double orderTotal) {
		this.orderTotal = orderTotal;
	}
	public String getOrderNotes() {
		return orderNotes;
	}
	public void setOrderNotes(String orderNotes) {
		this.orderNotes = orderNotes;
	}
	public String getOrderCCV() {
		return orderCCV;
	}
	public void setOrderCCV(String orderCCV) {
		this.orderCCV = orderCCV;
	}
	public String getOrderZipCode() {
		return orderZipCode;
	}
	public void setOrderZipCode(String orderZipCode) {
		this.orderZipCode = orderZipCode;
	}
	public String getOrderCardNumber() {
		return orderCardNumber;
	}
	public void setOrderCardNumber(String orderCardNumber) {
		this.orderCardNumber = orderCardNumber;
	}
	public String getOrderImage() {
		return orderImage;
	}
	public void setOrderImage(String orderImage) {
		this.orderImage = orderImage;
	}
	public String getOrderDate() {
		return orderDate;
	}
	public void setOrderDate(String orderDate) {
		this.orderDate = orderDate;
	}
	public String getOrderExpiryDate() {
		return orderExpiryDate;
	}
	public void setOrderExpiryDate(String orderExpiryDate) {
		this.orderExpiryDate = orderExpiryDate;
	}
	public int getTotalOrders() {
		return totalOrders;
	}
	public void setTotalOrders(int totalOrders) {
		this.totalOrders = totalOrders;
	}
	
}
