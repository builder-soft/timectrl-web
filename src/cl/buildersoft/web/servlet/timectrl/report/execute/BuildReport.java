package cl.buildersoft.web.servlet.timectrl.report.execute;

import java.io.IOException;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import cl.buildersoft.framework.beans.DomainAttribute;
import cl.buildersoft.framework.database.BSBeanUtils;
import cl.buildersoft.framework.database.BSmySQL;
import cl.buildersoft.framework.exception.BSProgrammerException;
import cl.buildersoft.framework.util.BSHttpServlet;
import cl.buildersoft.timectrl.business.beans.Report;
import cl.buildersoft.timectrl.business.beans.ReportParameterBean;
import cl.buildersoft.timectrl.business.beans.ReportPropertyBean;
import cl.buildersoft.timectrl.business.beans.ReportType;
import cl.buildersoft.timectrl.business.console.BuildReport3;
import cl.buildersoft.timectrl.business.services.ReportService;

/**
 * Servlet implementation class BuildReport
 */
@WebServlet("/servlet/timectrl/report/execute/BuildReport")
public class BuildReport extends BSHttpServlet {
	private static final String REPORT_KEY = "ReportKey";
	private static final long serialVersionUID = 9102806701827080369L;

	@SuppressWarnings("unchecked")
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Connection conn = getConnection(request);
		String reportKey = readParameterOrAttribute(request, REPORT_KEY);
		Report report = getReport(conn, reportKey);
		Long reportId = report.getId();
		ReportType reportType = getReportType(conn, report);

		ReportService reportService = getInstance(conn, report);

		List<ReportParameterBean> reportParameterList = reportService.loadParameter(conn, reportId);
		List<String> parameters = readParametersFromPage(reportParameterList, request);

		List<ReportPropertyBean> reportPropertyList = reportService.loadReportProperties(conn, reportId);
		reportService.fillParameters(reportParameterList, parameters);

		List<String> responseList = null;
		if (reportService.runAsDetachedThread()) {
			HttpSession session = request.getSession(false);
			Map<String, DomainAttribute> domainAttribute = (Map<String, DomainAttribute>) session.getAttribute("DomainAttribute");

			reportService.setConnectionData(domainAttribute.get("database.driver").getValue(),
					domainAttribute.get("database.server").getValue(), domainAttribute.get("database.database").getValue(),
					domainAttribute.get("database.password").getValue(), domainAttribute.get("database.username").getValue());

			reportService.setReportId(reportId);
			reportService.setReportParameterList(reportParameterList);
			reportService.setReportPropertyList(reportPropertyList);
			reportService.setReportType(reportType);

			Thread thread = new Thread(reportService, reportService.getClass().getName());
			thread.start();
			responseList = new ArrayList<String>();
			responseList.add("La solicitud se esta procesando de manera desatendida.");
		} else {
			responseList = reportService.execute(conn, reportId, reportType, reportPropertyList, reportParameterList);
		}

		new BSmySQL().closeConnection(conn);

		Map<Integer, String> responseMap = new HashMap<Integer, String>();
		Integer index = 0;

		if (responseList == null) {
			responseList = new ArrayList<String>();
		}

		for (String responseString : responseList) {
			responseMap.put(index++, responseString);
		}

		request.setAttribute("ResponseMap", responseMap);
		request.getSession().setAttribute("ResponseMap", responseMap);

		forward(request, response, "/WEB-INF/jsp/timectrl/report/execute/show-resonse.jsp");
	}

	private ReportType getReportType(Connection conn, Report report) {
		ReportType reportType = new ReportType();
		BSBeanUtils bu = new BSBeanUtils();
		reportType.setId(report.getType());
		if (!bu.search(conn, reportType)) {
			throw new BSProgrammerException("Report type '" + report.getType() + "' not found.");
		}
		return reportType;
	}

	public ReportService getInstance(Connection conn, Report report ) {
		BuildReport3 br3 = new BuildReport3();
		return br3.getInstance(conn, report);

		/**
		 * <code>
		ReportService instance = null;
		try {
			Class<ReportService> javaClass = (Class<ReportService>) Class.forName(reportType.getJavaClass());
			instance = (ReportService) javaClass.newInstance();
		} catch (Exception e) {
			e.printStackTrace();
			throw new BSProgrammerException(e);
		}
		return instance;
</code>
		 */
	}

	private List<String> readParametersFromPage(List<ReportParameterBean> reportInputParamList, HttpServletRequest request) {
		List<String> out = new ArrayList<String>();
		String name = null;
		for (ReportParameterBean reportInputParam : reportInputParamList) {
			name = reportInputParam.getName();

			out.add(request.getParameter(name));
		}

		return out;
	}

	private Report getReport(Connection conn, String reportKey) {
		BSBeanUtils bu = new BSBeanUtils();

		Report out = new Report();
		bu.search(conn, out, "cKey=?", reportKey);

		return out;
	}

}
