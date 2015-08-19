package cl.buildersoft.framework.report;

import java.util.ArrayList;
import java.util.List;

import cl.buildersoft.timectrl.business.beans.BSParamReport;


public class BSReport {
	private String spName = null;
	private String title = null;
	private List<BSParamReport> paramReportList = new ArrayList<BSParamReport>();
	private String uri = null;

	public String getSpName() {
		return spName;
	}

	public void setSpName(String spName) {
		this.spName = spName;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public void addParamReport(BSParamReport paramReport) {
		paramReportList.add(paramReport);
	}

	public List<BSParamReport> listParamReport() {
		return this.paramReportList;
	}

	public String getUri() {
		return uri;
	}

	public void setUri(String uri) {
		this.uri = uri;
	}
}
