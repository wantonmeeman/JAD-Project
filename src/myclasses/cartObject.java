package myclasses;


public class cartObject {
	int productID;
	double productPrice;
	String productName;
	int productQuantity;
	String productImage;
	String error;
	
	public cartObject(int productID,double productPrice,String productName,int productQuantity,String productImage,	String error) {
		this.productID = productID;
		this.productPrice = productPrice;
		this.productName = productName;
		this.productQuantity = productQuantity;
		this.productImage = productImage;
		this.error = error;
	}
	public cartObject() {
		
	}
	public int getProductID() {
		return productID;
	}
	public void setProductID(int productID) {
		this.productID = productID;
	}
	public double getProductPrice() {
		return productPrice;
	}
	public void setProductPrice(double productPrice) {
		this.productPrice = productPrice;
	}
	public String getProductImage() {
		return productImage;
	}
	public void setProductImage(String productImage) {
		this.productImage = productImage;
	}
	public String getProductName() {
		return productName;
	}
	public void setProductName(String productName) {
		this.productName = productName;
	}
	public int getProductQuantity() {
		return productQuantity;
	}
	public void setProductQuantity(int productQuantity) {
		this.productQuantity = productQuantity;
	}
	public String getError() {
		return error;
	}
	public void setError(String error) {
		this.error = error;
	}
}
