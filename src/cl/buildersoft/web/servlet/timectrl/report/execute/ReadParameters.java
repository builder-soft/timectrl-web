package cl.buildersoft.web.servlet.timectrl.report.execute;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.database.BSBeanUtils;
import cl.buildersoft.framework.database.BSmySQL;
import cl.buildersoft.framework.exception.BSProgrammerException;
import cl.buildersoft.framework.web.servlet.BSHttpServlet_;
import cl.buildersoft.timectrl.business.beans.Report;
import cl.buildersoft.timectrl.business.beans.ReportParameterBean;
import cl.buildersoft.timectrl.business.beans.ReportType;
import cl.buildersoft.timectrl.business.console.BuildReport3;
import cl.buildersoft.timectrl.business.services.ParameterService;
import cl.buildersoft.timectrl.business.services.ReportService;

/**
 * Servlet implementation class ReadParameters
 */
@WebServlet("/servlet/timectrl/report/execute/ReadParameters")
public class ReadParameters extends BSHttpServlet_ {
	private static final long serialVersionUID = -1242130448055981992L;

	@SuppressWarnings("unchecked")
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Long reportId = Long.parseLong(readParameterOrAttribute(request, "reportId"));

		BSBeanUtils bu = new BSBeanUtils();
		Connection conn = getConnection(request);

		Report report = getReport(reportId, bu, conn);
		ReportType reportType = getReportType(conn, bu, report);

		ReportService reportService = getInstance(conn, report);

		List<ReportParameterBean> reportParameterList = reportService.loadParameter(conn, reportId);
		String source = null;
		for (ReportParameterBean reportParameter : reportParameterList) {
			source = reportParameter.getTypeSource();

			if (source != null && source.length() > 0) {
				// Object data = reportService.getParameterData(conn,
				// reportParameter);
				Object data = getParameterData(conn, reportParameter);

				// ResultSet rs = executeSP(conn, source);
				request.setAttribute(reportParameter.getTypeKey(), data);
			}
		}

		request.setAttribute("ReportParameter", reportParameterList);
		request.setAttribute("Report", report);

		String page = bootstrap(conn) ? "/WEB-INF/jsp/timectrl/report/execute/params-report.jsp"
				: "/WEB-INF/jsp/timectrl/report/execute/params-report.jsp";

		closeConnection(conn);
		forward(request, response, page);

	}

	private Map<String, Object> getParameterData(Connection conn, ReportParameterBean reportParameter) {
		BuildReport3 br3 = new BuildReport3();
		ParameterService parameterService = br3.getInstanceOfParameter(reportParameter);

		Map<String, Object> out = parameterService.getParameterData(conn, reportParameter);

		return out;

	}

	private ResultSet executeSP(Connection conn, String typeSource) {
		BSmySQL mysql = new BSmySQL();
		ResultSet out = mysql.callSingleSP(conn, typeSource, null);
		return out;
	}

	private ReportService getInstance(Connection conn, Report report) {
		BuildReport3 br = new BuildReport3();
		ReportService instance = br.getInstance(conn, report);
		return instance;
	}

	private Report getReport(Long reportId, BSBeanUtils bu, Connection conn) {
		Report report = new Report();
		report.setId(reportId);
		if (!bu.search(conn, report)) {
			throw new BSProgrammerException("El reporte '" + reportId + "' no existe");
		}
		return report;
	}

	private ReportType getReportType(Connection conn, BSBeanUtils bu, Report report) {
		ReportType reportType = new ReportType();
		reportType.setId(report.getType());
		if (!bu.search(conn, reportType)) {
			throw new BSProgrammerException("El tipo de reporte '" + report.getType() + "' no existe");
		}
		return reportType;
	}

}
