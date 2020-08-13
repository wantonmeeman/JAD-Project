package myclasses;


public class product {
	int productID;
	String productName;
	String productBrief_Description ;
	String productDetailed_Description;
	double productCPrice;
	double productRPrice;
	int productStock_Quantity;
	String product_cat;
	String productImage;
	int sold;
	
	public product(int productID,String productName,String productBrief_Description, String productDetailed_Description,double productCPrice,double productRPrice,int productStock_Quantity,String product_cat,String productImage,int sold) {
		this.productID = productID;
		this.productName =  productName;
		this.productBrief_Description = productBrief_Description;
		this.productDetailed_Description = productDetailed_Description;
		this.productCPrice = productCPrice;
		this.productRPrice = productRPrice;
		this.productStock_Quantity = productStock_Quantity;
		this.product_cat = product_cat;
		this.productImage = productImage;
		this.sold = sold;
	}
	public product() {
		
	}
	public int getProductID() {
		return productID;
	}
	public void setProductID(int productID) {
		this.productID = productID;
	}
	public String getProductName() {
		return productName;
	}
	public void setProductName(String productName) {
		this.productName = productName;
	}
	public String getProductBrief_Description() {
		return productBrief_Description;
	}
	public void setProductBrief_Description(String productBrief_Description) {
		this.productBrief_Description = productBrief_Description;
	}
	public String getProductDetailed_Description() {
		return productDetailed_Description;
	}
	public void setProductDetailed_Description(String productDetailed_Description) {
		this.productDetailed_Description = productDetailed_Description;
	}
	public double getProductCPrice() {
		return productCPrice;
	}
	public void setProductCPrice(double productCPrice) {
		this.productCPrice = productCPrice;
	}
	public double getProductRPrice() {
		return productRPrice;
	}
	public void setProductRPrice(double productRPrice) {
		this.productRPrice = productRPrice;
	}
	public int getProductStock_Quantity() {
		return productStock_Quantity;
	}
	public void setProductStock_Quantity(int productStock_Quantity) {
		this.productStock_Quantity = productStock_Quantity;
	}
	public String getProduct_cat() {
		return product_cat;
	}
	public void setProduct_cat(String product_cat) {
		this.product_cat = product_cat;
	}
	public String getProductImage() {
		return productImage;
	}
	public void setProductImage(String productImage) {
		this.productImage = productImage;
	}
	public int getSold() {
		return sold;
	}
	public void setSold(int sold) {
		this.sold = sold;
	}
	
}
