package myclasses;

public class role {
	private String rolename;
	private String roleid;
	public role() {
		
	}
	public role(String rolename,String roleid) {
		this.rolename = rolename;
		this.roleid = roleid;
	}
	public String getRolename() {
		return rolename;
	}
	public void setRolename(String rolename) {
		this.rolename = rolename;
	}
	public String getRoleid() {
		return roleid;
	}
	public void setRoleid(String roleid) {
		this.roleid = roleid;
	}
}
