package cl.buildersoft.web.servlet.timectrl.report.config;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.database.BSBeanUtils;
import cl.buildersoft.framework.util.BSFactory;
import cl.buildersoft.framework.web.servlet.BSHttpServlet_;
import cl.buildersoft.timectrl.business.beans.Report;
import cl.buildersoft.timectrl.business.beans.ReportPropertyBean;
import cl.buildersoft.timectrl.business.beans.ReportType;
import cl.buildersoft.timectrl.business.services.ReportService;

/**
 * Servlet implementation class OutConfigByReport
 */
@WebServlet("/servlet/timectrl/report/config/ReportReadProperties")
public class ReportReadProperties extends BSHttpServlet_ {
	private static final long serialVersionUID = 144367458920654781L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Long reportId = Long.parseLong(request.getParameter("cId"));

		BSBeanUtils bu = new BSBeanUtils();
		Connection conn = getConnection(request);

		Report report = searchReport(conn, bu, reportId);
		ReportType reportType = searchReportType(conn, bu, report);

		BSFactory factory = new BSFactory();
		ReportService service = (ReportService) factory.getInstance(reportType.getJavaClass());
		List<ReportPropertyBean> properties = service.loadReportProperties(conn, reportId);

		request.setAttribute("Report", report);
		request.setAttribute("ReportType", reportType);
		request.setAttribute("Properties", properties);

		closeConnection(conn);

		forward(request, response, "/WEB-INF/jsp/timectrl/report/config/report-read-properties.jsp");
	}

	public ReportType searchReportType(Connection conn, BSBeanUtils bu, Report report) {
		ReportType reportType = new ReportType();
		reportType.setId(report.getType());
		bu.search(conn, reportType);
		return reportType;
	}

	public Report searchReport(Connection conn, BSBeanUtils bu, Long reportId) {
		Report report = new Report();
		report.setId(reportId);
		bu.search(conn, report);
		return report;
	}
	/**
	 * <code>
	private List<ReportOutParam> listOutParam(Connection conn, Long reportId) {
		BSBeanUtils bu = new BSBeanUtils();
		List<ReportOutParam> out = (List<ReportOutParam>) bu.listAll(conn, new ReportOutParam());
		// List<ReportOutParam> out = (List<ReportOutParam>) bu.list(conn, new
		// ReportOutParam(), "cReport=?", reportId);
		return out;
	}

	private List<ReportOutValue> listParamValues(Connection conn, Long report) {
		BSBeanUtils bu = new BSBeanUtils();
		List<ReportOutValue> out = new ArrayList<ReportOutValue>();

		out = (List<ReportOutValue>) bu.list(conn, new ReportOutValue(), "cReport=?", report);

		 

		return out;
	}
	 
	private void getValue(Connection conn, ReportOutValue outValue) {
		String sql = "SELECT cValue FROM tReportOutValue WHERE cReport=? AND cParam=?;";

		List<Object> prms = new ArrayList<Object>();

		// prms.add(outValue.getType());
		prms.add(outValue.getReport());
		prms.add(outValue.getParam());

		BSmySQL mysql = new BSmySQL();
		String value = mysql.queryField(conn, sql, prms);

		outValue.setValue(value == null ? "" : value);
	}
</code>
	 */
}
