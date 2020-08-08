package myclasses;

public class ProductClass {
	private int productID;
	private String name;
	private double c_price;
	private double r_price;
	private int stockQty;
	private String productCat;
	private String briefDesc;
	private String detailedDesc;
	private String image;
	private String sold;
	
	public ProductClass (int productID, String name, double c_price, double r_price, int stockQty, String productCat,
			String briefDesc, String detailedDesc, String image, String sold){
		this.productID = productID;
		this.name = name;
		this.c_price = c_price;
		this.r_price = r_price;
		this.stockQty = stockQty;
		this.productCat = productCat;
		this.briefDesc = briefDesc;
		this.detailedDesc = detailedDesc;
		this.image = image;
		this.sold = sold;
	}

	public int getProductID() {
		return productID;
	}

	public void setProductID(int productID) {
		this.productID = productID;
	}

	public double getC_price() {
		return c_price;
	}

	public void setC_price(double c_price) {
		this.c_price = c_price;
	}

	public double getR_price() {
		return r_price;
	}

	public void setR_price(double r_price) {
		this.r_price = r_price;
	}

	public int getStockQty() {
		return stockQty;
	}

	public void setStockQty(int stockQty) {
		this.stockQty = stockQty;
	}

	public String getProductCat() {
		return productCat;
	}

	public void setProductCat(String productCat) {
		this.productCat = productCat;
	}

	public String getBriefDesc() {
		return briefDesc;
	}

	public void setBriefDesc(String briefDesc) {
		this.briefDesc = briefDesc;
	}

	public String getDetailedDesc() {
		return detailedDesc;
	}

	public void setDetailedDesc(String detailedDesc) {
		this.detailedDesc = detailedDesc;
	}

	public String getImage() {
		return image;
	}

	public void setImage(String image) {
		this.image = image;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getSold() {
		return sold;
	}

	public void setSold(String sold) {
		this.sold = sold;
	}
	
}
