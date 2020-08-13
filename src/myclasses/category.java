package myclasses;


public class category {
	int categoryID;
	String category_name;
	String category_image;
	
	public category(int categoryID,String category_name,String category_image) {
		this.categoryID = categoryID;
		this.category_name = category_name;
		this.category_image = category_image;
	}
	public category() {
		
	}
	public int getCategoryID() {
		return categoryID;
	}
	public void setCategoryID(int categoryID) {
		this.categoryID = categoryID;
	}
	public String getCategory_name() {
		return category_name;
	}
	public void setCategory_name(String category_name) {
		this.category_name = category_name;
	}
	public String getCategory_image() {
		return category_image;
	}
	public void setCategory_image(String category_image) {
		this.category_image = category_image;
	}
	
	
}
