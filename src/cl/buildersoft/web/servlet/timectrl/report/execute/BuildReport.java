package cl.buildersoft.web.servlet.timectrl.report.execute;

import java.io.IOException;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import cl.buildersoft.framework.beans.DomainAttribute;
import cl.buildersoft.framework.database.BSBeanUtils;
import cl.buildersoft.framework.exception.BSProgrammerException;
import cl.buildersoft.framework.util.BSHttpServlet;
import cl.buildersoft.timectrl.business.beans.Employee;
import cl.buildersoft.timectrl.business.beans.Report;
import cl.buildersoft.timectrl.business.beans.ReportParameterBean;
import cl.buildersoft.timectrl.business.beans.ReportPropertyBean;
import cl.buildersoft.timectrl.business.beans.ReportType;
import cl.buildersoft.timectrl.business.console.BuildReport3;
import cl.buildersoft.timectrl.business.services.EmployeeService;
import cl.buildersoft.timectrl.business.services.ReportService;
import cl.buildersoft.timectrl.business.services.impl.EmployeeServiceImpl;

/**
 * Servlet implementation class BuildReport
 */
@WebServlet("/servlet/timectrl/report/execute/BuildReport")
public class BuildReport extends BSHttpServlet {
	private static final Logger LOG = Logger.getLogger(BuildReport.class.getName());
	private static final String REPORT_KEY = "ReportKey";
	private static final long serialVersionUID = 9102806701827080369L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		BuildReport3 br3 = new BuildReport3();
		Connection conn = getConnection(request);
		
		br3.setConnection(conn);
		
		closeConnection(conn);
		forward(request, response, "/WEB-INF/jsp/timectrl/report/execute/show-response.jsp");
	}

	protected void service_(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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

		List<String> responseList = new ArrayList<String>();

		// ********************************************************
		ReportParameterBean bossId = reportService.getReportParameter(reportParameterList, "BOSS_LIST");

		if (bossId != null && "0".equalsIgnoreCase(bossId.getValue())) {
			EmployeeService es = new EmployeeServiceImpl();
			List<Employee> bossList = es.listBoss(conn);

			List<ReportParameterBean> parameterListBackup = cloneParameterList(reportParameterList);

			for (Employee boss : bossList) {
				bossId.setValue(boss.getId().toString());
				responseList.addAll(executeReport(conn, request, reportId, reportType, reportService, reportParameterList,
						reportPropertyList));
				reportParameterList = cloneParameterList(parameterListBackup);
				bossId = reportService.getReportParameter(reportParameterList, "BOSS_LIST");
			}
		} else {
			responseList = executeReport(conn, request, reportId, reportType, reportService, reportParameterList,
					reportPropertyList);
		}

		// ********************************************************

		closeConnection(conn);

		if (reportService.runAsDetachedThread()) {
			responseList.clear();
			responseList.add("La solicitud se esta procesando de manera desatendida.");
		}

		Map<Integer, String> responseMap = new HashMap<Integer, String>();
		Integer index = 0;

		for (String responseString : responseList) {
			responseMap.put(index++, responseString);
		}

		request.setAttribute("ResponseMap", responseMap);
		request.getSession().setAttribute("ResponseMap", responseMap);

		forward(request, response, "/WEB-INF/jsp/timectrl/report/execute/show-resonse.jsp");
	}

	private List<ReportParameterBean> cloneParameterList(List<ReportParameterBean> sourceList) {
		List<ReportParameterBean> out = new ArrayList<ReportParameterBean>(sourceList.size());

		for (ReportParameterBean item : sourceList) {
			try {
				out.add((ReportParameterBean) item.clone());
			} catch (CloneNotSupportedException e) {
				LOG.log(Level.SEVERE, e.getMessage(), e);
			}
		}

		return out;
	}

	private List<String> executeReport(Connection conn, HttpServletRequest request, Long reportId, ReportType reportType,
			ReportService reportService, List<ReportParameterBean> reportParameterList,
			List<ReportPropertyBean> reportPropertyList) {
		List<String> responseList;
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
		return responseList;
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

	public ReportService getInstance(Connection conn, Report report) {
		BuildReport3 br3 = new BuildReport3();
		return br3.getInstance(conn, report);
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
