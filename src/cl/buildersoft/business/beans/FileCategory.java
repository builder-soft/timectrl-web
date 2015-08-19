package cl.buildersoft.business.beans;

import cl.buildersoft.framework.beans.BSBean;

public class FileCategory extends BSBean {
	private static final long serialVersionUID = 5410796614055070020L;
	private String TABLE = "tFileCategory";
	private String name = null;

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	@Override
	public String toString() {
		return "FileCategory [name=" + name + "]";
	}

}
