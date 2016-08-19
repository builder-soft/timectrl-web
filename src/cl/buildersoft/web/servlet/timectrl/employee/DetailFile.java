package cl.buildersoft.web.servlet.timectrl.employee;

import java.io.Serializable;

public class DetailFile implements Serializable {
	private static final long serialVersionUID = 1L;
	private Integer rowNumber = null;
	private String message = null;
	private String type = null;
	private String rut = null;
	private String start = null;
	private String end = null;
	private String document = null;

	public Integer getRowNumber() {
		return rowNumber;
	}

	public void setRowNumber(Integer rowNumber) {
		this.rowNumber = rowNumber;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getRut() {
		return rut;
	}

	public void setRut(String rut) {
		this.rut = rut;
	}

	public String getStart() {
		return start;
	}

	public void setStart(String start) {
		this.start = start;
	}

	public String getEnd() {
		return end;
	}

	public void setEnd(String end) {
		this.end = end;
	}

	public String getDocument() {
		return document;
	}

	public void setDocument(String document) {
		this.document = document;
	}

	@Override
	public String toString() {
		return "DetailFile [rowNumber=" + rowNumber + ", message=" + message + ", type=" + type + ", rut=" + rut + ", start="
				+ start + ", end=" + end + ", document=" + document + "]";
	}

}
